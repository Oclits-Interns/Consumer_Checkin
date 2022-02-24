import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:consumer_checkin/local_DB/local_db.dart';
import 'package:consumer_checkin/models/consumer.dart';
import 'package:consumer_checkin/screens/retrieve_single_location.dart';
import 'package:consumer_checkin/screens/retrieve_locations.dart';
import 'package:consumer_checkin/services/auth.dart';
import 'package:consumer_checkin/services/google_sheets.dart';
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
      drawer: Drawer(
        child: ListView(
          shrinkWrap: true,
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xffb11118),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/logo.png"),
                                fit: BoxFit.scaleDown
                            )
                        ),
                        height: MediaQuery.of(context).size.height * 0.15, width: MediaQuery.of(context).size.width * 0.20,)),
                  // const SizedBox(width: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                          "CONSUMER",
                          style: TextStyle(
                              letterSpacing: 3,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: "Montserrat"
                          )),
                      Text(
                          "CHECKIN",
                          style: TextStyle(
                              letterSpacing: 8,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: "Montserrat"
                          )),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Load Data'),
              leading: const Icon(Icons.download),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => retriveMarkers()));
              },
            ),
            ListTile(
              enabled: isConnected ? true : false,
              title: const Text('Sync Data'),
              leading: const Icon(Icons.sync),
              onTap: () async {
                Map<String, dynamic> consumer;
                try{
                  List<Map<String, dynamic>> consumerEntries = await DBProvider.db.queryAllRows();
                  if(consumerEntries.isEmpty) {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          Future.delayed(const Duration(milliseconds: 1500), () {
                            Navigator.of(context).pop(true);
                          });
                          return const AlertDialog(
                            title: Text("There is no data to sync"),
                          );
                        });
                  }
                  else {
                    for (var element in consumerEntries) {
                      consumer = {
                        ConsumerFields.id : element["Consumer_Id"],
                        ConsumerFields.plotType : element["Plot_Type"],
                        ConsumerFields.name : element["Consumer_Name"],
                        ConsumerFields.number : element["Number"],
                        ConsumerFields.cnicNum : element["CNIC"],
                        ConsumerFields.email : element["Email"],
                        ConsumerFields.taluka : element["Taluka"],
                        ConsumerFields.ucNum : element["UC_Num"],
                        ConsumerFields.zoneNum : element["Zone_Num"],
                        ConsumerFields.wardNum : element["Ward_Num"],
                        ConsumerFields.area : element["Area"],
                        ConsumerFields.unitNum : element["Unit_Num"],
                        ConsumerFields.block : element["Block"],
                        ConsumerFields.houseNum : element["House_Number"],
                        ConsumerFields.address : element["Address"],
                        ConsumerFields.newAddress : element["New_Address"],
                        ConsumerFields.gasCompanyId : element["Gas_Company_Id"],
                        ConsumerFields.electricCompanyId : element["Electricity_Company_Id"],
                        ConsumerFields.landlineCompanyId : element["Landline_Company_Id"],
                      };
                      await ConsumerSheetsAPI.insert([consumer]);
                    }
                  }
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          Navigator.of(context).pop(true);
                        });
                        return const AlertDialog(
                          title: Text('Data uploaded to Google Sheets'),
                        );
                      });
                  DBProvider.db.deleteFromConsumersTable();
                }
                catch(e) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("Something went wrong... " + e.toString()),
                          actions: [
                            GestureDetector(
                              child: const Text("Okay"),
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                            )
                          ],
                        );
                      });
                }
              },
            ),
            ListTile(
              title: const Text('Sign out'),
              leading: const Icon(Icons.power_settings_new_sharp),
              onTap: () {
                _auth.signOut();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: kMaroon,
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
                                      return retriveSingleMarker(
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