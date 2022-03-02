import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:consumer_checkin/screens/retrieve_single_location.dart';
import 'package:consumer_checkin/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:consumer_checkin/constant/colors_constant.dart';
import 'package:consumer_checkin/services/loading_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isConnected = false;
  final AuthService _auth = AuthService();
  String? key;
  final TextEditingController _searchTextController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMaroon,
        actions: [
          GestureDetector(child: const Icon(Icons.logout),
          onTap: () {
              _auth.signOut();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchTextController,
                onChanged: (val) {
                  setState(() => key = val.toUpperCase());
                },
                decoration: InputDecoration(
                  hintText: "Search Consumer ID..",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          _searchTextController.clear();
                          setState(() => key = "");
                        },
                        child: const Icon(Icons.clear)),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    )
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final status =
                await Permission.locationWhenInUse.request();
                if (status == PermissionStatus.granted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoadingScreen()));
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
                leading:
                Icon(Icons.location_on, color: Colors.red, size: 48),
                trailing: Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.black, size: 28),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: (key != null)
                    ? FirebaseFirestore.instance
                    .collection('Consumers')
                    .where(
                    'ConsumerID',
                    isGreaterThanOrEqualTo: key,
                    isLessThan: key! + 'z'
                )
                    .snapshots()
                    : FirebaseFirestore.instance.collection("Consumers").snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.active){
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot _items =
                            snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return RetrieveSingleMarker(
                                          _items.id,
                                          _items["location"].latitude,
                                          _items["location"].longitude);
                                    }));
                              },
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8.0),
                                title: Text(_items["ConsumerID"]),
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

                    } else {
                      return const ListTile(
                        title: Text("There seems to be no data yet"),
                      );
                    }
                  }
                  else {
                    return const CircularProgressIndicator();
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}