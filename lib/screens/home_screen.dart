import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumer_checkin/screens/authentication/retrive_single_location.dart';
import 'package:consumer_checkin/screens/retrive_locations.dart';
import 'package:consumer_checkin/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:consumer_checkin/constant/colors_constant.dart';
import 'package:consumer_checkin/services/loading_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart' as Location;
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMaroon,
        leading: const Icon(
          Icons.search,
          color: Colors.black,
        ),
        actions: [
          GestureDetector(
              onTap: _auth.signOut,
              child: const Icon(Icons.logout, color: Colors.black))
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final status = await Permission.locationWhenInUse.request();
                if (status == PermissionStatus.granted) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoadingScreen()));
                } else if (status == PermissionStatus.denied) {
                  CupertinoAlertDialog(
                    title: const Text('Camera Permission'),
                    content: const Text(
                        'This app needs GPS access to track location'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: const Text('Deny'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      CupertinoDialogAction(
                        child: const Text('Settings'),
                        onPressed: () => openAppSettings(),
                      ),
                    ],
                  );
                } else if (status == PermissionStatus.permanentlyDenied) {
                  await openAppSettings();
                }
              },
              child: const ListTile(
                contentPadding: EdgeInsets.all(8.0),
                title: Text("Open Map"),
                leading: Icon(Icons.location_on, color: Colors.red, size: 48),
                trailing: Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.black, size: 28),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Consumers")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const ListTile(
                      title: Text("There seems to be no data yet"),
                    );
                  } else {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot _items = snapshot.data!.docs[index];
                          return GestureDetector(
                            onTap: () {
                              print(
                                  "........................................????????????" +
                                      _items.id);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return retriveSingleMarker(
                                    _items.id,
                                    _items["location"].latitude,
                                    _items["location"].longitude);
                              }));
                            },
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
                              title: Text(_items["ConsumerID"].toString()),
                              leading: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 48,
                              ),
                              trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.black,
                                  size: 28),
                            ),
                          );
                        });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
