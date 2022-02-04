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

  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMaroon,
        leading: Icon(
          Icons.search,
          color: Colors.black,
        ),
        actions: [
          GestureDetector(
            onTap: _auth.signOut,
              child: Icon(Icons.logout, color: Colors.black)
          )
        ],
      ),
      body: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) {
            return index == 0
                ? GestureDetector(
                    onTap: () async {
                      final status =
                          await Permission.locationWhenInUse.request();
                      if (status == PermissionStatus.granted) {
                        print('Permission granted');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoadingScreen()));
                      } else if (status == PermissionStatus.denied) {
                        print(
                            'Permission denied. Show a dialog and again ask for the permission');
                        CupertinoAlertDialog(
                          title: Text('Camera Permission'),
                          content: Text(
                              'This app needs GPS access to track location'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text('Deny'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            CupertinoDialogAction(
                              child: Text('Settings'),
                              onPressed: () => openAppSettings(),
                            ),
                          ],
                        );
                      } else if (status == PermissionStatus.permanentlyDenied) {
                        print('Take the user to the settings page.');
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
                  )
                : const ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text("Consumer Id"),
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 48,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black, size: 28),
                  );
          }),
    );
  }
}
