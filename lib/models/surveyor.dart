import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Surveyor extends ChangeNotifier {
  final String email;
  final String username;
  Surveyor({required this.email, required this.username});

  Surveyor fromFirestore(DocumentSnapshot snapshot) {
    return Surveyor(email: snapshot["Email"], username: snapshot["userName"]);
  }
}