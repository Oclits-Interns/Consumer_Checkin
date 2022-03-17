import 'package:consumer_checkin/models/TheUser.dart';
import 'package:consumer_checkin/screens/authentication/authenticate.dart';
import 'package:consumer_checkin/screens/authentication/verify_email.dart';
import 'package:consumer_checkin/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    //Display either the authentication screens or home screen
    if(user == null) {
      return const Authenticate();
    }
    else if(!user.emailVerified) {
      return VerifyEmail();
    }
    else {
      return const Home();
    }
  }
}
