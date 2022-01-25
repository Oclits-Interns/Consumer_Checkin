<<<<<<< HEAD
import 'package:consumer_checkin/screens/map_screen.dart';
=======
import 'package:consumer_checkin/app_theme.dart';
>>>>>>> e324094ec5c61e067f96067be54cadb42c70eb30
import 'package:flutter/material.dart';

class ListViewBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
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
=======
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
>>>>>>> e324094ec5c61e067f96067be54cadb42c70eb30
    );
  }
}
