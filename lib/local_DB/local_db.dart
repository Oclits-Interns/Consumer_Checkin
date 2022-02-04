import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider {

  // make this a singleton class
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;
  static const table = 'UserCredentials';
  static const email = 'email';
  static const password = 'password';

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
      await db.execute('''
      CREATE TABLE IF NOT EXISTS Consumers(
          id INTEGER PRIMARY KEY  ,
          plot_type TEXT  ,
          name TEXT ,
          number INT  ,
          email_address TEXT  ,
          uc_num TEXT ,
          ward_num  TEXT  ,
          address TEXT  ,
          new_address TEXT ,
          gas_company_id INT  ,
          electricity_company_id INT  ,
          landline_company_id INT
           )
           
          ''');
    });
  }

  Future insertConsumerEntryOffline(int consumerId, String plotType, String name, String number, String email, String ucNum, String wardNumber, String address, String newAddress, String gasCompany, String electricCompany, String landlineCompany) async {
    await _database!.execute('''
    INSERT INTO Consumers(id, plot_type, name, number, email_address, uc_num, ward_num, address, new_address, gas_company_id, electricity_company_id, landline_company_id)
    VALUES ('$consumerId', '$plotType', '$name', '$number', '$email', '$ucNum', '$wardNumber', '$address', '$newAddress', '$gasCompany', '$electricCompany', '$landlineCompany') 
    ''');
  }

  Future<Database?> validateDBExistsWithoutInternet() async {
    {
      if (_database != null) return _database;
    }
  }

  Future<Database?> validateDBAtLogin() async {
    //Future<Database> get database async
    {
      if (_database != null) return _database;
      // lazily instantiate the db the first time it is accessed
      _database = await initDB();
      return _database;
    }
  }

  Future createTableAtLogin() async {


    _database = await db.validateDBAtLogin();
    await _database?.execute('''
          CREATE TABLE IF NOT EXISTS $table(
      $email nvarchar  ,
      $password nvarchar
  )
          ''');
  }

  //Validation without Internet connection
  Future<int> validateWithoutInternet(String _email, String _password) async {
    _database = await db.validateDBAtLogin();
    dynamic userValidated = Sqflite.firstIntValue(
        await _database!.rawQuery('''
      SELECT COUNT(*) FROM $table WHERE $email=? AND $password=?
    ''',
        ['$_email', '$_password'])
    );
    return userValidated;
  }


  //to clear a table content
  Future deleteSigninUser() async {
    _database = await db.validateDBAtLogin();
    _database?.rawQuery('''
      DELETE FROM $table
    ''');
  }

  Future insertSigninUser(String _email, String _password) async {
    _database = await db.validateDBAtLogin();
    _database?.rawInsert('''
      INSERT INTO $table($email, $password)  VALUES("$_email", "$_password")
    ''');
  }
}