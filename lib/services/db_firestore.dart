import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference _consumersCollection = FirebaseFirestore.instance.collection("Consumers");
  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Future addUser(
      {
        required String name,
        required String email,
        required String password,
        required String otp,
        required String authenticated,
        required String uid}) async {
    try {
      return await userCollection.doc(uid).set({
        "userName" : name,
        "Email" : email,
        "Password" : password,
        "OTP" : otp,
        "Authenticated" : authenticated
      });
    }
    catch(e) {
      print(e.toString());
    }
  }

  Future addConsumerEntry({
    required String consumerID,
    required String zone,
    required String ward,
    required String plotType,
    required String name,
    required String number,
    required String email,
    required String address,
    required String gasCompany,
    required String electricCompany,
    required String landlineCompany,
    required GeoPoint location,
    required String nicNum,
    required String unitNum,
    required String block,
    required String uc,
    required String area,
    required int houseNum,
    required String taluka,
    required String url,
    required String loggedInUser,
    required String loggedInEmail,
    required String dateTime,
  }) async {
    try {
      return await _consumersCollection.add({
        "ConsumerID": consumerID,
        "Zone": zone,
        "Ward": ward,
        "Name": name,
        "Number": number,
        "Email": email,
        "Address": address,
        "GasCompany": gasCompany,
        "ElectricCompany": electricCompany,
        "LandlineCompany": landlineCompany,
        "location": location,
        "Plot_type": plotType,
        "NicNumber": nicNum,
        "HouseNO": houseNum,
        "Area": area,
        "Block": block,
        "UC": uc,
        "UnitNumber": unitNum,
        "Taluka": taluka,
        "URL" : url,
        "Surveyor_Name" : loggedInUser,
        "Surveyor_Email" : loggedInEmail,
        "Date_Time" : dateTime
      });
    } catch (e) {
      print(e.toString());
    }
  }

/*  Future editData({
  required String consumerID,
  required String zone,
  required String ward,
  required String plotType,
  required String name,
  required String number,
  required String email,
  required String address,
  required String newAddress,
  required String gasCompany,
  required String electricCompany,
  required String landlineCompany,
  required GeoPoint location,
  required String nicNum,
  required String unitNum,
  required String block,
  required String uc,
  required String area,
  required int houseNum,
  required String taluka}) async {
    try{
      return await _consumersCollection.doc().update({
        "ConsumerID": consumerID,
        "Zone": zone,
        "Ward": ward,
        "Name": name,
        "Number": number,
        "Email": email,
        "Address": address,
        "NewAddress": newAddress,
        "GasCompany": gasCompany,
        "ElectricCompany": electricCompany,
        "LandlineCompany": landlineCompany,
        "location": location,
        "Plot_type": plotType,
        "NicNumber": nicNum,
        "HouseNO": houseNum,
        "Area": area,
        "Block": block,
        "UC": uc,
        "UnitNumber": unitNum,
        "Taluka": taluka,
      });
    }
    catch (e) {
      throw Exception(e.toString());
    }
  }*/

  Future<bool> getOtp(String otp) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('OTP', isEqualTo: otp)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Future<bool> doesNumberAlreadyExist(String mobNumber) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Consumers')
        .where('Number', isEqualTo: mobNumber)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Future<bool> doesNicNumberAlreadyExist(String cnicNumber) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Consumers')
        .where('NicNumber', isEqualTo: cnicNumber)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Future<bool> doesEmailAlreadyExist(String email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Consumers')
        .where('Email', isEqualTo: email)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Future<int> countEntriesInZoneWard(String zone, String ward) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Consumers')
        .where('Zone', isEqualTo: zone)
        .where("Ward", isEqualTo: ward)
                .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length;
  }
}