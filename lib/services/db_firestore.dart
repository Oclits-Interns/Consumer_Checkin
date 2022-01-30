import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference _consumersCollection =
      FirebaseFirestore.instance.collection("Consumers");

  Future addConsumerEntry(
      {required int consumerID,
      required String name,
      required String number,
      required String email,
      required String address,
      required String newAddress,
      required String gasCompany,
      required String electricCompany,
      required String landlineCompany,
      required double long,
      required GeoPoint location,
      required double lati}) async {
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
        "Longitute": long,
        "Latitute": lati,
        "location": location,
      });
    } catch (e) {
      print(e.toString());
      //return;
    }
  }
}
