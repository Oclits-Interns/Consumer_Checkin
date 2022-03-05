import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumer_checkin/constant/colors_constant.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RetrieveSingleMarker extends StatefulWidget {
  const RetrieveSingleMarker([this.id, this.lat, this.lon]);

  final id;
  final lat;
  final lon;
  @override
  _RetrieveSingleMarkerState createState() => _RetrieveSingleMarkerState();
}

class _RetrieveSingleMarkerState extends State<RetrieveSingleMarker> {
  int consumerID = 0;
  String name = "";
  String number = "";
  String email = "";
  String address = "";
  String newAddress = "";
  String gasCompany = "";
  String electricCompany = "";
  String landlineCompany = "";
  String nicNumber = "";

  var numberFormatter = MaskTextInputFormatter(
      mask: '####-#######', filter: {"#": RegExp(r'[0-9]')});

  var nicNumberFormatter = MaskTextInputFormatter(
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
                title: const Text('Consumer Details'),
                content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Consumer_ID : " +
                            specify["ConsumerID"].toString()),
                        const SizedBox(height: 5),
                        Text("Name : " + specify["Name"]),
                        const SizedBox(height: 5),
                        Text("Id : " + specifyId),
                        const SizedBox(height: 5),
                        Text("Email : " + specify["Email"]),
                        const SizedBox(height: 5),
                        Text("Number : " + specify["Number"].toString()),
                        const SizedBox(height: 5),
                        Text("Nic Number : " +
                            specify["NicNumber"].toString()),
                        const SizedBox(height: 5),
                        Text("Plot Type : " + specify["Plot_type"].toString()),
                        const SizedBox(height: 5),
                        Text("Taluka : " + specify["Taluka"].toString()),
                        const SizedBox(height: 5),
                        Text("Address : " + specify["Address"]),
                        const SizedBox(height: 5),
                        Text("Electric Company : " +
                            specify["ElectricCompany"]),
                        const SizedBox(height: 5),
                        Text("Gas Company : " + specify["GasCompany"]),
                        const SizedBox(height: 5),
                        Text("Landline Company : " +
                            specify["LandlineCompany"]),
                      ],
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
                                    title: const Text('Consumer Check-In'),
                                    content: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Form(
                                        child: Column(
                                          children: <Widget>[
                                            TextFormField(
                                                controller:
                                                TextEditingController(
                                                    text: specify["Name"]),
                                                decoration: const InputDecoration(
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
                                                numberFormatter
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
                                                    val.trim().isEmpty) {
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
                                                nicNumberFormatter
                                              ],
                                              keyboardType:
                                              TextInputType.number,
                                              decoration: const InputDecoration(
                                                labelText: 'NIC Number',
                                              ),
                                              onChanged: (val) => setState(() {
                                                nicNumber = val;
                                              }),
                                              validator: (String? val) {
                                                if (val == null ||
                                                    val.trim().isEmpty) {
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
                                                decoration: const InputDecoration(
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
                                                decoration: const InputDecoration(
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
                                                decoration:
                                                const InputDecoration(
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
                                                decoration:
                                                const InputDecoration(
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
                                                decoration:
                                                const InputDecoration(
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
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Close",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: kMaroon),
                                                )),
                                            GestureDetector(
                                              child: Text(
                                                "Save",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kMaroon),
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
                                                                  "Name": name ==
                                                                      ""
                                                                      ? specify[
                                                                  "Name"]
                                                                      : name,
                                                                  "Number": number ==
                                                                      ""
                                                                      ? specify[
                                                                  "Number"]
                                                                      : number,
                                                                  "NicNumber": nicNumber ==
                                                                      ""
                                                                      ? specify[
                                                                  "NicNumber"]
                                                                      : nicNumber,
                                                                  "Email": email ==
                                                                      ""
                                                                      ? specify[
                                                                  "Email"]
                                                                      : email,
                                                                  "Address": address ==
                                                                      ""
                                                                      ? specify[
                                                                  "Address"]
                                                                      : address,
                                                                  "GasCompany": gasCompany ==
                                                                      ""
                                                                      ? specify[
                                                                  "GasCompany"]
                                                                      : gasCompany,
                                                                  "ElectricCompany": electricCompany ==
                                                                      ""
                                                                      ? specify[
                                                                  "ElectricCompany"]
                                                                      : electricCompany,
                                                                  "LandlineCompany": landlineCompany ==
                                                                      ""
                                                                      ? specify[
                                                                  "LandlineCompany"]
                                                                      : landlineCompany
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text(
                                                                  "OK"))
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
                                fontWeight: FontWeight.bold, color: kMaroon),
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            "Show Qr",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: kMaroon)),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // backgroundColor: Colors.red,
                                    scrollable: true,
                                    title: const Text('Consumer Check-In'),
                                    content: QrImage(
                                      data:
                                      "Consumer_ID : ${specify["ConsumerID"].toString()}\n  Name : ${specify["Name"]}\n Email : ${specify["ConsumerID"].toString()}\n  Number : ${specify["Number"]}\n CNIC_Number : ${specify["NicNumber"].toString()}\n  Plot_Type : ${specify["Plot_type"]}\n Address : ${specify["Address"].toString()}\n  Taluka : ${specify["Taluka"]}\n ",
                                      version: QrVersions.auto,
                                      size: 60,
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
                                                "Close",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kMaroon),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: const Text("Are you sure you want to delete this data?"),
                                    actions: [
                                      GestureDetector(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection('Consumers')
                                                .doc(specifyId)
                                                .delete();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RetrieveSingleMarker()));
                                          },
                                          child: const Text("OK"))
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Delete Data",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: kMaroon),
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
                                    title: const Text('Consumer Check-In'),
                                    content: specify["URL"] != "" ? Image.network(specify["URL"]) : const Text("There is no image associated with this consumer"),
                                    //specify["URL"] != null ? Image.network(specify["URL"]) : const Text("There is no image associated with this consumer"),
                                    //specify["Url"] != null ? Image.network(specify["Url"]) : const Text("No image for this consumer"),
                                    //Image.network(specify["Url"] ?? "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/832px-No-Image-Placeholder.svg.png"),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              child: Text(
                                                "Close",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kMaroon),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
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
                            "Show image",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: kMaroon),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }),


        infoWindow: InfoWindow(title: specify["ConsumerID"], snippet: specify["Name"]));
    setState(() {
      markers[markerId] = marker;
    });
  }
  getMarkerData() async {
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
    getMarkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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