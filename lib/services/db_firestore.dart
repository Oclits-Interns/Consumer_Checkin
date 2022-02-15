import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference _consumersCollection = FirebaseFirestore.instance.collection("Consumers");
  CollectionReference userCollection = FirebaseFirestore.instance.collection("Consumers");

  Future addUser(String name, String email, String password, String uid) async {
    try {
      return await userCollection.doc(uid).set({
        "userName" : name,
        "Email" : email,
        "Password" : password
      });
    }
    catch(e) {
      print(e.toString());
    }
  }

  Future addConsumerEntry({
    required String consumerID,
    required int zone,
    required int ward,
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
    required String street,
    required String block,
    required String uc,
    required String area,
    required int houseNum,
    required String taluka,
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
        "Street": street,
        "Taluka": taluka,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}