import 'dart:async';

import 'package:consumer_checkin/main.dart';
import 'package:consumer_checkin/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapApp extends StatefulWidget {
  const MapApp({Key? key}) : super(key: key);

  @override
  _MapAppState createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // backgroundColor: Colors.red,
            scrollable: true,
            title: Text('Consumer Check-In'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Consumer Id',
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Consumer Name',
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter New Address',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraApp()));
                      },
                      child: Text(
                        "TAKE IMAGE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                    Text(
                      "SAVE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showAlertMoreDetails();
                      },
                      child: Text(
                        "MORE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    )
                  ],
                ),
              )
              // RaisedButton(
              //     child: Text("Submit"),
              //     onPressed: () {
              //       // your code
              //     })
            ],
          );
        });
  }

  void _showAlertMoreDetails() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // backgroundColor: Colors.red,
            scrollable: true,
            title: Text('More Information'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Electric Company Id',
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Gas Company Id',
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Land Line Id',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "BACK",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    Text(
                      "SAVE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
              )
              // RaisedButton(
              //     child: Text("Submit"),
              //     onPressed: () {
              //       // your code
              //     })
            ],
          );
        });
  }

  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(25.3960, 68.3578);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        onTap: () {
          _showAlertDialog();
        },

        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
          centerTitle: true,
          title: Text('Consumer Check-In'),
          backgroundColor: Color(0xffb11118),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: _onMapTypeButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Color(0xffb11118),
                      child: const Icon(Icons.map, size: 36.0),
                    ),
                    SizedBox(height: 16.0),
                    FloatingActionButton(
                      onPressed: _onAddMarkerButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Color(0xffb11118),
                      child: const Icon(
                        Icons.add_location,
                        size: 36.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
