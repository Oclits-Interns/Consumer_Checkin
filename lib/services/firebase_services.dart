import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker_platform_interface/src/types/picked_file/unsupported.dart';

class DatabaseService {
  //Collection Reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Consumers");

  Future addConsumerData(
      String userId,
      String userName,
      String userEmail,
      String userMobile,
      String userAdress,
      String userNewAdress,
      String imageFile) async {
    return await userCollection.doc().set({
      "ConsumerUserID": userId,
      "ConsumerName": userName,
      "ConsumerEmail": userEmail,
      "ConsumerAddress": userAdress,
      "ConsumerNewAddress": userNewAdress,
      "ConsumerMobileNumber": userMobile,
      "imageFileURL": imageFile,
    });
  }

  Future consumerMoreDetails(
      String electricCompanyId, String gasCompanyId, String landLineId) async {
    return await FirebaseFirestore.instance.collection("Consumers").doc()
      ..collection("MoreDetails").add({
        "Category": electricCompanyId,
        "Item_name": gasCompanyId,
        "price": landLineId,
      });
  }
}
