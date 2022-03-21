import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumer_checkin/screens/authentication/authenticate.dart';
import 'package:consumer_checkin/screens/authentication/verify_email.dart';
import 'package:consumer_checkin/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  var _items;
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    return StreamBuilder(
        stream: user!=null ?
        FirebaseFirestore.instance.collection("users").doc(user.uid).snapshots() : null,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.none) {
            return const Authenticate();
          }
          else {
            if (user == null && !snapshot.hasData) {
              return const Authenticate();
            }
            if(snapshot.hasData) {
              var _items = snapshot.data;
              if (user!.emailVerified &&
                  (_items as dynamic)["Authenticated"] == true) {
                return const Home();
              }
              else {
                return const VerifyEmail();
              }}
            else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        });
    
    // //Display either the authentication screens or home screen
    // if(user == null) {
    //   return const Authenticate();
    // }
    // else if(!user.emailVerified) {
    //   return const VerifyEmail();
    // }
    // else {
    //   return const Home();
    // }
  }
}
