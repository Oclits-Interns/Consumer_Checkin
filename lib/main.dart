import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:consumer_checkin/screens/splash_screen.dart';
import 'package:consumer_checkin/services/google_sheets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consumer_checkin/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none){
    runApp(const MyApp());
  }
  else {
    await ConsumerSheetsAPI.init();
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red
        ),
        home: const Splash(),
      )
    );
  }
}
