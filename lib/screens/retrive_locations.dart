import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class retriveMarkers extends StatefulWidget {
  @override
  _retriveMarkersState createState() => _retriveMarkersState();
}

class _retriveMarkersState extends State<retriveMarkers> {
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
                child: Container(
                  child: Column(),
                )),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {},
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
        });
  }

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
                // backgroundColor: Colors.red,
                scrollable: true,
                title: Text('Consumer Check-In'),
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
                          SizedBox(height: 5),
                          Text("Email : " + specify["Email"]),
                          SizedBox(height: 5),
                          Text("Number : " + specify["Number"].toString()),
                          SizedBox(height: 5),
                          Text("Electric_Company : " +
                              specify["ElectricCompany"]),
                          SizedBox(height: 5),
                          Text("Gas_Company : " + specify["GasCompany"]),
                          SizedBox(height: 5),
                          Text("Landline_Company : " +
                              specify["ElectricCompany"]),
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
                          onTap: () {},
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

  getmarkerdata() async {
    FirebaseFirestore.instance.collection('Consumers').get().then((myMocDoc) {
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
              target: LatLng(21.1458, 79.2882),
              zoom: 15.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              controller = controller;
            }));
  }
}
