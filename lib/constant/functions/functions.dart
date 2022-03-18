import 'dart:math';
import 'package:consumer_checkin/services/google_sheets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

//The below functions are used in more than a single place

void updateConsumerSheet(String consumerID, Map<String, dynamic> _consumerRow) async {
  await ConsumerSheetsAPI.update(consumerID, _consumerRow);
}

Future deleteConsumerRow(String consumerId) async {
  await ConsumerSheetsAPI.deleteById(consumerId);
}

// Create our message.
String generateOTP() {
  var otp = "";
  var rnd = Random();
  for (var i = 0; i < 6; i++) {
    otp = otp + rnd.nextInt(9).toString();
  }
  return otp;
}

sendEmail(String otp, String userName, String email) async {
  String userEmail = 'nanapatigar778866@gmail.com';
  String password = 'maheenaapi.786';

  final smtpServer = gmail(userEmail, password);

  final message = Message()
    ..from = Address(userEmail, email)
    ..recipients.add('anaskhan8823@gmail.com')
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    // ..bccRecipients.add(Address('bccAddress@example.com'))
    ..subject = 'User verification for Consumer Check-in app'
    ..text = 'This is a confidential email, please do not share its contents with anyone except for the designated person.'
    ..html = "<h1>$otp</h1>\n<p> This is the OTP for the registration process of $userName </p>";

  try {
    final sendReport = await send(message, smtpServer);
  } on MailerException catch (e) {
    print(e);
    for (var p in e.problems) {
      print(p);
    }
  }
}