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
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<User?>(context);

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: kMaroon,
        title: const Text("Verify your Email",
        style: TextStyle(
          color: Colors.black
        ),),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Text(
                message,
                style: const TextStyle(
                    fontSize: 16
                ),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                onTap: () async {
                  await user!.reload();
                  user = _auth.currentUser;
                  if(user!.emailVerified) {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        content: const Text("Your email has been verified, now enter OTP from admin, \n"
                            "if you have already entered OTP, then restart the app"),
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
                      color: Colors.black
                  ),)),
                ),
              ),
            ),
            const SizedBox(height: 40,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive an email?"),
                Padding(
                  padding: const EdgeInsets.only(left: 3.5),
                  child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email resent, please wait a few moments before clicking again")));
                        user!.sendEmailVerification();
                      },
                      child: Text("Click here to resend",
                        style: TextStyle(
                            color: kYellow
                        ),)),
                ),
              ],
            ),
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
                  if(isAuthenticated == true) {
                    FirebaseFirestore.instance.collection("users").doc(
                        user!.uid).update(
                        {"Authenticated": isAuthenticated});
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:
                    Text("OTP confirmed, you should now be redirected to home screen \n"
                        "If you are not redirected automatically, please restart the app and try again")));
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid OTP, please try again")));
                  }
                },
                child: const Icon(Icons.arrow_forward)),
          ),
          onChanged: (val) {
            setState(() => otp = val);
          },
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
