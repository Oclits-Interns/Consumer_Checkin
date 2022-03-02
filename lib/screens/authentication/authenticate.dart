import 'package:consumer_checkin/screens/authentication/signIn_screen.dart';
import 'package:consumer_checkin/screens/authentication/signUp_screen.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignin = true;

  void toggleView() {
    setState(() {
      showSignin = !showSignin;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(showSignin){
      return SignIn(toggleView: toggleView);
    }
    else {
      return SignUp(toggleView: toggleView);
    }
  }
}