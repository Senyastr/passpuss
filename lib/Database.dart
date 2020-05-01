import 'dart:io';
import 'dart:core';
import 'package:passpuss/passentry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  DBProvider._();
  static final DBProvider DB = DBProvider._();

  static Database _database;

  Future<Database> get database async{
    if (_database != null){
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future<Database>initDB() async {
    String databases = (await getDatabasesPath()) ;
    String path = databases + "\\" + "PassPairs.db"; // get the path of the future database

    _database = await openDatabase(path, version: 1, onCreate: (database, version) async {
      // here we execute "create table"
      // ID Primary key auto incremented
      // PASSWORD
      // TITLE
      // ICONPATH
      await database.execute("CREATE TABLE PassEntries("
          "id INTEGER AUTO_INCREMENT PRIMARY KEY,"
          "USERNAME TEXT,"
          "PASSWORD TEXT,"
          "TITLE TEXT,"
          "ICONPATH TEXT"
          ")"
      );
    });
    return _database;

  }
  static String TABLE_NAME = "PassEntries";
  Future<int> addPassEntry(PassEntry entry) async{
    Database db = await this.database;
    Map map = entry.toJson();
    map.remove("id");
    var result = await db.insert(TABLE_NAME, map);
    return result;
  }
  Future<int> deletePassEntry(PassEntry entry) async{
    Database db = await this.database;
    var result = await db.delete(TABLE_NAME, where: "id = ?", whereArgs: [entry.id]);
    return result;
  }
  Future<List<PassEntry>> getPassEntries() async{
    Database db = await this.database;
    var result = await db.query(
      TABLE_NAME,
      columns: [
        "id",
        "USERNAME",
        "PASSWORD",
        "TITLE",
        "ICONPATH"
      ],
    );
    List<PassEntry> passEntries = new List<PassEntry>();
    Set set = Set.from(result); // we use set for convenience(forEach method)
    set.forEach((v) =>
      passEntries.add(PassEntry.withIcon(
          v["USERNAME"],
          v["PASSWORD"],
          v["TITLE"],
          v["ICONPATH"])
      ));
    return passEntries;
  }
}