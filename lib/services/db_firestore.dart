import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  CollectionReference _consumersCollection = FirebaseFirestore.instance.collection("Consumers");

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