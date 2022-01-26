import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ConsumerDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Consumers ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "number INT,"
          "email_address TEXT,"
          "address TEXT,"
          "gas_company_id INT,"
          "electricity_company_id INT,"
          "landline_company_id INT,"
          ")");
    });
  }
}



/*
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class LocalDB {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path , "db_Consumer-Checkin");
    var database = await openDatabase(path, version: 1, onCreate: onCreate);
  }

  onCreate(Database database, int version) async {
    await database.execute("CREATE TABLE CONSUMER_RECORDS(Id INTEGER PRIMARY KEY, name TEXT, mobile INTEGER, email NVARCHAR, address TEXT, Electric company id INTEGER, Gas company Id INTEGER, Landline Id INTEGER )");
  }
}*/
