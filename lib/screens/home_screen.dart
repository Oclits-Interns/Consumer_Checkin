import 'package:consumer_checkin/screens/loading_screen.dart';
import 'package:consumer_checkin/screens/map_screen.dart';
import 'package:flutter/material.dart';

class ListViewBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        backgroundColor: Color(0xffb11118),
        title: Text("Consumer Check-In"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) {
            return index == 0
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoadingScreen()));
                    },
                    child: const ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      title: Text("Open Map"),
                      leading: Icon(Icons.location_on,
                          size: 35, color: Color(0xffb11118)),
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.black, size: 25),
                    ),
                  )
                : ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text("Consumer No $index"),
                    leading: Icon(
                      Icons.location_on,
                      size: 35,
                      color: Color(0xffb11118),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black, size: 25),
                  );
          }),
    );
  }
}
