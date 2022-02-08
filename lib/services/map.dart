import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:consumer_checkin/local_DB/local_db.dart';
import 'package:consumer_checkin/screens/camera_screen.dart';
import 'package:consumer_checkin/screens/qr_code_screen.dart';
import 'package:consumer_checkin/screens/retrive_locations.dart';
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
  String plotType = "";
  String name = "";
  String number = "";
  String email = "";
  String ucNum = "";
  String wardNum = "";
  String address = "";
  String newAddress = "";
  String gasCompany = "";
  String electricCompany = "";
  String landlineCompany = "";
  bool isConnected = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var plotTypeDropDown = ["Domestic", "Commercial"];
  DatabaseService _db = DatabaseService();
  final _ucNumTextEditingController = TextEditingController();
  final _wardNumTextEditingController = TextEditingController();
  final _Addresstextcontroller = TextEditingController();
  final _Emailtextcontroller = TextEditingController();
  final _Consumer_Idtextcontroller = TextEditingController();
  final _Consumer_Nametextcontroller = TextEditingController();
  final _Mobile_Numbertextcontroller = TextEditingController();
  final _Enter_New_Addresstextcontroller = TextEditingController();
  final _Land_Line_Idtextcontroller = TextEditingController();
  final _Gas_Company_Idtextcontroller = TextEditingController();
  final _Electric_Company_Idtextcontroller = TextEditingController();

  void clearForm() {
    _Consumer_Idtextcontroller.clear();
    _Consumer_Nametextcontroller.clear();
    _Addresstextcontroller.clear();
    _Mobile_Numbertextcontroller.clear();
    _Emailtextcontroller.clear();
    _Enter_New_Addresstextcontroller.clear();
    _Land_Line_Idtextcontroller.clear();
    _Gas_Company_Idtextcontroller.clear();
    _Electric_Company_Idtextcontroller.clear();
    _ucNumTextEditingController.clear();
    _wardNumTextEditingController.clear();
  }

 void checkConn() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() => isConnected = false);
    } else {
      setState(() => isConnected = true);
    }
  }

  @override
  void initState() {
    super.initState();
    checkConn();
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // backgroundColor: Colors.red,
            scrollable: true,
            title: Text('Consumer Check-In'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const BarCodeScanner();
                    }));
                  },
                  child: Text(
                      "Scan QR/Bar code",
                    style: TextStyle(
                      color: Colors.blue[600],
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Plot Type",
                          suffixText: '*',
                          suffixStyle: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                          items: plotTypeDropDown.map((plotType) {
                            return DropdownMenuItem(
                              child: new Text(plotType),
                              value: plotType,
                            );
                          }).toList(),
                          validator: (String? val) {
                            if(val == null || val.trim().isEmpty) {
                              return "Please select a plot type first";
                            }
                            else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() => plotType = val.toString());
                          }),
                      TextFormField(
                        controller: _Consumer_Idtextcontroller,
                        decoration: InputDecoration(
                          labelText: 'Consumer Id',
                          suffixText: '*',
                          suffixStyle: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onChanged: (val) => setState(() {
                          consumerID = int.parse(val);
                        }),
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Consumer ID is mandatory";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                          controller: _Consumer_Nametextcontroller,
                          decoration: InputDecoration(
                            labelText: 'Consumer Name',
                          ),
                          onChanged: (val) => setState(() {
                                name = val;
                              })),
                      TextFormField(
                          controller: _Mobile_Numbertextcontroller,
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                          ),
                          onChanged: (val) => setState(() {
                                number = val;
                              })),
                      TextFormField(
                          controller: _Emailtextcontroller,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          onChanged: (val) => setState(() {
                                email = val;
                              })),
                      TextFormField(
                          controller: _ucNumTextEditingController,
                          decoration: InputDecoration(
                            labelText: 'UC Number',
                          ),
                          onChanged: (val) => setState(() {
                            ucNum = val;
                          })),
                      TextFormField(
                          controller: _wardNumTextEditingController,
                          decoration: InputDecoration(
                            labelText: 'Zone-Ward Number',
                          ),
                          onChanged: (val) => setState(() {
                            wardNum = val;
                          })),
                      TextFormField(
                          controller: _Addresstextcontroller,
                          decoration: InputDecoration(
                            labelText: 'Address',
                          ),
                          onChanged: (val) => setState(() {
                                address = val;
                              })),
                      TextFormField(
                          controller: _Enter_New_Addresstextcontroller,
                          decoration: InputDecoration(
                            labelText: 'Enter New Address',
                          ),
                          onChanged: (val) => setState(() {
                                newAddress = val;
                              })),
                    ],
                  ),
                ),
              ],
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
                          if(isConnected) {
                            _db.addConsumerEntry(
                              plotType: plotType,
                                consumerID: consumerID,
                                name: name,
                                number: number,
                                email: email,
                                ucNum: ucNum,
                                wardNum: wardNum,
                                address: address,
                                newAddress: newAddress,
                                gasCompany: gasCompany,
                                electricCompany: electricCompany,
                                landlineCompany: landlineCompany,
                                location: GeoPoint(widget.lat, widget.lan));
                            clearForm();
                            showDialog(
                              barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  Future.delayed(const Duration(milliseconds: 1500), () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return const AlertDialog(
                                    title: Text('Data Inserted'),
                                  );
                                });
                          }
                          else {
                            // If network detected is found to be false, the the consumer records are stored in SQLite db using the method below
                            DBProvider.db.insertConsumerEntryOffline(consumerID, plotType, name, number, email, ucNum, wardNum, address, newAddress, gasCompany, electricCompany, landlineCompany);
                            clearForm();
                            showDialog(
                              barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  Future.delayed(const Duration(milliseconds: 1500), () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return const AlertDialog(
                                    title: Text('Data Inserted to local database'),
                                  );
                                });
                          }
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
                        controller: _Electric_Company_Idtextcontroller,
                        decoration: InputDecoration(
                          labelText: 'Electric Company Id',
                        ),
                        onChanged: (val) => setState(() {
                              electricCompany = val;
                            })),
                    TextFormField(
                        controller: _Gas_Company_Idtextcontroller,
                        decoration: InputDecoration(
                          labelText: 'Gas Company Id',
                        ),
                        onChanged: (val) => setState(() {
                              gasCompany = val;
                            })),
                    TextFormField(
                        controller: _Land_Line_Idtextcontroller,
                        decoration: InputDecoration(
                          labelText: 'Land Line Id',
                        ),
                        onChanged: (val) => setState(() {
                              landlineCompany = val;
                            })),
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

  final Set<Marker> _markers = {};

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

  void _onCameraMove(CameraPosition position) {}

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xffb11118),
                  ),
                  child: Text('Drawer Header'),
                ),
                ListTile(
                  title: const Text('Load data'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => retriveMarkers()));
                  },
                ),
              ],
            ),
          ),
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
                      SizedBox(height: 16.0),
                      FloatingActionButton(
                        onPressed: _goToTheLake,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Color(0xffb11118),
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