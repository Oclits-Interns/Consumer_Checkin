import 'package:consumer_checkin/constant/colors_constant.dart';
import 'package:consumer_checkin/services/auth.dart';
import 'package:consumer_checkin/widgets/logo.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final void Function() toggleView;
  const SignIn({required this.toggleView, Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthService _auth = AuthService();
  String _email = "ali.naqvi@gmail.com";
  String _password = "123456";
  //bool _showPassword = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMaroon,
        title: const Text("Login",
        style: TextStyle(
          color: Colors.black
        ),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
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
                              hintText: "Enter your Email",
                              prefixIcon: Icon(Icons.email_outlined)
                            ),
                            onChanged: (val) => setState(() {_email = val;}),
                              validator: (String? val) {
                                if(val == null || val.trim().length == 0) {
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
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                          ),
                          onChanged: (val) => setState(() {_password = val;}),
                          validator: (val) => val!.length< 6 ? 'Password must be 6 characters or more' : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: GestureDetector(
                            onTap: () async {
                              if(_formKey.currentState!.validate()) {
                                await _auth.signInWithEmailAndPassword(_email, _password);
                              }
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: kMaroon
                              ),
                              child: Center(child: Text("Login", style: TextStyle(color: Colors.black),)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: GestureDetector(
                            onTap: widget.toggleView,
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: kYellow,
                              ),
                              child: Center(child: Text("Sign-up", style: TextStyle(color: Colors.black),)),
                            ),
                          ),
                        ),
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
