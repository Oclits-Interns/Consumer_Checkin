import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumer_checkin/constant/colors_constant.dart';
import 'package:consumer_checkin/services/db_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);
  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

bool isAuthenticated = false;

class _VerifyEmailState extends State<VerifyEmail> {
  String message = "A confirmation email is sent to your email address, click the link in the email to verify your account";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController otpController = TextEditingController();
  String otp = "";

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMaroon,
        title: const Text("Verify your Email"),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {_auth.signOut();},
              child: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("A 6 digit OTP has been sent to the admin, enter that OTP below",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400
              ),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: TextFormField(
                controller: otpController,
                decoration: InputDecoration(
                  hintText: "Enter OTP",
                  border: const OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                      onTap: () async {
                        isAuthenticated = await DatabaseService().getOtp(otp);
                        FirebaseFirestore.instance.collection("users").doc(user!.uid).update(
                            {"Authenticated" : isAuthenticated});
                      },
                      child: const Icon(Icons.arrow_forward)),
                ),
                onChanged: (val) {setState(() => otp = val);},
              ),
            ),
            const SizedBox(height: 10,),
            Divider(thickness: 1.5, color: kYellow,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16
                ),),
            ),
            // user!.emailVerified ?
            //     const Text("Your email is confirmed, you can continue signing in")
            // : const Text("An email has been sent to your email address, please follow the instructions to verify your account"),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                onTap: () async {
                  await user!.reload();
                  user = _auth.currentUser;
                  if(user!.emailVerified) {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        content: const Text("Your email has been verified, now enter OTP from admin"),
                        actions: [
                          GestureDetector(
                              child: const Text("Close"),
                          onTap: () {
                                Navigator.pop(context);
                          },)
                        ],
                      );
                    });
                    }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: kMaroon,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: const Center(child: Text("Check email verification", style: TextStyle(
                    color: Colors.white
                  ),)),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            const Text("Didn't receive an email? Click below to resend"),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                onTap: () {
                  user!.sendEmailVerification();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: kYellow,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: const Center(
                      child: Text(
                    "Resend email",
                    style: TextStyle(
                      color: Colors.white
                  ),)),
                ),
              ),
            ),
          ],
        ),
      )
      // user!.emailVerified ? const Center(child: Text("Your Email is verified, you can continue to login"))
      //     : const Center(child: Text("Please verify your email address")),
    );
  }
}
