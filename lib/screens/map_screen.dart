import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumer_checkin/main.dart';
import 'package:consumer_checkin/screens/qr_code_screen.dart';
import 'package:consumer_checkin/services/firebase_services.dart';
import 'package:consumer_checkin/services/image_upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class MapApp extends StatefulWidget {
  MapApp({this.lan, this.lat});
  final lan;
  final lat;

  @override
  _MapAppState createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  ImagePicker imagePicker = ImagePicker();
  late File file;
  late String imageUrl;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController userId = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController userEmail = TextEditingController();
  final TextEditingController userAdress = TextEditingController();
  final TextEditingController userNewAdress = TextEditingController();
  final TextEditingController userMobile = TextEditingController();
  final TextEditingController gasCompanyId = TextEditingController();
  final TextEditingController electicCompanyId = TextEditingController();
  final TextEditingController landLineId = TextEditingController();
  DatabaseService _db = DatabaseService();

  PickedFile? imageFile = null;

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = pickedFile!;
    });
    Navigator.pop(context);
  }

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => QRViewExample()));
                            },
                            child: Text(
                              "Scan QR/Barcode",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffb11118)),
                            )),
                      ],
                    ),
                    TextFormField(
                      controller: userId,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Conusmer Id';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Consumer Id',
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Conusmer Name';
                        }
                        return null;
                      },
                      controller: userName,
                      decoration: InputDecoration(
                        labelText: 'Consumer Name',
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.trim().length != 11) {
                          return 'Enter Mobile Number';
                        }
                        return null;
                      },
                      controller: userMobile,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (!value!.contains("@")) {
                          return 'Enter Valid Email';
                        }
                        return null;
                      },
                      controller: userEmail,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Address';
                        }
                        return null;
                      },
                      controller: userAdress,
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter New Address';
                        }
                        return null;
                      },
                      controller: userNewAdress,
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
                        _openCamera(context);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => CameraApp())
                        //         );
                      },
                      child: Text(
                        "TAKE IMAGE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffb11118)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _db.addConsumerData(
                            userId.text,
                            userName.text,
                            userEmail.text,
                            userMobile.text,
                            userAdress.text,
                            userNewAdress.text,
                            imageFile.toString());

                        userId.clear();
                        userName.clear();
                        userEmail.clear();
                        userMobile.clear();
                        userAdress.clear();
                        userNewAdress.clear();
                      },
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffb11118)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showAlertMoreDetails();
                      },
                      child: Text(
                        "MORE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffb11118)),
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
                      controller: electicCompanyId,
                      decoration: InputDecoration(
                        labelText: 'Electric Company Id',
                      ),
                    ),
                    TextFormField(
                      controller: gasCompanyId,
                      decoration: InputDecoration(
                        labelText: 'Gas Company Id',
                      ),
                    ),
                    TextFormField(
                      controller: landLineId,
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        "BACK",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _db.consumerMoreDetails(electicCompanyId.text,
                            gasCompanyId.text, landLineId.text);
                        electicCompanyId.clear();
                        gasCompanyId.clear();
                        landLineId.clear();
                      },
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
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
      zoom: 21.0,
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
          body: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.lat, widget.lan),
                  zoom: 10.0,
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
                      SizedBox(height: 400),
                      FloatingActionButton(
                        onPressed: _goToTheLake,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Color(0xffb11118),
                        child: const Icon(
                          Icons.my_location_outlined,
                          size: 30.0,
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
