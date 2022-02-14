import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumer_checkin/constant/colors_constant.dart';
import 'package:consumer_checkin/screens/retrive_locations.dart';
import 'package:consumer_checkin/services/db_firestore.dart';
import 'package:consumer_checkin/services/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MapApp extends StatefulWidget {
  const MapApp({
    this.lan,
    this.lat,
  });
  final lan;
  final lat;

  @override
  _MapAppState createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  String consumerID = "";
  int zone = 0;
  int ward = 0;
  String plottype = "";
  String name = "";
  String number = "";
  String email = "";
  String address = "";
  String newAddress = "";
  String gasCompany = "";
  String electricCompany = "";
  String landlineCompany = "";
  String nicnumber = "";
  String street = "";
  String block = "";
  String uc = "";
  String area = "";
  String houseno = "";
  String taluka = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();
  
  
  //final String _scanBarcode = "";

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      int startIndexConsumerId = 0;
      int endIndexConsumerId = 11;

      String resultConsumerId =
          barcodeScanRes.substring(startIndexConsumerId, endIndexConsumerId);

      _Consumer_Idtextcontroller.text = resultConsumerId.toString();
      consumerID = resultConsumerId;

      int startIndexZone = 0;
      int endIndexZone = 2;

      String resultZone =
          barcodeScanRes.substring(startIndexZone, endIndexZone);

      _Zonetextcontroller.text = resultZone;

      int startIndexWard = 2;
      int endIndexWard = 4;

      String resultWard =
          barcodeScanRes.substring(startIndexWard, endIndexWard);

      _Wardtextcontroller.text = resultWard;
    });
  }

  var nummberFormatter = new MaskTextInputFormatter(
      mask: '####-#######', filter: {"#": RegExp(r'[0-9]')});

  var nicmnumberFormatter = new MaskTextInputFormatter(
      mask: '#####-#######-#', filter: {"#": RegExp(r'[0-9]')});

  var _Addresstextcontroller = TextEditingController();
  var _Emailtextcontroller = TextEditingController();
  var _Consumer_Idtextcontroller = TextEditingController();
  var _Consumer_Nametextcontroller = TextEditingController();
  var _Mobile_Numbertextcontroller = TextEditingController();
  var _Enter_New_Addresstextcontroller = TextEditingController();
  var _Land_Line_Idtextcontroller = TextEditingController();
  var _Gas_Company_Idtextcontroller = TextEditingController();
  var _Electric_Company_Idtextcontroller = TextEditingController();
  var _Wardtextcontroller = TextEditingController();
  var _Zonetextcontroller = TextEditingController();
  var _Nic_Mobile_Numbertextcontroller = TextEditingController();
  var _houseno_textcontroller = TextEditingController();
  var _street_textcontroller = TextEditingController();
  var _block_textcontroller = TextEditingController();
  var _area_textcontroller = TextEditingController();
  var _uc_textcontroller = TextEditingController();
  var _taluka_Numbertextcontroller = TextEditingController();

  var plotTypeDropDown = ["Domestic", "Commercial"];
  var talukas = [
    "Hyderabad Taluka",
    "Qasimabad Taluka",
    "Latifabad Taluka",
    "Hyderabad City Taluka"
  ];

  void _showAlertDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              // backgroundColor: Colors.red,
              scrollable: true,

              title: const Text('Consumer Check-In'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  scanBarcodeNormal();
                                });
                              },
                              child: const Text(
                                "Scan QR/Barcode",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffb11118)),
                              )),
                        ],
                      ),
                      TextFormField(
                        controller: _Consumer_Idtextcontroller,
                        decoration: const InputDecoration(
                          labelText: 'Consumer Id',
                          suffixText: '*',
                          suffixStyle: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onChanged: (val) => setState(() {
                          consumerID = val;
                        }),
                        validator: (String? val) {
                          if (val == null || val.trim().length == 0) {
                            return "Consumer ID is mandatory";
                          } else {
                            return null;
                          }
                        },
                      ),
                      DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: "Plot Type",
                          ),
                          items: plotTypeDropDown.map((plotType) {
                            return DropdownMenuItem(
                              child: Text(plotType),
                              value: plotType,
                            );
                          }).toList(),
                          validator: (String? val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Please select a plot type first";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() => plottype = val.toString());
                          }),
                      TextFormField(
                        controller: _Consumer_Nametextcontroller,
                        decoration: const InputDecoration(
                          labelText: 'Consumer Name',
                        ),
                        onChanged: (val) => setState(() {
                          name = val.toString();
                        }),
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Please select a plot type first";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: _Mobile_Numbertextcontroller,
                        inputFormatters: [nummberFormatter],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number',
                          suffixText: '*',
                          suffixStyle: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onChanged: (val) => setState(() {
                          number = val;
                        }),
                        validator: (String? val) {
                          if (val == null || val.trim().length == 0) {
                            return "Consumer Number is mandatory";
                          } else if (val != null && val.length < 12) {
                            return "Consumer Number is Invalid";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: _Nic_Mobile_Numbertextcontroller,
                        inputFormatters: [nicmnumberFormatter],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'NIC Number',
                          suffixText: '*',
                          suffixStyle: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onChanged: (val) => setState(() {
                          nicnumber = val;
                        }),
                        validator: (String? val) {
                          if (val == null || val.trim().length == 0) {
                            return "Consumer Nic_Number is mandatory";
                          } else if (val != null && val.length < 12) {
                            return "Consumer Nic_Number is Invalid";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: _Emailtextcontroller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        onChanged: (val) => setState(() {
                          email = val;
                        }),
                        validator: (val) {
                          // Check if this field is empty
                          if (val == null || val.isEmpty) {
                            return 'This field is required';
                          }

                          // using regular expression
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?)*$")
                              .hasMatch(val)) {
                            return "Please enter a valid email address";
                          }

                          // the email is valid
                          return null;
                        },
                      ),
                      DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: "Taluka",
                          ),
                          items: talukas.map((taluka) {
                            return DropdownMenuItem(
                              child: new Text(taluka),
                              value: taluka,
                            );
                          }).toList(),
                          validator: (String? val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Please select a Taluka";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() => taluka = val.toString());
                          }),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 125,
                            child: TextFormField(
                              controller: _Zonetextcontroller,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Zone',
                                suffixText: '*',
                                suffixStyle: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onChanged: (val) => setState(() {
                                zone = int.parse(val);
                              }),
                              validator: (String? val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Please select a plot type first";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            width: 125,
                            child: TextFormField(
                              controller: _Wardtextcontroller,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Ward',
                                suffixText: '*',
                                suffixStyle: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onChanged: (val) => setState(() {
                                ward = int.parse(val);
                              }),
                              validator: (String? val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Please select a plot type first";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 125,
                            child: TextFormField(
                              controller: _area_textcontroller,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Area',
                                suffixText: '*',
                                suffixStyle: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onChanged: (val) => setState(() {
                                area = val;
                              }),
                              validator: (String? val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Please select a plot type first";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            width: 125,
                            child: TextFormField(
                              controller: _uc_textcontroller,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Uc',
                                suffixText: '*',
                                suffixStyle: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onChanged: (val) => setState(() {
                                uc = val;
                              }),
                              validator: (String? val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Please select a plot type first";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 80,
                            child: TextFormField(
                              controller: _street_textcontroller,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Street',
                                suffixText: '*',
                                suffixStyle: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onChanged: (val) => setState(() {
                                street = val;
                              }),
                              validator: (String? val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Please select a plot type first";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            width: 80,
                            child: TextFormField(
                              controller: _block_textcontroller,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Block',
                                suffixText: '*',
                                suffixStyle: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onChanged: (val) => setState(() {
                                block = val;
                              }),
                              validator: (String? val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Please select a plot type first";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            width: 80,
                            child: TextFormField(
                              controller: _houseno_textcontroller,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'House No',
                                suffixText: '*',
                                suffixStyle: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onChanged: (val) => setState(() {
                                houseno = val;
                              }),
                              validator: (String? val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Please select a plot type first";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                          controller: _Addresstextcontroller,
                          keyboardType: TextInputType.streetAddress,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                          ),
                          onChanged: (val) => setState(() {
                                address = (val +
                                    uc +
                                    block +
                                    taluka +
                                    ward.toString() +
                                    street +
                                    houseno +
                                    zone.toString());
                              })),
                      // TextFormField(
                      //     controller: _Enter_New_Addresstextcontroller,
                      //     decoration: const InputDecoration(
                      //       labelText: 'Enter New Address',
                      //     ),
                      //     onChanged: (val) => setState(() {
                      //           newAddress = val;
                      //         })),
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
                                  builder: (context) => AddImage()));
                        },
                        child: const Text(
                          "TAKE IMAGE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _db.addConsumerEntry(
                              location: GeoPoint(widget.lat, widget.lan),
                              consumerID: consumerID,
                              name: name,
                              number: number,
                              email: email,
                              address: address,
                              newAddress: newAddress,
                              gasCompany: gasCompany,
                              electricCompany: electricCompany,
                              landlineCompany: landlineCompany,
                              zone: zone,
                              ward: ward,
                              plottype: plottype,
                              nicnumber: nicnumber,
                              street: street,
                              block: block,
                              uc: uc,
                              area: area,
                              houseno: houseno,
                              taluka: taluka,
                            );

                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  Future.delayed(
                                      const Duration(milliseconds: 1500), () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return const AlertDialog(
                                    title: Text('Data Inserted'),
                                  );
                                });

                            _formKey.currentState!.reset();

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapApp()));
                          }
                        },
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: kRed),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showAlertMoreDetails();
                        },
                        child: const Text(
                          "MORE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
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
            title: const Text('More Information'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        controller: _Electric_Company_Idtextcontroller,
                        decoration: const InputDecoration(
                          labelText: 'Electric Company Id',
                        ),
                        onChanged: (val) => setState(() {
                              electricCompany = val;
                            })),
                    TextFormField(
                        controller: _Gas_Company_Idtextcontroller,
                        decoration: const InputDecoration(
                          labelText: 'Gas Company Id',
                        ),
                        onChanged: (val) => setState(() {
                              gasCompany = val;
                            })),
                    TextFormField(
                        controller: _Land_Line_Idtextcontroller,
                        decoration: const InputDecoration(
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
                      child: const Text(
                        "BACK",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                    const Text(
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
                        backgroundColor: const Color(0xffb11118),
                        child: const Icon(Icons.map, size: 36.0),
                      ),
                      const SizedBox(height: 16.0),
                      FloatingActionButton(
                        onPressed: _onAddMarkerButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: const Color(0xffb11118),
                        child: const Icon(
                          Icons.add_location,
                          size: 36.0,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      FloatingActionButton(
                        onPressed: _goToTheLake,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: const Color(0xffb11118),
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
