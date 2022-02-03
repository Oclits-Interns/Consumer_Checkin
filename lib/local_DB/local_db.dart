import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider {

  // make this a singleton class
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;
  static final table = 'UserCredentials';
  static final email = 'email';
  static final password = 'password';

  Future<Database?> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }



  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ConsumerDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE Consumers(
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "number INT,"
          "email_address TEXT,"
          "address TEXT,"
          "gas_company_id INT,"
          "electricity_company_id INT,"
          "landline_company_id INT"
          )''');
    });
  }

  Future<Database?> ValidateDBExistsWithoutInternet() async {
    {
      if (_database != null) return _database;
    }
  }

  Future<Database?> ValidateDBAtLogin() async {
    //Future<Database> get database async
    {
      if (_database != null) return _database;
      // lazily instantiate the db the first time it is accessed
      _database = await initDB();
      return _database;
    }
  }

  Future CreateTableAtLogin() async {


    _database = await db.ValidateDBAtLogin();
    await _database?.execute('''
          CREATE TABLE IF NOT EXISTS $table(
      $email nvarchar  ,
      $password nvarchar
  )
          ''');
  }

  //Validation without Internet connection
  Future<int> ValidateWithoutInternet(String _email, String _password) async {
    _database = await db.ValidateDBAtLogin();
    dynamic userValidated = Sqflite.firstIntValue(
        await _database!.rawQuery('''
      SELECT COUNT(*) FROM $table WHERE $email=? AND $password=?
    ''',
        ['$_email', '$_password'])
    );
    return userValidated;
  }
  //
  // //to delete entire table
  // Future deleteTable() async {
  //   return await _database?.execute('DELETE TABLE $table ');
  // }

  //to clear a table content
  Future DeleteSigninUser() async {
    _database = await db.ValidateDBAtLogin();
    _database?.rawQuery('''
      DELETE FROM $table
    ''');
  }

  Future InsertSigninUser(String _email, String _password) async {
    _database = await db.ValidateDBAtLogin();
    _database?.rawInsert('''
      INSERT INTO $table($email, $password)  VALUES("$_email", "$_password")
    ''');
  }
}