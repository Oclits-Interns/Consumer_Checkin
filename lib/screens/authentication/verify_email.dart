import 'package:consumer_checkin/constant/colors_constant.dart';
import 'package:consumer_checkin/widgets/otp_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);
  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

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
                      color: Colors.white
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
            user!.emailVerified ? const OtpConfirmation() : Container(),
          ],
        ),
      )
      // user!.emailVerified ? const Center(child: Text("Your Email is verified, you can continue to login"))
      //     : const Center(child: Text("Please verify your email address")),
    );
  }
}
