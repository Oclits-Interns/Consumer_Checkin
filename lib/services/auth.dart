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

  //Sign in with phone
  Future signInWithPhone(String phoneNumber,) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!

          // Sign the user in (or link) with the auto-generated credential
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
          // Handle other errors
        },
        codeSent: (String verificationId, int? resendToken) async {
          // Update the UI - wait for the user to enter the SMS code
          String smsCode = 'xxxx';

          // Create a PhoneAuthCredential with the code
          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

          // Sign the user in (or link) with the credential
          await _auth.signInWithCredential(credential);
        },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }

  //sign in
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      var message = '';
      switch (e.code) {
        case 'invalid-email':
          message = "You have entered an invalid email";
          break;
        case "user-disabled":
          message = "It appears your account has been disabled";
          break;
        case "user-not-found":
          message = "You don't have an account yet, sign-up first";
          break;
        case "wrong-password":
          message = "You have entered incorrect password";
          break;
      }
      return message;
    } catch (e) {
      print('''
    caught exception\n
    $e
  ''');
      rethrow;
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
      if (user!= null && !user.emailVerified) {
        await user.sendEmailVerification();
        // if user verifies their email
          return _userFromFirebaseUser(user);
      }
    }
    on FirebaseAuthException catch (e) {
      var message = '';
      switch (e.code) {
        case 'email-already-in-use':
          message = "This email is already registered with another account";
          break;
        case "invalid-email":
          message = "You have entered an invalid email";
          break;
        case "operation-not-allowed":
          message = "There seems to be a problem signing up, please try again at a different time";
          break;
        case "weak-password":
          message = "This password is too weak";
          break;
      }
      return message;
    } catch (e) {
      print('''
    caught exception\n
    $e
  ''');
      rethrow;
    }
  }
}