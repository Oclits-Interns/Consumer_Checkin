import 'package:consumer_checkin/models/consumer.dart';
import 'package:gsheets/gsheets.dart';

class ConsumerSheetsAPI {
  static const _credentials = r'''
    {
  "type": "service_account",
  "project_id": "consumer-sheet",
  "private_key_id": "d6054054a0b586942083557a184dabcb845bb282",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDHLJ/bdzK5tnnW\n6RtZBQONjTQthg0O6HSQGADfqRWZ1F9rMkyQugQIn4xEqnSvEe/NGp/9/6X9gIdk\nw5lSMA4LVXFQOWsHaC8Lf8rhyrqvRLA5VaTdelYxec4ASZCmCaDyB4pGofW542zy\nF/S5fVtEffmCkpZ7RxfnktyHTNwTFnWQI0p8oriw6IyR5P5eo0EbC6Bhl/3FnXmG\ngs1I6BAW4OiPwmLMdVuptqLuGSdrWphfEvN8heh3rpQ9Zuj5Z3p2hpPP/GazFdRG\n4OOw+RCiN6u4eAFULQlJihobg6KdqmsYyLP52xlxL/zGKjy+JiTls3o8IbczJPZ7\nEddDTvu1AgMBAAECggEAJy5V3yI+eg6Vvst6DAPCvGqZ6Fetw3BCl+ME7vqv62Q+\nBhQtwC27o+eg/BQNIrB0XER/00Nih7EsUUvyIhsedCfRg+7bqWgbExfHVS4gleB9\nCzZYGZKamJ6FwgQ2vpb30IzfrH/pWzFMSf6g74ljtiBTAFbuX99vKii3la0uwNkq\nA01zWKPowHEaUvUOi4pdaB7duUbRVXsPdqaun4w2wIfaRVE0na0uEUkAs5Ms/lZo\nSUM8stBHHNjFEYsID4+9pW2M08p05qY3o7EBX6fVIVOU/ekPkgqNR0VNXW8TH0Gd\n7SdXCUc3XwDwKSjP8RBnyIV/1+FHL46mjKv0Tv6yoQKBgQDs5bwldsVFYpduzD6K\n90kX2lmGEcx7Vxr562wAn6KISJYt/2zFArr9zNzuGkTscH8R94+acS1XHT/TnORC\ngSDqxnnKbMUqkW8Q90TULzhGvdrEjjcQZ4qEv8NBxvKh1YKQQqn4WgUbxy0jG4fe\ny8M4ev1oavvzZWhRs58XmKU1FQKBgQDXPCxOQkeOz4iThvbgSXv38sbdwp8fR8GU\nd1vRCkGCK+pCDIjodQwgpQQzS2E/aaaolu5Nguy05QVrFQ7yc0ulPnRnoBTYCmqg\nJW+Hu27purqNO7yTUSNXx4FX3dBASFeRO0F+W8lKGAgyzBazl5Bk01TgtVSgNV+N\nbQtxkMeUIQKBgQDQiylHHbhp7XH78sc4FJr+6ZQXx0FobvTrf8jy/5TYPnYehhXd\nlRrB5H+1B+EW962VRobfYbSVVMVkZ2A1/3DX3ONIRNqJL8BDgjnQRMVY2TdmAwAM\na+nwFNQx6o6b0tZ+YoE4hR6sJnngxxKkGmKALR05t7yWtvXPvr1Vy2XcRQKBgEbm\n7p11HgeAfDhFDIyECI98bWBeHXb7d1yGGTv6ievstYW+hVc2P6F9Wq3fFhECp8D/\nv07PY1SP4UIONNdPfcrYkRYV2Of2Pnu0+VGYQAhE1/FwjUVmRCNFeGlOi6yxaA9S\nmteaOuvqkMDTFGNi+VENgPdpJJCGJIz9L/jgPa6hAoGBANGMH/b3U/8R9V7QKsSk\njOVgb3mu5BjkL4xBAl2Wit8TyHTT/npWbcvAOvl1d0AjCwzjERQd1FqaANXwBgSi\nv035Wml0pmbZ1o18SHtLknbCkzAfp0rl2UXiTmFZD7HvHULCGMgLW+E4joh4zisC\nzUDPLGhFrpeKRiHUg5k9jITt\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@consumer-sheet.iam.gserviceaccount.com",
  "client_id": "109293864337851266198",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40consumer-sheet.iam.gserviceaccount.com"
    }
  ''';

  static const _spreadSheetId = "1-ES2tHNXy0sGERtfLE_tkEkIILpzXWEKqugsyUB7WZM";

  static final gsheets = GSheets(_credentials);

  static Worksheet? _consumerSheet;

  static Future init() async {
    final spreadsheet = await gsheets.spreadsheet(_spreadSheetId);
    _consumerSheet = await _getWorkSheet(spreadsheet, title: "Consumers");

    final firstRow = ConsumerFields.getFields();
    _consumerSheet?.values.insertRow(1, firstRow);
  }

  static Future<Worksheet?> _getWorkSheet(
      Spreadsheet spreadsheet,
      {required String title,}) async {
   try {
     return await spreadsheet.addWorksheet(title);
   }
   catch(e) {
     return spreadsheet.worksheetByTitle(title);
   }
  }
}