import 'package:camera/camera.dart';
import 'package:consumer_checkin/screens/camera_screen.dart';
import 'package:consumer_checkin/screens/capture_image.dart';
import 'package:consumer_checkin/screens/home_screen.dart';
import 'package:consumer_checkin/screens/map_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final firstCamera = cameras.first;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.red),
        home: ListViewBuilder());
  }
}
