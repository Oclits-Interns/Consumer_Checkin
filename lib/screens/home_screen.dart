import 'package:consumer_checkin/app_theme.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMaroon,
        leading: Icon(Icons.search, color: Colors.black,),
      ),
      body: ListView.builder(
                itemCount: 15,
                  itemBuilder: (context, index) {
                    return index == 0 ? const ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      title: Text("Open Map"),
                      leading: Icon(Icons.location_on, color: Colors.red, size: 48),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 28),
                    ) : const ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      title: Text("Consumer Id"),
                      leading: Icon(Icons.location_on, color: Colors.red, size: 48,),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 28),
                    );
                  }),
    );
  }
}
