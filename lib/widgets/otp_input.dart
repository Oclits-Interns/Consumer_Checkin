import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumer_checkin/services/db_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/colors_constant.dart';

class OtpConfirmation extends StatefulWidget {
  const OtpConfirmation({Key? key}) : super(key: key);

  @override
  State<OtpConfirmation> createState() => _OtpConfirmationState();
}

bool isAuthenticated = false;

class _OtpConfirmationState extends State<OtpConfirmation> {

  TextEditingController otpController = TextEditingController();
  String otp = "";

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<User?>(context);


      return Column(
        children: [
          Divider(thickness: 1.5, color: kYellow,),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
            child: Text(
              "A 6 digit OTP has been sent to the admin, enter that OTP below",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400
              ),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: TextFormField(
              maxLength: 6,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  letterSpacing: 6
              ),
              controller: otpController,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                border: const OutlineInputBorder(),
                suffixIcon: GestureDetector(
                    onTap: () async {
                      isAuthenticated = await DatabaseService().getOtp(otp);
                      FirebaseFirestore.instance.collection("users").doc(
                          user!.uid).update(
                          {"Authenticated": isAuthenticated});
                    },
                    child: const Icon(Icons.arrow_forward)),
              ),
              onChanged: (val) {
                setState(() => otp = val);
              },
            ),
          ),
        ],
      );
  }
}
