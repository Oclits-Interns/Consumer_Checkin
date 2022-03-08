import 'package:consumer_checkin/services/google_sheets.dart';

//The below function is used in more than a single place
void updateConsumerSheet(String consumerID, Map<String, dynamic> _consumerRow) async {
  await ConsumerSheetsAPI.update(consumerID, _consumerRow);
}