import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void register() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    final String username = usernameController.text;

    final String email = emailController.text;
    final String password = passwordController.text;

    try {
      final UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      db.collection("user").doc(user.user!.uid).set({
        "user name": username,
        "email": email,
        "password": password,
      });
    } catch (e) {
      print("Error");
    }
  }
}
