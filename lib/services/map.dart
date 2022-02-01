import 'dart:async';
import 'package:consumer_checkin/screens/camera_screen.dart';
import 'package:consumer_checkin/services/db_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapApp extends StatefulWidget {
  const MapApp({this.lan, this.lat});
  final lan;
  final lat;

  @override
  _MapAppState createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {

  int consumerID = 0;
  String name = "";
  String number = "";
  String email = "";
  String address = "";
  String newAddress = "";
  String gasCompany = "";
  String electricCompany = "";
  String landlineCompany = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseService _db = DatabaseService();


  // @override
  // void dispose() {
  //   super.dispose();
  // }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

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
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Consumer Id',
                      ),
                        onChanged: (val) => setState(() {consumerID = int.parse(val);}),
                      validator: (String? val) {
                        if(val == null || val.trim().length == 0) {
                          return "Consumer ID is mandatory";
                        }
                        else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Consumer Name',
                      ),
                        onChanged: (val) => setState(() {name = val;})
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                      ),
                        onChanged: (val) => setState(() {number = val;})
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                        onChanged: (val) => setState(() {email = val;})
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                        onChanged: (val) => setState(() {address = val;})
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter New Address',
                      ),
                        onChanged: (val) => setState(() {newAddress = val;})
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
                    GestureDetector(
                      onTap: () {
                        if(_formKey.currentState!.validate()) {
                          _db.addConsumerEntry(consumerID, name, number, email, address, newAddress, gasCompany, electricCompany, landlineCompany);
                          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                              content: const Text("Data Inserted")));
                        }
                      },
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
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
                      onChanged: (val) => setState(() {electricCompany = val;})
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Gas Company Id',
                      ),
                        onChanged: (val) => setState(() {gasCompany = val;})
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Land Line Id',
                      ),
                        onChanged: (val) => setState(() {landlineCompany = val;})
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
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        "BACK",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                    Text(
                      "SAVE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
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
      home: SafeArea(
        child: Scaffold(
          key: _scaffoldkey,
          body: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
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
                      FloatingActionButton(
                        onPressed: _goToTheLake,
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
      ),
    );
  }
}