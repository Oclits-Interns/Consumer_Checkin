// import 'dart:io';
// import 'dart:io' as io;
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_core/firebase_core.dart' as firebase_core;
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:path/path.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await firebase_core.Firebase.initializeApp();
//   runApp(MaterialApp(
//     title: 'Firebase Storage Demo',
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//     ),
//     home: UploadingImageToFirebaseStorage(),
//   ));
// }

// final Color green = Colors.brown;
// final Color orange = Colors.brown;

// class UploadingImageToFirebaseStorage extends StatefulWidget {
//   @override
//   _UploadingImageToFirebaseStorageState createState() =>
//       _UploadingImageToFirebaseStorageState();
// }

// class _UploadingImageToFirebaseStorageState extends State {
//   File? _imageFile = null;

//   ///NOTE: Only supported on Android & iOS
//   ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
//   final picker = ImagePicker();

//   Future pickImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.camera);

//     setState(() {
//       _imageFile = File(pickedFile!.path);
//     });
//   }

//   Future uploadImageToFirebase(BuildContext context) async {
//     String fileName = basename(_imageFile!.path);
//     firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
//         .ref()
//         .child('uploads')
//         .child('/$fileName');

//     final metadata = firebase_storage.SettableMetadata(
//         contentType: 'image/jpeg',
//         customMetadata: {'picked-file-path': fileName});
//     firebase_storage.UploadTask uploadTask;
//     //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
//     uploadTask = ref.putFile(io.File(_imageFile!.path), metadata);

//     firebase_storage.UploadTask task = await Future.value(uploadTask);
//     Future.value(uploadTask)
//         .then((value) => {print("Upload file path ${value.ref.fullPath}")})
//         .onError((error, stackTrace) =>
//             {print("Upload file path error ${error.toString()} ")});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: 360,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(250.0),
//                     bottomRight: Radius.circular(10.0)),
//                 gradient: LinearGradient(
//                     colors: [green, orange],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight)),
//           ),
//           Container(
//             margin: const EdgeInsets.only(top: 80),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(
//                     child: Text(
//                       "Uploading Image to Firebase Storage",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 28,
//                           fontStyle: FontStyle.italic),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       Container(
//                         height: double.infinity,
//                         margin: const EdgeInsets.only(
//                             left: 30.0, right: 30.0, top: 10.0),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(30.0),
//                           child: _imageFile != null
//                               ? Image.file(_imageFile!)
//                               : FlatButton(
//                                   child: Icon(
//                                     Icons.add_a_photo,
//                                     color: Colors.blue,
//                                     size: 50,
//                                   ),
//                                   onPressed: pickImage,
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 uploadImageButton(context),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget uploadImageButton(BuildContext context) {
//     return Container(
//       child: Stack(
//         children: [
//           Container(
//             padding:
//                 const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
//             margin: const EdgeInsets.only(
//                 top: 30, left: 20.0, right: 20.0, bottom: 20.0),
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [orange, green],
//                 ),
//                 borderRadius: BorderRadius.circular(30.0)),
//             child: FlatButton(
//               onPressed: () => uploadImageToFirebase(context),
//               child: Text(
//                 "Upload Image",
//                 style: TextStyle(fontSize: 20, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// /*
// if request.auth != null*/

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumer_checkin/services/db_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  String url = "";

  final DatabaseService _db = DatabaseService();
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      chooseImage();
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      opencamera();
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  bool uploading = false;
  double val = 0;
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;
  List<File> _image = [];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Image'),
          actions: [
            FlatButton(
                onPressed: () {
                  uploadFile().whenComplete(() => Navigator.of(context).pop());
                },
                child: const Text(
                  'upload',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: GridView.builder(
            itemCount: _image.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (context, index) {
              return index == 0
                  ? Center(
                      child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _showChoiceDialog(context);
                          }),
                    )
                  : Container(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _image.removeAt(index - 1);
                          });
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(_image[index - 1]),
                              fit: BoxFit.cover)),
                    );

              ;
            }));
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile!.path == null) retrieveLostData();
  }

  opencamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 0;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef.add({'url': value});
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('Consumers');
  }
}

//FirebaseFirestore.instance.collection.doc().add