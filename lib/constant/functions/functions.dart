import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:consumer_checkin/services/google_sheets.dart';

//The below functions are used in more than a single place

void updateConsumerSheet(String consumerID, Map<String, dynamic> _consumerRow) async {
  await ConsumerSheetsAPI.update(consumerID, _consumerRow);
}

Future deleteConsumerRow(String consumerId) async {
  await ConsumerSheetsAPI.deleteById(consumerId);
}