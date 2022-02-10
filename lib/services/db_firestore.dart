import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference _consumersCollection =
      FirebaseFirestore.instance.collection("Consumers");

  Future addConsumerEntry({
    required String consumerID,
    required int zone,
    required int ward,
    required String plottype,
    required String name,
    required String number,
    required String email,
    required String address,
    required String newAddress,
    required String gasCompany,
    required String electricCompany,
    required String landlineCompany,
    required GeoPoint location,
    required String nicnumber,
    required String street,
    required String block,
    required String uc,
    required String area,
    required String houseno,
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
        "Plottype": plottype,
        "NicNumber": nicnumber,
        "HouseNO": houseno,
        "Area": area,
        "Block": block,
        "UC": uc,
        "Street": street,
        "Taluka": taluka,
      });
    } catch (e) {
      print(e.toString());
      //return;
    }
  }
}
