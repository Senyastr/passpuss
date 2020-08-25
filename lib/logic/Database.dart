import 'dart:core';
import 'dart:io';
import 'dart:isolate';
import 'package:PassPuss/logic/passentry.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sqlcipher/sqlite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider DB = DBProvider._();

  static SQLiteDatabase _database;

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

  static const String idColumn = "id";
  static const String usernameColumn = "USERNAME";
  static const String passwordColumn = "PASSWORD";
  static const String titleColumn = "TITLE";
  static const String iconPathColumn = "ICONPATH";
  static const String createdTimeColumn = "CREATEDTIME";
  static const String emailColumn = "EMAIL";
  static const String tagColumn = "TAG";
  Future<SQLiteDatabase> initDB() async {
    Directory databases = await getApplicationDocumentsDirectory();
    String path = databases.path +
        "\\" +
        "PassPairs.db"; // get the path of the future database

    if (!await File(path).exists()) {
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

  Future<int> addPassEntry(PassEntry entry) async {
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
    return 1;
  }

  Future<int> deletePassEntry(PassEntry entry) async {
    var db = await this.database;
    String id = entry.id.toString();
    var result =
        await db.delete(table: TABLE_NAME, where: "id=?", whereArgs: [id]);
    await this.closeDb();
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
    List<PassEntry> passEntries = new List<PassEntry>();
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
    return passEntries;
  }
}

typedef void GotPassEntries(List<PassEntry> entries);
Future<int> deletePassEntry(PassEntry entry) async {
  var db = await DBProvider.DB.database;
  String id = entry.id.toString();
  var result = await db
      .delete(table: DBProvider.TABLE_NAME, where: "id=?", whereArgs: [id]);
  await DBProvider.DB.closeDb();
  return result;
}
