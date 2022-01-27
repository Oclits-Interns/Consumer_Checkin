import 'package:consumer_checkin/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double latitud = position.latitude;
      double longitud = position.longitude;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MapApp(lan: longitud, lat: latitud);
      }));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 60,
          height: 50,
          child: LoadingIndicator(
              indicatorType: Indicator.lineScalePulseOutRapid,
              colors: const [Colors.red],
              strokeWidth: 1,
              pathBackgroundColor: Colors.black),
        ),
      ),
    );
  }
}
