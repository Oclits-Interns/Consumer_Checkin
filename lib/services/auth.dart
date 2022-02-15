import 'package:consumer_checkin/models/TheUser.dart';
import 'package:consumer_checkin/services/db_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj from firebase user
  TheUser? _userFromFirebaseUser(User user) {

    return User != null ? TheUser(user.uid) : null;
  }

  //Auth state change stream to listen for auth changes
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  //sign in
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      return _userFromFirebaseUser(user!);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try{
      return _auth.signOut();
    }
    catch(e) {
    }
  }

  //register
  Future register(String userName , String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      //create a new user with the uid
      await DatabaseService().addUser(userName, email, password, user!.uid);
      return _userFromFirebaseUser(user);
    }
    catch(e) {
      return null;
    }
  }

}