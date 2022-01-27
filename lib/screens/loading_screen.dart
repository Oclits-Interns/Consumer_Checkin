import 'package:consumer_checkin/services/map.dart';
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
      print(latitud);
      print(longitud);
      print("on");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MapApp(lan: longitud, lat: latitud);
      }));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // getfuture();4
    getCurrentLocation();
    // print(latitud);
    // print(longitud);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 60,
          height: 50,
          child: LoadingIndicator(
              indicatorType: Indicator.lineScalePulseOutRapid,

              /// Required, The loading type of the widget
              colors: const [Colors.red],

              /// Optional, The color collections
              strokeWidth: 1,

              /// Optional, The stroke of the line, only applicable to widget which contains line

              /// Optional, Background of the widget
              pathBackgroundColor: Colors.black

              /// Optional, the stroke backgroundColor
              ),
        ),
      ),
    );
  }
}
