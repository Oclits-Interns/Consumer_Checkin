import 'package:consumer_checkin/constant/colors_constant.dart';
import 'package:consumer_checkin/screens/home_screen.dart';
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
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                        return const Home();
                      }));
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
