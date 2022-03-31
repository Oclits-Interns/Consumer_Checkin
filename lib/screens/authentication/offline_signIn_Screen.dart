import 'package:consumer_checkin/constant/colors_constant.dart';
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
  String _userName = "";
  int signInUser = 0;
  bool _showPassword = true;
  Icon showPasswordIcon = const Icon(Icons.visibility_rounded);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMaroon,
        // title: const Text("Login",
        //   style: TextStyle(
        //       color: Colors.black
        //   ),),
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

                              // First we check whether DB exists or not, if it doesn't the method below creates it
                              await DBProvider.db.validateDBExistsWithoutInternet();
                              // Then we check whether table SignInUser exists, if it doesn't we create it first
                              await DBProvider.db.createTableAtLogin();
                              // If Database is found, we look for the user with the provided credentials in the SignInUser table,
                              signInUser = await DBProvider.db.validateWithoutInternet(_email, _password);
                              // The above method will return 1 if user is found, and 0 or garbage value if not found
                              if(signInUser == 1){

                                /*If the user types in valid credentials and their email and otp
                                * are also verified, then we create a table SignedInUser to keep track
                                * of the user that is signed in if it doesn't exist already */
                                await DBProvider.db.createSignedInUserTable();
                                /*We clear out the previous contents of the table because only
                                one user is signedIn at a time*/
                                await DBProvider.db.deleteSignedInUser();
                                /*Finally we insert the current signed in user in the table*/
                                await DBProvider.db.insertSignedInUser(_userName, _email, _password);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
                              }
                              else if(signInUser > 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Multiple records found, please wait"),
                                      duration: Duration(milliseconds: 3000),
                                    ));
                                DBProvider.db.deleteUserCredentials();
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("You have either entered invalid credentials,"
                                          " or your email or OTP are not verified yet"),
                                      duration: Duration(milliseconds: 3000),
                                    ));
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: kMaroon
                              ),
                              child: const Center(child: Text("Sign-in", style: TextStyle(color: Colors.white),)),
                            ),
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