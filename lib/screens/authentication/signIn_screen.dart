import 'package:consumer_checkin/constant/colors_constant.dart';
import 'package:consumer_checkin/services/auth.dart';
import 'package:consumer_checkin/widgets/logo.dart';
import 'package:flutter/material.dart';

String error = "";

class SignIn extends StatefulWidget {
  final void Function() toggleView;
  const SignIn({required this.toggleView, Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String _email = "ali.naqvi@gmail.com";
  String _password = "123456";
  bool _showPassword = true;
  Icon showPasswordIcon = const Icon(Icons.visibility_rounded);


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
                              hintText: "Enter your Email",
                              prefixIcon: const Icon(Icons.email_outlined)
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
                          obscureText: _showPassword,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: "Enter your Password",
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                      if(_showPassword) {
                                        showPasswordIcon = const Icon(Icons.visibility_rounded);
                                      } else{
                                        showPasswordIcon = const Icon(Icons.visibility_off_rounded);
                                      }
                                    });
                                  },
                                  child: showPasswordIcon)
                          ),
                          onChanged: (val) => setState(() {_password = val;}),
                          validator: (val) => val!.length< 6 ? 'Password must be 6 characters or more' : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: GestureDetector(
                            onTap: () async {
                              if(_formKey.currentState!.validate()) {
                                error = await _auth.signInWithEmailAndPassword(_email, _password);
                                switch(error) {
                                  case "You have entered an invalid email":
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                                  break;
                                  case "You don't have an account yet, sign-up first":
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                                    break;
                                  case "You have entered incorrect password":
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                                    break;
                                  default: print(error);
                                    break;
                                }
                              }
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: kMaroon
                              ),
                              child: const Center(child: const Text("Login", style: TextStyle(color: Colors.black),)),
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
                              child: const Center(child: Text("Sign-up", style: TextStyle(color: Colors.black),)),
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
