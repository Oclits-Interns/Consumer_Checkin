import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider {

  // make this a singleton class
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;
  static const userCredentialsTable = 'UserCredentials';
  static const consumersTable = "Consumers";
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
          Consumer_Id TEXT PRIMARY KEY  ,
          Plot_Type TEXT  ,
          Consumer_Name TEXT ,
          Number TEXT  ,
          CNIC TEXT  ,
          Email TEXT  ,
          Taluka TEXT ,
          UC_Num INT ,
          Zone_Num INT ,
          Ward_Num  INT  ,
          Area TEXT ,
          Street TEXT ,
          Block TEXT  ,
          House_Number  INT,
          Address TEXT  ,
          New_address TEXT ,
          Gas_Company_Id TEXT  ,
          Electricity_Company_Id TEXT  ,
          Landline_Company_Id TEXT
           )
           
          ''');
    });
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {

    if(_database == null) {
      _database = await initDB();
      return await _database!.rawQuery('SELECT * FROM $consumersTable');
    }
    else {
      return await _database!.rawQuery('SELECT * FROM $consumersTable');
    }
  }

  Future insertConsumerEntryOffline(String consumerId, String plotType, String name, String number, String email, String cnic, String taluka, int ucNum, int zone, int wardNumber, String area, String street, String block, int houseNum, String address, String newAddress, String gasCompany, String electricCompany, String landlineCompany) async {
    await _database!.execute('''
    INSERT INTO Consumers(Consumer_Id, Plot_Type, Consumer_Name, Number, Email, CNIC, Taluka, UC_Num, Zone_Num, Ward_Num, Area, Street, Block, House_Number, Address, New_Address, Gas_Company_Id, Electricity_Company_Id, Landline_Company_Id)
    VALUES ('$consumerId', '$plotType', '$name', '$number', '$email', '$cnic', '$taluka', '$ucNum', '$zone', '$wardNumber', '$area', '$street', '$block', '$houseNum', '$address', '$newAddress', '$gasCompany', '$electricCompany', '$landlineCompany') 
    ''');
  }

  void deleteFromConsumersTable() async {
    if(_database != null) {
      _database?.execute('DELETE FROM $consumersTable');
    }
  }

  Future<Database?> validateDBExistsWithoutInternet() async {
    {
      if (_database != null) return _database;
    }
    return null;
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
          CREATE TABLE IF NOT EXISTS $userCredentialsTable(
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
      SELECT COUNT(*) FROM $userCredentialsTable WHERE $email=? AND $password=?
    ''',
        ['$_email', '$_password'])
    );
    return userValidated;
  }


  //to clear a table content
  Future deleteSigninUser() async {
    _database = await db.validateDBAtLogin();
    _database?.rawQuery('''
      DELETE FROM $userCredentialsTable
    ''');
  }

  Future insertSigninUser(String _email, String _password) async {
    _database = await db.validateDBAtLogin();
    _database?.rawInsert('''
      INSERT INTO $userCredentialsTable($email, $password)  VALUES("$_email", "$_password")
    ''');
  }
}