import 'package:consumer_checkin/app_theme.dart';
import 'package:consumer_checkin/local_DB/local_db.dart';
import 'package:consumer_checkin/screens/home_screen.dart';
import 'package:consumer_checkin/widgets/logo.dart';
import 'package:flutter/material.dart';

class OfflineSignIn extends StatefulWidget {
  const OfflineSignIn({Key? key}) : super(key: key);

  @override
  _OfflineSignInState createState() => _OfflineSignInState();
}

class _OfflineSignInState extends State<OfflineSignIn> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  int SignInUser = 0;
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

                              // First we check whether DB exists or not, if it doesn't the method below creates it
                              await DBProvider.db.ValidateDBExistsWithoutInternet();
                              // Then we check whether table SignInUser exists, if it doesn't we create it first
                              await DBProvider.db.CreateTableAtLogin();
                              // If Database is found, we look for the user with the provided credentials in the SignInUser table,
                                SignInUser = await DBProvider.db.ValidateWithoutInternet(_email, _password);
                              // The above method will return 1 if user is found, and 0 or garbage value if not found
                              if(SignInUser == 1){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
                              }
                              else if(SignInUser > 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    new SnackBar(
                                      content: const Text("Multiple records found, please wait"),
                                      duration: new Duration(milliseconds: 3000),
                                    ));
                                DBProvider.db.DeleteSigninUser();
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    new SnackBar(
                                  content: const Text("Credentials don't match, please try again"),
                                      duration: new Duration(milliseconds: 3000),
                                ));
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
                            child: Center(child: Text("Login", style: TextStyle(color: Colors.black),)),
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
