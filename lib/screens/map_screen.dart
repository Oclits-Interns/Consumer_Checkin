import 'dart:async';
import 'package:consumer_checkin/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:consumer_checkin/constant/colors_constant.dart';

class MapApp extends StatefulWidget {
  const MapApp({this.lan, this.lat});
  final lan;
  final lat;

  @override
  _MapAppState createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
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
                        style:
                            TextStyle(fontWeight: FontWeight.bold, color: kRed),
                      ),
                    ),
                    Text(
                      "SAVE",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: kRed),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showAlertMoreDetails();
                      },
                      child: Text(
                        "MORE",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, color: kRed),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: kRed),
                    ),
                    Text(
                      "SAVE",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: kRed),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(25.3960, 68.3578);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  Future<void> _goToTheLake() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(widget.lat, widget.lan),
      zoom: 19.0,
    )));
  }

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
        markerId: MarkerId(LatLng(widget.lat, widget.lan).toString()),
        position: LatLng(widget.lat, widget.lan),

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
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.lat, widget.lan),
                  zoom: 15.0,
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
                        backgroundColor: kMaroon,
                        child: const Icon(Icons.map, size: 36.0),
                      ),
                      SizedBox(height: 16.0),
                      FloatingActionButton(
                        onPressed: _onAddMarkerButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: kMaroon,
                        child: const Icon(
                          Icons.add_location,
                          size: 36.0,
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: _goToTheLake,
                        backgroundColor: kMaroon,
                        child: const Icon(
                          Icons.my_location,
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
      ),
    );
  }
}
