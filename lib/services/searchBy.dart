import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumer_checkin/constant/colors_constant.dart';
import 'package:consumer_checkin/screens/retrieve_locations.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class retriveeMarkersBySearch extends StatefulWidget {
  retriveeMarkersBySearch({required this.searchid, required this.name});
  String searchid;
  String name;

  @override
  _retriveeMarkersBySearchState createState() =>
      _retriveeMarkersBySearchState();
}

class _retriveeMarkersBySearchState extends State<retriveeMarkersBySearch> {
  String consumerID = "";
  String name = "";
  String number = "";
  String email = "";
  String address = "";
  String newAddress = "";
  String gasCompany = "";
  String electricCompany = "";
  String landlineCompany = "";

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
                    child: Container(
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
                                    title: const Text('Consumer Check-In'),
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
                                                consumerID = val;
                                              }),
                                              decoration: const InputDecoration(
                                                labelText: 'EnterConsumerID',
                                              ),
                                            ),
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
                                                controller:
                                                TextEditingController(
                                                    text:
                                                    specify["Number"]),
                                                decoration: const InputDecoration(
                                                  labelText: 'Enter Number',
                                                ),
                                                onChanged: (val) =>
                                                    setState(() {
                                                      number = val;
                                                    })),
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
                                                decoration: const InputDecoration(
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
                                                decoration: const InputDecoration(
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
                                                decoration: const InputDecoration(
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
                                              child: const Text(
                                                "SAVE",
                                                style: const TextStyle(
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
                                                            "Edit Deleted!"),
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
                                                                  "Name":
                                                                  name,
                                                                  "Number":
                                                                  number,
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
                                                                            retriveMarkers()));
                                                              },
                                                              child: const Text("OK"))
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
                                                        retriveMarkers()));
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
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              child: const Text(
                                                "Image Retrieved",
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
                            "Show Image",
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

  // getmarkerdata() async {
  //   FirebaseFirestore.instance
  //       .collection('Consumers')
  //       .where("ConsumerID", isEqualTo: widget.searchid)
  //       .snapshots(); {
  //     if (myMocDoc.docs.isNotEmpty) {
  //       for (int a = 0; a < myMocDoc.docs.length; a++) {
  //         initMarker(myMocDoc.docs[a].data(), myMocDoc.docs[a].id);
  //       }
  //     }
  //   });
  //   // var markers = FirebaseFirestore.instance
  //   //     .collection("Consumers")
  //   //     .where("ConsumerID", isEqualTo: widget.searchid)
  //   //     .snapshots();
  //   // print(widget.searchid);
  //   // print(markers);
  // }

  getmarkerdata() async {
    FirebaseFirestore.instance
        .collection('Consumers')
        .where("${widget.name}", isEqualTo: widget.searchid)
        .get()
        .then((myMocDoc) {
      if (myMocDoc.docs.isNotEmpty) {
        for (int a = 0; a < myMocDoc.docs.length; a++) {
          initMarker(myMocDoc.docs[a].data(), myMocDoc.docs[a].id);
        }
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
        const Marker(
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
            initialCameraPosition: const CameraPosition(
              target: const LatLng(25.3960, 68.3578),
              zoom: 15.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              controller = controller;
            }));
  }
}