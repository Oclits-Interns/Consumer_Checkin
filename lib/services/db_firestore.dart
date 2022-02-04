import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference _consumersCollection =
  FirebaseFirestore.instance.collection("Consumers");
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

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
    required int consumerID,
    required String name,
    required String number,
    required String email,
    required String address,
    required String newAddress,
    required String gasCompany,
    required String electricCompany,
    required String landlineCompany,
    required GeoPoint location,
  }) async {
    try {
      return await _consumersCollection.add({
        "ConsumerID": consumerID,
        "Name": name,
        "Number": number,
        "Email": email,
        "Address": address,
        "NewAddress": newAddress,
        "GasCompany": gasCompany,
        "ElectricCompany": electricCompany,
        "LandlineCompany": landlineCompany,
        "location": location,
      });
    } catch (e) {
      print(e.toString());
      //return;
    }
  }
}