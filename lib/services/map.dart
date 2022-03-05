import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:consumer_checkin/constant/colors_constant.dart';
import 'package:consumer_checkin/local_DB/local_db.dart';
import 'package:consumer_checkin/models/consumer.dart';
import 'package:consumer_checkin/screens/retrieve_locations.dart';
import 'package:consumer_checkin/services/auth.dart';
import 'package:consumer_checkin/services/db_firestore.dart';
import 'package:consumer_checkin/services/google_sheets.dart';
import 'package:consumer_checkin/services/searchBy.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';


class MapApp extends StatefulWidget {
  const MapApp({this.lan, this.lat});
  final lan;
  final lat;

  @override
  _MapAppState createState() => _MapAppState();
}

var numberExists;
var nicNumExists;
var emailExists;

class _MapAppState extends State<MapApp> {
  String consumerID = "";
  String plotType = "";
  String name = "";
  String number = "";
  String email = "";
  String zone = "";
  String ward = "";
  String uc = "";
  int houseNum = 0;
  String area = "";
  String unitNum = "";
  String block = "";
  String address = "";
  String newAddress = "";
  String gasCompany = "";
  String electricCompany = "";
  String landlineNumber = "";
  String nicNumber = "";
  String taluka = "";
  String searchID = "";
  String loggedInUserName = "";
  String loggedInUserEmail = "";
  String surveyorEmail = "";
  String plotTypeLetter = "";
  int entryNum = 0;
  bool isConnected = false;
  bool isLocked = false;
  late Uri url1;
  bool uploading = false;
  double val = 0;
  final List<Uri> imageList = [];
  late firebase_storage.Reference ref;
  final List<File> _image = [];
  final picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var plotTypeDropDown = ["Domestic", "Commercial"];
  final List<String> _talukaList = [
    "Hyderabad Taluka",
    "Qasimabad Taluka",
    "Latifabad Taluka",
    "Hyderabad City Taluka"
  ];
  final List<String> _unitNumList = ["Unit # 1", "Unit # 2", "Unit # 3", "Unit # 4", "Unit # 5", "Unit # 6", "Unit # 7", "Unit # 8", "Unit # 9", "Unit # 10", "Unit # 11", "Unit # 12", ];
  final List<String> _zoneList = ["01", "02", "03", "04", "05", "06", "07",];
  final List<String> _wardList = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10",];
  final List<String> _ucNumList = ["UC # 1", "UC # 2", "UC # 3", "UC # 4", "UC # 5", "UC # 6", "UC # 7", "UC # 8", "UC # 9", "UC # 10", "UC # 11", "UC # 12", "UC # 13", "UC # 14",
  ];
  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();
  final _emailTextController = TextEditingController();
  final _consumerIdTextController = TextEditingController();
  final _consumerNameTextController = TextEditingController();
  final _mobileNumberTextController = TextEditingController();
  final _landlineIdTextController = TextEditingController();
  final _gasCompanyIdTextController = TextEditingController();
  final _electricCompanyIdTextController = TextEditingController();
  final _wardTextController = TextEditingController();
  final _zoneTextController = TextEditingController();
  final _nicNumberTextController = TextEditingController();
  final _houseNumTextController = TextEditingController();
  final _streetTextController = TextEditingController();
  final _blockTextController = TextEditingController();
  final _areaTextController = TextEditingController();

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      int startIndexConsumerId = 0;
      int endIndexConsumerId = 11;
      String resultConsumerId =
      barcodeScanRes.substring(startIndexConsumerId, endIndexConsumerId);
      _consumerIdTextController.text = resultConsumerId.toString();
      consumerID = resultConsumerId;
      int startIndexZone = 0;
      int endIndexZone = 2;
      String resultZone =
      barcodeScanRes.substring(startIndexZone, endIndexZone);
      _zoneTextController.text = resultZone;
      int startIndexWard = 2;
      int endIndexWard = 4;
      String resultWard =
      barcodeScanRes.substring(startIndexWard, endIndexWard);
      _wardTextController.text = resultWard;
    });
  }

  openCamera() async {
    dynamic pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);

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
      //print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imageList.add(Uri.parse(value));
          i++;
        });
      });
    }
  }

  void _takePhoto(String name) async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      final recordedImage = img;

      {
        if (recordedImage != null && recordedImage.path != null) {
          setState(() {
            //  firstButtonText = 'saving in progress...';
          });
          String dir = (await getApplicationDocumentsDirectory()).path;
          String newPath = path.join(dir, '$name.jpg');
          File fa = await File(recordedImage.path).copy(newPath);
          GallerySaver.saveImage(fa.path, albumName: "Intrapreneur")
              .then((path) {
            setState(() {
              //      firstButtonText = 'image saved!';
            });
          });
        }
      }
    }
  }


  var numberFormatter = MaskTextInputFormatter(
      mask: '####-#######', filter: {"#": RegExp(r'[0-9]')});

  var nicNumberFormatter = MaskTextInputFormatter(
      mask: '#####-#######-#', filter: {"#": RegExp(r'[0-9]')});

  var blockFormatter = MaskTextInputFormatter(
      mask: '*-##',
      filter: {"#": RegExp(r'[0-9]'), "*": RegExp(r'[a-z, A-Z]')});

  void clearForm() {
    setState(() {
      _consumerIdTextController.clear();
      _consumerNameTextController.clear();
      _mobileNumberTextController.clear();
      _emailTextController.clear();
      _nicNumberTextController.clear();
      _zoneTextController.clear();
      _wardTextController.clear();
      _areaTextController.clear();
      _houseNumTextController.clear();
      _streetTextController.clear();
      _blockTextController.clear();
    });
  }

  void clearFormLocked() {
    setState(() {
      _consumerIdTextController.clear();
      _consumerNameTextController.clear();
      _mobileNumberTextController.clear();
      _emailTextController.clear();
      _nicNumberTextController.clear();
      _houseNumTextController.clear();
      _streetTextController.clear();
      _blockTextController.clear();
    });
  }

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
    imageList.clear();
  }

  @override
  void dispose() {
    _consumerIdTextController.dispose();
    _consumerNameTextController.dispose();
    _mobileNumberTextController.dispose();
    _nicNumberTextController.dispose();
    _emailTextController.dispose();
    _zoneTextController.dispose();
    _wardTextController.dispose();
    _areaTextController.dispose();
    _streetTextController.dispose();
    _houseNumTextController.dispose();
    _blockTextController.dispose();
    _gasCompanyIdTextController.dispose();
    _electricCompanyIdTextController.dispose();
    _landlineIdTextController.dispose();
    super.dispose();
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            scrollable: true,
            title: const Text('Consumer Check-In'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 120, 20, 0),
                        child: Image(
                          image: const AssetImage("assets/Wasa-Logo.png"),
                          color: Colors.white.withOpacity(0.08),
                          colorBlendMode: BlendMode.modulate,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          scanBarcodeNormal();
                                        });
                                      },
                                      child: Text(
                                        "Scan QR/Barcode",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kMaroon
                                        )
                                      )),
                                ],
                              ),
                             /* TextFormField(
                                controller: _consumerIdTextController,
                                decoration: const InputDecoration(
                                  labelText: 'Consumer Id',
                                  suffixText: '*',
                                  suffixStyle: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                onChanged: (val) => setState(() {
                                  consumerID = val;
                                }),
                                validator: (String? val) {
                                  if (val == null || val.trim().length == 0) {
                                    return "Consumer ID is mandatory";
                                  } else {
                                    return null;
                                  }
                                },
                              ),*/
                              DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                    labelText: "Plot Type",
                                  ),
                                  items: plotTypeDropDown.map((plotType) {
                                    return DropdownMenuItem(
                                      child: Text(plotType),
                                      value: plotType,
                                    );
                                  }).toList(),
                                  validator: (String? val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return "Please select a plot type first";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() => plotType = val.toString());
                                  }),
                              TextFormField(
                                controller: _consumerNameTextController,
                                decoration: const InputDecoration(
                                  labelText: 'Consumer Name',
                                ),
                                onChanged: (val) => setState(() {
                                  name = val.toString();
                                }),
                                validator: (String? val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return "Please select a plot type first";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              TextFormField(
                                controller: _mobileNumberTextController,
                                inputFormatters: [numberFormatter],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Mobile Number',
                                  suffixText: '*',
                                  suffixStyle: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                onChanged: (val) => setState(() {
                                  number = val;
                                }),
                                validator: (String? val) {
                                  if (val == null || val.trim().length == 0) {
                                    return "Consumer Number is mandatory";
                                  } else if (val.length < 12) {
                                    return "Consumer Number is Invalid";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              TextFormField(
                                controller: _nicNumberTextController,
                                inputFormatters: [nicNumberFormatter],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'CNIC Number',
                                  suffixText: '*',
                                  suffixStyle: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                onChanged: (val) => setState(() {
                                  nicNumber = val;
                                }),
                                validator: (String? val) {
                                  if (val == null || val.trim().length == 0) {
                                    return "Consumer CNIC Number is mandatory";
                                  } else if (val.length < 12) {
                                    return "Consumer CNIC_Number is Invalid";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              TextFormField(
                                controller: _emailTextController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                ),
                                onChanged: (val) => setState(() {
                                  email = val;
                                }),
                                validator: (val) {
                                  // Check if this field is empty
                                  if (val == null || val.isEmpty) {
                                    return 'This field is required';
                                  }
                                  // using regular expression
                                  if (!RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                      r"{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(val)) {
                                    return "Please enter a valid email address";
                                  }
                                  // the email is valid
                                  return null;
                                },
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                          labelText: "Taluka",
                                        ),
                                        items: _talukaList.map((taluka) {
                                          return DropdownMenuItem(
                                            child: Text(taluka),
                                            value: taluka,
                                          );
                                        }).toList(),
                                        validator: (String? val) {
                                          if (val == null || val.trim().isEmpty) {
                                            return "Please select a Taluka";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (val) {
                                          setState(() => taluka = val.toString());
                                        }),
                                  ),
                                  const Divider(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Switch(
                                        activeTrackColor: kYellow,
                                        activeColor: kMaroon,
                                        value: isLocked,
                                        onChanged: (val) {
                                          setState(() => isLocked = val);
                                        },
                                      ),
                                      !isLocked
                                          ? const Text(
                                        "Lock",
                                        style: TextStyle(fontSize: 14),
                                      )
                                          : const Text(
                                        "Locked",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                    labelText: "UC",
                                  ),
                                  items: _ucNumList.map((ucNum) {
                                    return DropdownMenuItem(
                                      child: Text(ucNum),
                                      value: ucNum,
                                    );
                                  }).toList(),
                                  validator: (String? val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return "Please select a UC";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() => uc = val.toString());
                                  }),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                          labelText: "Zone",
                                        ),
                                        items: _zoneList.map((zone) {
                                          return DropdownMenuItem(
                                              child: Text(zone), value: zone);
                                        }).toList(),
                                        validator: (String? val) {
                                          if (val == null || val.trim().isEmpty) {
                                            return "Please select a Zone";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (val) {
                                          setState(() => zone = val.toString());
                                        }),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                          labelText: "Ward",
                                        ),
                                        items: _wardList.map((ward) {
                                          return DropdownMenuItem(
                                            child: Text(ward),
                                            value: ward,
                                          );
                                        }).toList(),
                                        validator: (String? val) {
                                          if (val == null || val.trim().isEmpty) {
                                            return "Please select a Ward";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (val) {
                                          setState(() => ward = val.toString());
                                        }),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _areaTextController,
                                      decoration: const InputDecoration(
                                        labelText: 'Area',
                                        suffixText: '*',
                                        suffixStyle: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      onChanged: (val) => setState(() {
                                        area = val;
                                      }),
                                      validator: (String? val) {
                                        if (val == null || val.trim().isEmpty) {
                                          return "Please enter an area";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _houseNumTextController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'H #',
                                        suffixText: '*',
                                        suffixStyle: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      onChanged: (val) => setState(() {
                                        houseNum = int.parse(val);
                                      }),
                                      validator: (String? val) {
                                        if (val == null || val.trim().isEmpty) {
                                          return "Please enter a house or plot number";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                        inputFormatters: [blockFormatter],
                                        controller: _blockTextController,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                        TextCapitalization.characters,
                                        decoration: const InputDecoration(
                                          labelText: 'Block',
                                          suffixText: '*',
                                          suffixStyle: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        onChanged: (val) => setState(() {
                                          block = val;
                                        }),
                                        validator: (String? val) {
                                          if (val == null || val.trim().isEmpty) {
                                            return "Please enter block number";
                                          } else {
                                            return null;
                                          }
                                        },
                                      )),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                          labelText: "Unit #",
                                        ),
                                        items: _unitNumList.map((unitNum) {
                                          return DropdownMenuItem(
                                            child: Text(unitNum),
                                            value: unitNum,
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() => unitNum = val.toString());
                                        }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        openCamera();
                      },
                      child: Text(
                        "TAKE IMAGE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kMaroon),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {

                          //Checking whether mobile number, Cnic, or email already exists in database, if it does, we just show an alert dialog
                          numberExists = await _db.doesNumberAlreadyExist(number);
                          nicNumExists = await _db.doesNicNumberAlreadyExist(nicNumber);
                          emailExists = await _db.doesEmailAlreadyExist(email);
                          if (numberExists || nicNumExists || emailExists) {
                            CoolAlert.show(context: context,
                                type: CoolAlertType.error,
                                text: "This Data already exists",
                                autoCloseDuration: const Duration(milliseconds: 3000)
                            );
                            // showDialog(context: context, builder: (context) {
                            //   return AlertDialog(
                            //     content: const Text("This data already exists"),
                            //     actions: [
                            //       GestureDetector(
                            //           child: Text("Close", style: TextStyle(color: kMaroon, fontWeight: FontWeight.bold)),
                            //         onTap: () {Navigator.pop(context);},
                            //       )
                            //     ],
                            //   );
                            // });
                          }
                          else {
                            entryNum = await _db.countEntriesInZoneWard(zone, ward) + 1;
                            plotType == "Domestic" ? plotTypeLetter = "D" : plotTypeLetter = "C";
                            consumerID = zone + "-" + ward + "-" + entryNum.toString() + plotTypeLetter ;
                            address = "";
                            address += "House # " +
                                houseNum.toString() +
                                " " +
                                unitNum.toString() +
                                " block " +
                                block.toString() +
                                " " +
                                area.toString();

                            if (!isConnected) {
                              _takePhoto(consumerID);
                              // If network detected is found to be false, the the consumer records are stored in SQLite db using the method below
                              DBProvider.db.insertConsumerEntryOffline(
                                  consumerId: consumerID,
                                  plotType: plotType,
                                  name: name,
                                  number: number,
                                  email: email,
                                  cnic: nicNumber,
                                  taluka: taluka,
                                  ucNum: uc,
                                  zone: zone,
                                  wardNumber: ward,
                                  area: area,
                                  houseNum: houseNum,
                                  block: block,
                                  unitNum: unitNum,
                                  address: address,
                                  newAddress: newAddress,
                                  gasCompany: gasCompany,
                                  electricCompany: electricCompany,
                                  landlineCompany: landlineNumber
                              );
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    Future.delayed(
                                        const Duration(milliseconds: 1500), () {
                                      Navigator.of(context).pop(true);
                                    });
                                    return const AlertDialog(
                                      title: Text('Data Inserted'),
                                    );
                                  });
                            }
                            if (isConnected) {
                              final consumer = {
                                ConsumerFields.plotType: plotType,
                                ConsumerFields.id: consumerID,
                                ConsumerFields.name: name,
                                ConsumerFields.number: number,
                                ConsumerFields.cnicNum: nicNumber,
                                ConsumerFields.email: email,
                                ConsumerFields.taluka: taluka,
                                ConsumerFields.ucNum: uc,
                                ConsumerFields.zoneNum: zone,
                                ConsumerFields.wardNum: ward,
                                ConsumerFields.area: area,
                                ConsumerFields.unitNum: unitNum,
                                ConsumerFields.block: block,
                                ConsumerFields.houseNum: houseNum,
                                ConsumerFields.address: address,
                                ConsumerFields.newAddress: newAddress,
                                ConsumerFields.gasCompanyId: gasCompany,
                                ConsumerFields
                                    .electricCompanyId: electricCompany,
                                ConsumerFields
                                    .landlineCompanyId: landlineNumber,
                                ConsumerFields.dateTime: json.encode(DateTime.now().toIso8601String()) ,
                              };
                              CoolAlert.show(context: context, type: CoolAlertType.loading);
                              // showDialog(context: context,
                              //     builder: (BuildContext context) {
                              //       return const Center(
                              //           child: CircularProgressIndicator());
                              //     });
                              await uploadFile();
                              Navigator.pop(context);
                              await ConsumerSheetsAPI.insert([consumer]);
                            }

                            print("::::::::::::::::::::::::::::" + entryNum.toString());
                            // Along storing the data to sqlite, we also insert to Firebase, the data will be stored in firebase cache, and when network status changes, the offline data is synced with firebase
                            _db.addConsumerEntry(
                              plotType: plotType,
                              consumerID: consumerID,
                              name: name,
                              number: number,
                              email: email,
                              taluka: taluka,
                              uc: uc,
                              zone: zone,
                              ward: ward,
                              block: block,
                              unitNum: unitNum,
                              area: area,
                              houseNum: houseNum,
                              nicNum: nicNumber,
                              address: address,
                              gasCompany: gasCompany,
                              electricCompany: electricCompany,
                              landlineCompany: landlineNumber,
                              location: GeoPoint(widget.lat, widget.lan),
                              url: imageList.isNotEmpty ? imageList[0]
                                  .toString() : "",
                                loggedInEmail: loggedInUserEmail,
                                loggedInUser: loggedInUserName,
                              dateTime: json.encode(DateTime.now().toIso8601String())
                            );
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  Future.delayed(
                                      const Duration(milliseconds: 1500), () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return const AlertDialog(
                                    title: Text('Data Inserted'),
                                  );
                                });
                            if (!isLocked) {
                              clearForm();
                              //imageList.clear();
                            } else {
                              clearFormLocked();
                              _formKey.currentState!.reset();
                              //imageList.clear();
                            }
                            _markers.clear();
                          }
                        }
                      },
                      child: Text(
                        "SAVE",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, color: kMaroon),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showAlertMoreDetails();
                      },
                      child: Text(
                        "MORE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kMaroon),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  void _showAlertMoreDetails() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // backgroundColor: Colors.red,
            scrollable: true,
            title: const Text('More Information'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        controller: _electricCompanyIdTextController,
                        decoration: const InputDecoration(
                          labelText: 'Electric Company Id',
                        ),
                        onChanged: (val) => setState(() {
                          electricCompany = val;
                        })),
                    TextFormField(
                        controller: _gasCompanyIdTextController,
                        decoration: const InputDecoration(
                          labelText: 'Gas Company Id',
                        ),
                        onChanged: (val) => setState(() {
                          gasCompany = val;
                        })),
                    TextFormField(
                        controller: _landlineIdTextController,
                        decoration: const InputDecoration(
                          labelText: 'Land-Line Number',
                        ),
                        onChanged: (val) => setState(() {
                          landlineNumber = val;
                        })),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        "BACK",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kMaroon),
                      ),
                    ),
                    Text(
                      "SAVE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: kMaroon),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  final Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};

  MapType _currentMapType = MapType.normal;

  Future<void> _goToTheLake() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(widget.lat, widget.lan),
      zoom: 19.0,
    )));
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onCameraMove(CameraPosition position) {}

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _addMarkerOnTap(LatLng point) {
    setState(() {
      if (_markers.isEmpty) {
        _markers.add(Marker(
            markerId: MarkerId(point.toString()),
            position: point,
            icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            onTap: () {
              _showAlertDialog();
            }));
      }
    });
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    FirebaseFirestore.instance.collection("users").doc(user!.uid).get().then((value) {
      setState(() {
        loggedInUserName = value["userName"];
        loggedInUserEmail = value["Email"];
      });
    });

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              shrinkWrap: true,
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(loggedInUserName),
                  accountEmail: Text(loggedInUserEmail),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage("assets/Wasa-Logo1.png"),
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xffb11118),
                  ),
                ),
                ListTile(
                  title: const Text('Load Data'),
                  leading: const Icon(Icons.download),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RetrieveMarkers()));
                  },
                ),
                // Search tile in navigation drawer
                ListTile(
                  title: const Text('Search'),
                  leading: const Icon(Icons.search),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              scrollable: true,
                              title: const Text('Consumer Details'),
                              content: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                            decoration: InputDecoration(
                                                labelText:
                                                'Search by Consumer ID',
                                                // border: const OutlineInputBorder(),
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    if (searchID.isNotEmpty) {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                                return RetrieveMarkersBySearch(
                                                                  name: "ConsumerID",
                                                                  searchID: searchID,
                                                                );
                                                              }));
                                                    }
                                                  },
                                                  child:
                                                  const Icon(Icons.search),
                                                )),
                                            onChanged: (val) => setState(() {
                                              searchID = val;
                                            })),
                                        TextFormField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              nicNumberFormatter
                                            ],
                                            decoration: InputDecoration(
                                                labelText: 'Search by CNIC',
                                                // border: const OutlineInputBorder(),
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    if (nicNumber.isNotEmpty) {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                                return RetrieveMarkersBySearch(
                                                                  name: "NicNumber",
                                                                  searchID: nicNumber,
                                                                );
                                                              }));
                                                    }
                                                  },
                                                  child:
                                                  const Icon(Icons.search),
                                                )),
                                            onChanged: (val) => setState(() {
                                              nicNumber = val;
                                            })),
                                        TextFormField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [numberFormatter],
                                            decoration: InputDecoration(
                                                labelText:
                                                'Search by Mobile Number',
                                                // border: const OutlineInputBorder(),
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    if (number.isNotEmpty) {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                                return RetrieveMarkersBySearch(
                                                                  name: "Number",
                                                                  searchID: number,
                                                                );
                                                              }));
                                                    }
                                                  },
                                                  child:
                                                  const Icon(Icons.search),
                                                )),
                                            onChanged: (val) => setState(() {
                                              number = val;
                                            })),
                                        TextFormField(
                                          keyboardType:
                                          TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                              labelText:
                                              'Search by Surveyor_Email',
                                              // border: const OutlineInputBorder(),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  if (surveyorEmail
                                                      .isNotEmpty) {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                              return RetrieveMarkersBySearch(
                                                                name: "Surveyor_Email",
                                                                searchID: surveyorEmail,
                                                              );
                                                            }));
                                                  }
                                                },
                                                child: const Icon(Icons.search),
                                              )),
                                          onChanged: (val) => setState(() {
                                            surveyorEmail = val;
                                          }),
                                          validator: (val) {
                                            // Check if this field is empty
                                            if (val == null || val.isEmpty) {
                                              return 'This field is required';
                                            }

                                            // using regular expression
                                            if (!RegExp(
                                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                                r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                                r"{0,253}[a-zA-Z0-9])?)*$")
                                                .hasMatch(val)) {
                                              return "Please enter a valid email address";
                                            }

                                            // the email is valid
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                            labelText: "Plot Type",
                                            border: OutlineInputBorder()),
                                        items: plotTypeDropDown.map((plotType) {
                                          return DropdownMenuItem(
                                            child: Text(plotType),
                                            value: plotType,
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return RetrieveMarkersBySearch(
                                                      name: "Plot_type",
                                                      searchID: val.toString(),
                                                    );
                                                  }));
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                            labelText: "UC",
                                            border: OutlineInputBorder()),
                                        items: _ucNumList.map((ucNum) {
                                          return DropdownMenuItem(
                                            child: Text(ucNum),
                                            value: ucNum,
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return RetrieveMarkersBySearch(
                                                      name: "UC",
                                                      searchID: val.toString(),
                                                    );
                                                  }));
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                            labelText: "Taluka",
                                            border: OutlineInputBorder()),
                                        items: _talukaList.map((taluka) {
                                          return DropdownMenuItem(
                                            child: Text(taluka),
                                            value: taluka,
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return RetrieveMarkersBySearch(
                                                      name: "Taluka",
                                                      searchID: val.toString(),
                                                    );
                                                  }));
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                            labelText: "Zone",
                                            border: OutlineInputBorder()),
                                        items: _zoneList.map((zone) {
                                          return DropdownMenuItem(
                                            child: Text(zone.toString()),
                                            value: zone.toString(),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return RetrieveMarkersBySearch(
                                                      name: "Zone",
                                                      searchID: val.toString(),
                                                    );
                                                  }));
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                            labelText: "Ward",
                                            border: OutlineInputBorder()),
                                        items: _wardList.map((ward) {
                                          return DropdownMenuItem(
                                            child: Text(ward.toString()),
                                            value: ward.toString(),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return RetrieveMarkersBySearch(
                                                      name: "Ward",
                                                      searchID: val.toString(),
                                                    );
                                                  }));
                                        }),
                                  ),
                                ],
                              ),
                              actions: [
                                GestureDetector(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        "Close",
                                        style: TextStyle(
                                            color: kMaroon,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    })
                              ]);
                        });
                  },
                ),
                ListTile(
                  enabled: isConnected ? true : false,
                  title: const Text('Sync Data'),
                  leading: const Icon(Icons.sync),
                  onTap: () async {
                    Map<String, dynamic> consumer;
                    try {
                      List<Map<String, dynamic>> consumerEntries =
                      await DBProvider.db.queryAllRows();
                      if (consumerEntries.isEmpty) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              Future.delayed(const Duration(milliseconds: 1500),
                                      () {
                                    Navigator.of(context).pop(true);
                                  });
                              return const AlertDialog(
                                title: Text("There is no data to sync"),
                              );
                            });
                      } else {
                        for (var element in consumerEntries) {
                          consumer = {
                            ConsumerFields.id: element["Consumer_Id"],
                            ConsumerFields.plotType: element["Plot_Type"],
                            ConsumerFields.name: element["Consumer_Name"],
                            ConsumerFields.number: element["Number"],
                            ConsumerFields.cnicNum: element["CNIC"],
                            ConsumerFields.email: element["Email"],
                            ConsumerFields.taluka: element["Taluka"],
                            ConsumerFields.ucNum: element["UC_Num"],
                            ConsumerFields.zoneNum: element["Zone_Num"],
                            ConsumerFields.wardNum: element["Ward_Num"],
                            ConsumerFields.area: element["Area"],
                            ConsumerFields.unitNum: element["Street"],
                            ConsumerFields.block: element["Block"],
                            ConsumerFields.houseNum: element["House_Number"],
                            ConsumerFields.address: element["Address"],
                            ConsumerFields.newAddress: element["New_Address"],
                            ConsumerFields.gasCompanyId:
                            element["Gas_Company_Id"],
                            ConsumerFields.electricCompanyId:
                            element["Electricity_Company_Id"],
                            ConsumerFields.landlineCompanyId:
                            element["Landline_Company_Id"],
                          };
                          await ConsumerSheetsAPI.insert([consumer]);
                        }
                      }
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            Future.delayed(const Duration(milliseconds: 1500),
                                    () {
                                  Navigator.of(context).pop(true);
                                });
                            return const AlertDialog(
                              title: Text('Data uploaded to Google Sheets'),
                            );
                          });
                      DBProvider.db.deleteFromConsumersTable();
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(
                                  "Something went wrong... " + e.toString()),
                              actions: [
                                GestureDetector(
                                  child: const Text("Okay"),
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
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
          body: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                onTap: _addMarkerOnTap,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.lat, widget.lan),
                  zoom: 15.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: _onMapTypeButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: const Color(0xffb11118),
                        child: const Icon(Icons.map, size: 36.0),
                      ),
                      const SizedBox(height: 16.0),
                      FloatingActionButton(
                        heroTag: "btn3",
                        onPressed: _goToTheLake,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: const Color(0xffb11118),
                        child: const Icon(
                          Icons.my_location,
                          size: 36.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}