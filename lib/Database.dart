import 'dart:core';
import 'dart:io';
import 'package:passpuss/passentry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sqlcipher/sqlcipher.dart';
import 'package:flutter_sqlcipher/sqlite.dart';
import 'package:passpuss/main.dart';

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

  Future<SQLiteDatabase> initDB() async {
    Directory databases = await getApplicationDocumentsDirectory();
    String path = databases.path +
        "\\" +
        "PassPairs.db"; // get the path of the future database

    if (!await File(path).exists()) {
      _database = await SQLiteDatabase.openOrCreateDatabase(path,
          password: "xgWd793VL");
      await (await database).execSQL("CREATE TABLE PassEntries("
          "id INTEGER AUTO_INCREMENT PRIMARY KEY,"
          "USERNAME TEXT,"
          "PASSWORD TEXT,"
          "TITLE TEXT,"
          "ICONPATH TEXT"
          ")");
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
    var result = await db.insert(table: TABLE_NAME, values: map);
    return result;
  }

  Future<int> deletePassEntry(PassEntry entry) async {
    var db = await this.database;
    var result = await db.delete(
        table: TABLE_NAME, where: "id = ?", whereArgs: [entry.id.toString()]);
    return result;
  }

  Future<List<PassEntry>> getPassEntries() async {
    var db = await this.database;
    var result = await db.query(
      table: TABLE_NAME,
      columns: ["id", "USERNAME", "PASSWORD", "TITLE", "ICONPATH"],
    );
    List<PassEntry> passEntries = new List<PassEntry>();
    Set set = Set.from(result); // we use set for convenience(forEach method)
    set.forEach((v) =>
        passEntries.add(PassEntry.withIcon(
            v["USERNAME"], v["PASSWORD"], v["TITLE"], v["ICONPATH"])));
    PassEntriesPage.Pairs = passEntries;
    return passEntries;
  }
}
