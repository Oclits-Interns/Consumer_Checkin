import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class retriveSingleMarker extends StatefulWidget {
  const retriveSingleMarker([this.id, this.lat, this.lon]);

  final id;
  final lat;
  final lon;
  @override
  _retriveSingleMarkerState createState() => _retriveSingleMarkerState();
}

class _retriveSingleMarkerState extends State<retriveSingleMarker> {
  int consumerID = 0;
  String name = "";
  String number = "";
  String email = "";
  String address = "";
  String newAddress = "";
  String gasCompany = "";
  String electricCompany = "";
  String landlineCompany = "";
  String nicnumber = "";

  var nummberFormatter = new MaskTextInputFormatter(
      mask: '####-#######', filter: {"#": RegExp(r'[0-9]')});

  var nicmnumberFormatter = new MaskTextInputFormatter(
      mask: '#####-#######-#', filter: {"#": RegExp(r'[0-9]')});

  late GoogleMapController controller;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(specify["location"].latitude, specify["location"].longitude),
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,
                title: Text('Consumer Details'),
                content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Consumer_ID : " +
                              specify["ConsumerID"].toString()),
                          SizedBox(height: 5),
                          Text("Name : " + specify["Name"]),
                          // SizedBox(height: 5),
                          // Text("Id : " + specifyId),
                          SizedBox(height: 5),
                          Text("Email : " + specify["Email"]),
                          SizedBox(height: 5),
                          Text("Number : " + specify["Number"].toString()),
                          SizedBox(height: 5),
                          Text("Nic Number : " +
                              specify["NicNumber"].toString()),
                          SizedBox(height: 5),
                          Text("Plot Type : " + specify["Plottype"].toString()),
                          SizedBox(height: 5),
                          Text("Taluka : " + specify["Taluka"].toString()),
                          SizedBox(height: 5),
                          Text("UC : " + specify["UC"].toString()),
                          SizedBox(height: 5),
                          Text("Zone : " + specify["Zone"].toString()),
                          SizedBox(height: 5),
                          Text("Ward : " + specify["Ward"].toString()),
                          SizedBox(height: 5),
                          Text("Address : " + specify["Address"]),
                          SizedBox(height: 5),
                          Text("Electric Company : " +
                              specify["ElectricCompany"]),
                          SizedBox(height: 5),
                          Text("Gas Company : " + specify["GasCompany"]),
                          SizedBox(height: 5),
                          Text("Landline Company : " +
                              specify["LandlineCompany"]),
                        ],
                      ),
                    )),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
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
                                              controller: TextEditingController(
                                                  text: specify["ConsumerID"]
                                                      .toString()),
                                              onChanged: (val) => setState(() {
                                                consumerID = int.parse(val);
                                              }),
                                              decoration: InputDecoration(
                                                labelText: 'EnterConsumerID',
                                              ),
                                            ),
                                            TextFormField(
                                                controller:
                                                    TextEditingController(
                                                        text: specify["Name"]),
                                                decoration: InputDecoration(
                                                  labelText: 'Enter Name',
                                                ),
                                                onChanged: (val) =>
                                                    setState(() {
                                                      name = val;
                                                    })),
                                            TextFormField(
                                              controller: TextEditingController(
                                                  text: specify["Number"]),
                                              inputFormatters: [
                                                nummberFormatter
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                labelText: 'Mobile Number',
                                              ),
                                              onChanged: (val) => setState(() {
                                                number = val;
                                              }),
                                              validator: (String? val) {
                                                if (val == null ||
                                                    val.trim().length == 0) {
                                                  return "Consumer Number is mandatory";
                                                } else if (val.length < 12) {
                                                  return "Consumer Number is Invalid";
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TextFormField(
                                              controller: TextEditingController(
                                                  text: specify["NicNumber"]),
                                              inputFormatters: [
                                                nicmnumberFormatter
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                labelText: 'NIC Number',
                                              ),
                                              onChanged: (val) => setState(() {
                                                nicnumber = val;
                                              }),
                                              validator: (String? val) {
                                                if (val == null ||
                                                    val.trim().length == 0) {
                                                  return "Consumer Nic_Number is mandatory";
                                                } else if (val.length < 12) {
                                                  return "Consumer Nic_Number is Invalid";
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TextFormField(
                                                controller:
                                                    TextEditingController(
                                                        text: specify["Email"]),
                                                decoration: InputDecoration(
                                                  labelText: 'Enter Email',
                                                ),
                                                onChanged: (val) =>
                                                    setState(() {
                                                      email = val;
                                                    })),
                                            TextFormField(
                                                controller:
                                                    TextEditingController(
                                                        text:
                                                            specify["Address"]),
                                                decoration: InputDecoration(
                                                  labelText: 'Enter Address',
                                                ),
                                                onChanged: (val) =>
                                                    setState(() {
                                                      address = val;
                                                    })),
                                            TextFormField(
                                                controller:
                                                    TextEditingController(
                                                        text: specify[
                                                            "ElectricCompany"]),
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Enter Electric Company',
                                                ),
                                                onChanged: (val) =>
                                                    setState(() {
                                                      electricCompany = val;
                                                    })),
                                            TextFormField(
                                                controller:
                                                    TextEditingController(
                                                        text: specify[
                                                            "GasCompany"]),
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Enter Gas Company',
                                                ),
                                                onChanged: (val) =>
                                                    setState(() {
                                                      gasCompany = val;
                                                    })),
                                            TextFormField(
                                                controller:
                                                    TextEditingController(
                                                        text: specify[
                                                            "LandlineCompany"]),
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Enter Landline Company',
                                                ),
                                                onChanged: (val) =>
                                                    setState(() {
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              child: Text(
                                                "SAVE",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: const Text(
                                                            "Data Updated"),
                                                        actions: [
                                                          GestureDetector(
                                                              onTap: () {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Consumers')
                                                                    .doc(
                                                                        specifyId)
                                                                    .update({
                                                                  "ConsumerID":
                                                                      consumerID,
                                                                  "Name": name,
                                                                  "Number":
                                                                      number,
                                                                  "NicNumber":
                                                                      nicnumber,
                                                                  "Email":
                                                                      email,
                                                                  "Address":
                                                                      address,
                                                                  "GasCompany":
                                                                      gasCompany,
                                                                  "ElectricCompany":
                                                                      electricCompany,
                                                                  "LandlineCompany":
                                                                      landlineCompany,
                                                                });
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                retriveSingleMarker()));
                                                              },
                                                              child: Text("OK"))
                                                        ],
                                                      );
                                                    });
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Edit Data",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection('Consumers')
                                .doc(specifyId)
                                .delete();

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: const Text("Data Deleted!"),
                                    actions: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        retriveSingleMarker()));
                                          },
                                          child: Text("OK"))
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Delet Data",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // backgroundColor: Colors.red,
                                    scrollable: true,
                                    title: Text('Consumer Check-In'),
                                    content: Image.network(specify["Url1"]),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              child: Text(
                                                "Image Retrived",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              onTap: () {},
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Show IMAGE",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }),
        infoWindow: InfoWindow(title: "oks", snippet: specify["Name"]));
    setState(() {
      markers[markerId] = marker;
    });
  }

  // getmarkerdata() async {
  //   FirebaseFirestore.instance
  //       .collection('Consumers')
  //       .doc(widget.id)
  //       .get()
  //       .then((myMocDoc) {
  //     if (myMocDoc.data()!.isNotEmpty) {
  //       initMarker(myMocDoc.data(), widget.id);
  //     }
  //   });
  // }

  getmarkerdata() async {
    FirebaseFirestore.instance
        .collection('Consumers')
        .doc(widget.id)
        .get()
        .then((myMocDoc) {
      if (myMocDoc.data()!.isNotEmpty) {
        initMarker(myMocDoc.data(), widget.id);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getmarkerdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> getMarkers() {
      return <Marker>[
        Marker(
          markerId: MarkerId("Shop"),
          position: LatLng(21.1458, 97.2882),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "home"),
        )
      ].toSet();
    }

    return Scaffold(
        body: GoogleMap(
            mapType: MapType.normal,
            markers: Set<Marker>.of(markers.values),
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.lat, widget.lon),
              zoom: 15.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              controller = controller;
            }));
  }
}
