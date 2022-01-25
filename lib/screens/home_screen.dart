import 'package:consumer_checkin/screens/map_screen.dart';
import 'package:flutter/material.dart';

class ListViewBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Consumer In"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: Icon(Icons.location_on),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_outlined),
                  tooltip: 'Open Map',
                  onPressed: () {
                    if (index == 0) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MapApp()));
                    }
                  },
                ),
                title: Text("User $index"));
          }),
    );
  }
}
