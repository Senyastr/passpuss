import 'dart:core';
import 'dart:io' as io;
import 'package:PassPuss/logic/autosync.dart';
import 'package:PassPuss/logic/passentry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sqlcipher/sqlite.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:cloud_firestore/cloud_firestore.dart';

class DBProvider extends ChangeNotifier {
  static const String idColumn = "id";
  static const String usernameColumn = "USERNAME";
  static const String passwordColumn = "PASSWORD";
  static const String titleColumn = "TITLE";
  static const String iconPathColumn = "ICONPATH";
  static const String createdTimeColumn = "CREATEDTIME";
  static const String emailColumn = "EMAIL";
  static const String tagColumn = "TAG";
  int entriesNumber = 0;
  static SQLiteDatabase _database;

  static bool _disposed = false;

  DBProvider._();

  static DBProvider DB = DBProvider._();

  static DBProvider getDB() {
    // we check if it's disposed first
    if (_disposed) {
      DB = DBProvider._();
      DBProvider._disposed = false;
    }
    return DB;
  }

  @override
  void dispose() {
    super.dispose();
    DBProvider._disposed = true;
  }

  Future<SQLiteDatabase> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  Future<bool> closeDb() async {
    if (_database != null) {
      try {
        await _database.close();
        _database = null;
        return true;
      } catch (x) {
        print(x.toString());
        return false;
      }
    }
  }

  static _getDBPath() async {
    io.Directory databases = await getApplicationDocumentsDirectory();
    String path = databases.path +
        "/" +
        "PassPairs.db"; // get the path of the future database
    return path;
  }

  Future<SQLiteDatabase> initDB() async {
    var path = await _getDBPath();
    if (!await io.File(path).exists()) {
      _database = await SQLiteDatabase.openOrCreateDatabase(path,
          password: "xgWd793VL");
      await (await database).execSQL("CREATE TABLE PassEntries("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "USERNAME TEXT,"
          "PASSWORD TEXT,"
          "TITLE TEXT,"
          "ICONPATH TEXT,"
          "CREATEDTIME TEXT,"
          "EMAIL TEXT,"
          "TAG TEXT)");
      return _database;
    }
    // here we execute "create table"
    // ID Primary key auto incremented
    // PASSWORD
    // TITLE
    // ICONPATH
    _database =
        await SQLiteDatabase.openOrCreateDatabase(path, password: "xgWd793VL");
    return _database;
  }

  static String TABLE_NAME = "PassEntries";

  Future<int> addPassEntry(PassEntry entry, {bool isSyncDrive = false}) async {
    SQLiteDatabase db = await this.database;
    Map map = entry.toJson();
    map.remove("id");
    var username = map[usernameColumn];
    var password = map[passwordColumn];
    var title = map[titleColumn];
    var iconPath = map[iconPathColumn];
    var createdTime = map[createdTimeColumn];
    var email = map[emailColumn];
    var tag = map[tagColumn];
    await db.execSQL("INSERT INTO $TABLE_NAME ($usernameColumn,"
        "$passwordColumn,"
        "$titleColumn,"
        "$iconPathColumn,"
        "$createdTimeColumn,"
        "$emailColumn,"
        "$tagColumn) "
        "VALUES ('$username',"
        "'$password',"
        "'$title',"
        "'$iconPath',"
        "'$createdTime',"
        "'$email', "
        "'$tag');");
    await this.closeDb();
    // AUTO SYNC
    if (isSyncDrive) {
      AutoSyncService.getService().serve(null);
    }
    entriesNumber++;
    notifyListeners();

    return 1;
  }

  Future<int> deletePassEntry(PassEntry entry,
      {bool isSyncDrive = false}) async {
    var db = await this.database;
    String id = entry.id.toString();
    var result =
        await db.delete(table: TABLE_NAME, where: "id=?", whereArgs: [id]);
    await this.closeDb();
    // AUTO SYNC
    if (isSyncDrive) {
      AutoSyncService.getService().serve(null);
    }
    entriesNumber--;
    notifyListeners();
    return result;
  }

  Future<List<PassEntry>> getPassEntries(
      GotPassEntries gotPassEntriesCallback) async {
    var db = await this.database;
    var result = await db.query(
      table: TABLE_NAME,
      columns: [
        idColumn,
        usernameColumn,
        passwordColumn,
        titleColumn,
        iconPathColumn,
        createdTimeColumn,
        emailColumn,
        tagColumn,
      ],
    );
    List<PassEntry> passEntries = [];
    Set set = Set.from(result); // we use set for convenience(forEach method)
    set.forEach((v) {
      var id = v[idColumn];
      var username = v[usernameColumn];
      var password = v[passwordColumn];
      var title = v[titleColumn];
      var iconPath = v[iconPathColumn];
      var createdTime = DateTime.parse(v[createdTimeColumn]);
      var email = v[emailColumn];
      var tag = Tags.values
          .firstWhere((element) => element.toString() == v[tagColumn]);
      passEntries.add(PassEntry.fromDB(
        id,
        username,
        password,
        title,
        iconPath,
        createdTime,
        email,
        tag,
      ));
    });
    if (gotPassEntriesCallback != null) {
      gotPassEntriesCallback(passEntries);
    }

    await this.closeDb();
    entriesNumber = passEntries.length;
    notifyListeners();
    return passEntries;
  }

  static GoogleAuthClient client;
  static signIn.GoogleSignInAccount account;

  // GOOGLE DRIVE
  static driveSignIn({bool signOutFirst = false}) async {
    var googleSignIn = signIn.GoogleSignIn.standard(
        scopes: [drive.DriveApi.DriveAppdataScope]);
    if (signOutFirst) {
      await googleSignIn.signOut();
    }
    signIn.GoogleSignInAccount account = await googleSignIn.signIn();

    final authHeaders = await account.authHeaders;
    client = GoogleAuthClient(authHeaders);
  }

  static Future<void> saveDrive({bool showAccounts = false}) async {
    // SIGN IN

    try {
      if (client == null) {
        await driveSignIn(signOutFirst: true);
      }
      final driveApi = new drive.DriveApi(client);
      // HERE WE REMOVE THE LAST BACKUP FILE IF IT EXISTS
      var fileList = await driveApi.files
          .list(q: "name = 'PassPairs.db'", spaces: 'appDataFolder');
      if (fileList.files.length > 0) {
        var idToRemove = fileList.files.first.id;
        var removeResult = await driveApi.files
            .delete(idToRemove); // for debug, never used in code
        fileList = await driveApi.files
            .list(q: "name = 'PassPairs.db'", spaces: 'appDataFolder');
      }

      // HERE WE TRANSFORM DB FILE INTO STREAM
      final file = await getDatabaseFile();

      final Stream<List<int>> mediaStream = file
          .openRead()
          .asBroadcastStream(); // here if is not broadcast stream, it won't send it
      final media = drive.Media(
          mediaStream,
          await file
              .length()); // getting media cocnver here outa the mediaStream
      print(
          "The size of the DB in bytes : " + (await file.length()).toString());
      var driveFile = new drive.File(); // creating file cover
      driveFile.name = "PassPairs.db"; // change name
      driveFile.parents =
          ["appDataFolder"].toList(); // send it to the app's folder
      final result = await driveApi.files
          .create(driveFile, uploadMedia: media); // creating the file

      print("Saved to Google Drive successfully! : ' " +
          result.toString() +
          " '");
    } on PlatformException catch (e) {
      print("Caught PlatformException : " + e.toString());
    }
  }

  // here we export the data from google drive to the app
  static Future<void> exportDrive() async {
    // SIGN IN
    try {
      if (account != null) {
        Firestore.instance.settings(persistenceEnabled: false);
        await account.clearAuthCache();
      }
    } on FormatException catch (e) {
      print(e);
    }

    await driveSignIn(signOutFirst: true);

    final driveApi = new drive.DriveApi(client);
    var listFiles = await driveApi.files
        .list(q: "name = 'PassPairs.db'", spaces: 'appDataFolder');
    // CHECK IF THE FILE EXISTS
    if (listFiles.files.length > 0) {
      // IF EXISTS, THEN EXPORT THE FILE TO THE APP
      var idDatabase = listFiles.files.first.id;
      drive.Media fileData = await driveApi.files
          .get(idDatabase, downloadOptions: drive.DownloadOptions.FullMedia);
      var file = await getDatabaseFile();
      if (await file.exists()) {
        await file.delete();
        file = await getDatabaseFile();
      }
      await file.create();
      await mediaToFile(fileData, file);
    }
  }

  static Future<void> mediaToFile(drive.Media fileData, io.File file) async {
    List<int> dataStore = [];
    fileData.stream.listen((data) {
      print("DataReceived: ${data.length}");
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      await file.writeAsBytes(
          dataStore); //Write to that file from the datastore you created from the Media stream; // Read String from the file //Finally you have your text
      print(await file.length());
      print("Import Done");
    }, onError: (error) {
      print("Some Error in import");
    });
    print(await file.length());
    print(file);
    await DBProvider.getDB().initDB();
  }

  static Future<io.File> getDatabaseFile() async {
    io.Directory databases = await getApplicationDocumentsDirectory();
    String path = databases.path + "/" + "PassPairs.db";
    return io.File(path);
  }
}


typedef void GotPassEntries(List<PassEntry> entries);
Future<int> deletePassEntry(PassEntry entry) async {
  var db = await DBProvider.getDB().database;
  String id = entry.id.toString();
  var result = await db
      .delete(table: DBProvider.TABLE_NAME, where: "id=?", whereArgs: [id]);
  await DBProvider.getDB().closeDb();

  return result;
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = new http.Client();

  GoogleAuthClient(this._headers);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

