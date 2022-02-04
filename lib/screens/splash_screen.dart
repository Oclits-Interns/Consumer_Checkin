import 'package:consumer_checkin/local_DB/local_db.dart';
import 'package:consumer_checkin/screens/authentication/offline_signIn_Screen.dart';
import 'package:consumer_checkin/widgets/logo.dart';
import 'package:consumer_checkin/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    CheckConnection();
  }

  CheckConnection() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      showDialog(
          context: context, builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Connected to mobile data"),
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text("OK")
            )
          ],
        );
      }
      );
    } else if (connectivityResult == ConnectivityResult.wifi) {
      navigateToOnlineAuth();
    }
    else {
      DBProvider.db.initDB();
      navigateToOfflineAuth();
    }
  }

  navigateToOfflineAuth() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OfflineSignIn()));
  }

  navigateToOnlineAuth() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Wrapper()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.yellow.withOpacity(0.5),
              Colors.amber.withOpacity(0.5),
              Colors.amberAccent.withOpacity(0.4),
            ],
            begin: Alignment.topLeft, end: Alignment.bottomRight
          )
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children : [
              Positioned(
                top: 0,
                child: Text("Go offline",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),),
              ),
              Positioned(
                top: 18.0,
                child: Container(
                  height: 50,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.red[900],
                  ),
                  child: Center(
                    child: Text("OFFLINE",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black
                    ),),
                  ),
                ),
              ),
              Logo(),
            ]
          ),
        ),
      )
    );
  }
}
