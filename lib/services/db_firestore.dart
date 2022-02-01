import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference _consumersCollection = FirebaseFirestore.instance.collection("Consumers");
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

  Future addConsumerEntry(int consumerID, String name, String number, String email, String address , String newAddress, String gasCompany, String electricCompany, String landlineCompany, ) async {

    try{
      return await _consumersCollection.add({
        "ConsumerID" : consumerID,
        "Name" : name,
        "Number" : number,
        "Email" : email,
        "Address" : address,
        "NewAddress" : newAddress,
        "GasCompany" : gasCompany,
        "ElectricCompany" : electricCompany,
        "LandlineCompany" : landlineCompany,
      });
    }
    catch(e) {
      print(e.toString());
      //return;
    }
  }

}