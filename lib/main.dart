import 'package:camera/camera.dart';
import 'package:consumer_checkin/screens/camera_screen.dart';
import 'package:consumer_checkin/screens/home_screen.dart';
import 'package:consumer_checkin/screens/map_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      home: ListViewBuilder(),
    );
  }
}
