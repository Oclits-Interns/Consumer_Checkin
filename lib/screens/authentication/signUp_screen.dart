import 'package:consumer_checkin/constant/colors_constant.dart';
import 'package:consumer_checkin/screens/authentication/verify_email.dart';
import 'package:consumer_checkin/services/auth.dart';
import 'package:consumer_checkin/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:consumer_checkin/local_DB/local_db.dart';

String _message = "";

class SignUp extends StatefulWidget {
  final void Function() toggleView;
  const SignUp({required this.toggleView, Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String _userName = "";
  String _email = "";
  String _password = "";


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMaroon,
        title: const Text("Sign up",
          style: TextStyle(
              color: Colors.black
          ),),
        centerTitle: true,
        leading: GestureDetector(
            child: const Icon(Icons.arrow_back, color: Colors.black),
          onTap: widget.toggleView,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Logo(),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: "Enter your user name",
                              prefixIcon: const Icon(Icons.person_outline_outlined)
                          ),
                          onChanged: (val) => setState(() {_userName = val;}),
                          validator: (String? val) {
                            if(val == null || val.trim().isEmpty) {
                              return "Please enter a valid user name";
                            }
                            else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: "Enter your Email",
                              prefixIcon: const Icon(Icons.email_outlined)
                          ),
                          onChanged: (val) => setState(() {_email = val;}),
                          validator: (String? val) {
                            if(val == null || val.trim().isEmpty) {
                              return "Please enter a valid email";
                            }
                            else {
                              return null;
                            }
                          },
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: "Enter your Password",
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                        ),
                        onChanged: (val) => setState(() {_password = val;}),
                        validator: (val) => val!.length< 6 ? 'Password must be 6 characters or more' : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () async {
                              if(_formKey.currentState!.validate()) {
                                DBProvider.db.createTableAtLogin();
                                DBProvider.db.insertSigninUser(_email, _password);
                                _message = await _auth.register(_userName, _email, _password) ?? "";
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                  return VerifyEmail();
                                }));
                              }
                              switch(_message) {
                                case "This email is already registered with another account":
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_message.toString())));
                                  break;
                                case "You have entered an invalid email":
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_message.toString())));
                                  break;
                                case "There seems to be a problem signing up, please try again at a different time":
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_message.toString())));
                                  break;
                                case "This password is too weak":
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_message.toString())));
                                  break;
                                default: showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text("Something went wrong.. " + _message.toString()),
                                    );
                                  }
                                );
                                break;
                              }
                            },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: kMaroon
                            ),
                            child: const Center(child: Text("Register", style: TextStyle(color: Colors.black),)),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 20.0),
                      //   child: GestureDetector(
                      //     onTap: widget.toggleView,
                      //     child: Container(
                      //       height: 50,
                      //       width: MediaQuery.of(context).size.width * 0.70,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(8),
                      //         color: kYellow,
                      //       ),
                      //       child: Center(child: Text("Return to Sign in", style: TextStyle(color: Colors.black),)),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
