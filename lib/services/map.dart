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
import 'package:consumer_checkin/services/networking.dart';
import 'package:consumer_checkin/services/searchBy.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String oldAddress = "";
  String oldconsumerID = "";
  String plotType = "";
  String name = "";
  String number = "";
  String email = "";
  String tariffOrDia = "";
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
  final List<String> _unitNumList = [
    "Unit # 1",
    "Unit # 2",
    "Unit # 3",
    "Unit # 4",
    "Unit # 5",
    "Unit # 6",
    "Unit # 7",
    "Unit # 8",
    "Unit # 9",
    "Unit # 10",
    "Unit # 11",
    "Unit # 12",
  ];
  final List<String> _zoneList = [
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
  ];
  final List<String> _wardList = [
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
  ];
  // final List<String> _ucNumList = [
  //   "UC # 1",
  //   "UC # 2",
  //   "UC # 3",
  //   "UC # 4",
  //   "UC # 5",
  //   "UC # 6",
  //   "UC # 7",
  //   "UC # 8",
  //   "UC # 9",
  //   "UC # 10",
  //   "UC # 11",
  //   "UC # 12",
  //   "UC # 13",
  //   "UC # 14",
  // ];
  final List<double> _diaList = [0.5, 0.75, 1, 1.5, 2];
  final List<String> _tariffList = ["A", "AG + 1", "AG+2", "AG + 3", "B", "BG + 1", "BG + 2", "BG + 3",
    "C", "CG + 1", "CG + 2", "CG + 3", "D", "DG + 1", "DG + 2", "DG + 3", "E", "EG + 1", "EG + 2", "EG + 3",
    "F", "FG + 1", "FG + 2", "FG + 3"];
  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();
  final _emailTextController = TextEditingController();
  final _consumerIdTextController = TextEditingController();
  final _oldconsumerIdTextController = TextEditingController();
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
  final _oldAddressTextController = TextEditingController();
  final _plottypeTextController = TextEditingController();

  Future<void> scanBarcode() async {
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
      int startIndexConsumerId = 4;
      int endIndexConsumerId = 10;
      String resultConsumerId =
      barcodeScanRes.substring(startIndexConsumerId, endIndexConsumerId);
      //_oldconsumerIdTextController.text = resultConsumerId.toString();
      // oldconsumerID = resultConsumerId;

      int startIndexConsumerplot = 10;
      int endIndexConsumerplot = 11;
      String resultConsumerplot = barcodeScanRes.substring(
          startIndexConsumerplot, endIndexConsumerplot);
      _plottypeTextController.text = resultConsumerplot.toString();

      int startIndexZone = 0;
      int endIndexZone = 2;
      String resultZone =
      barcodeScanRes.substring(startIndexZone, endIndexZone);
      _zoneTextController.text = resultZone;
      zone = resultZone;
      int startIndexWard = 2;
      int endIndexWard = 4;
      String resultWard =
      barcodeScanRes.substring(startIndexWard, endIndexWard);
      _wardTextController.text = resultWard;
      ward = resultWard;

      String oldidofconsumer = (resultZone +
          "-" +
          resultWard +
          "-" +
          resultConsumerId +
          "-" +
          resultConsumerplot);
      _oldconsumerIdTextController.text = oldidofconsumer.toString();
      oldconsumerID = oldidofconsumer;
    });
  }

  consumerIdSubstring(dataById) {
    String dataByIdintofeilds = dataById;
    print("hhhhhhhhhhhhhh" + dataByIdintofeilds);
    int startIndexConsumertype = 14;

    String resultConsumertype = dataByIdintofeilds.substring(14);
    print("hhhhhhhhhhhhhh" + resultConsumertype);
    // _consumerIdTextController.text = resultConsumertype.toString();
    //  consumerID = resultConsumertype;

    int startIndexZone = 0;
    int endIndexZone = 2;
    String resultZone =
    dataByIdintofeilds.substring(startIndexZone, endIndexZone);

    print("hhhhhhhhhhhhhh" + resultZone);
   //  _zoneTextController.text = resultZone;
      setState(() {
        zone = resultZone;
      });

    int startIndexWard = 3;
    int endIndexWard = 5;
    String resultWard =
    dataByIdintofeilds.substring(startIndexWard, endIndexWard);
    setState(() {
      ward = resultWard;
    });
    print("hhhhhhhhhhhhhh" + resultWard);
    //    _wardTextController.text = resultWard;
  }

  openCamera() async {
    dynamic pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);

    if (!mounted) return;
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
    if (!mounted) return;
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong, please reboot the app")));
    }
  }

  Future uploadFile() async {
    int i = 1;

    if (!mounted) return;
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

  // retriving data from server and set into feilds

  Future<dynamic> getDataFromID(id) async {
    Networkhelper networkhelper = Networkhelper(
        'http://182.176.105.49:8081/consumercheckin/linker.php?search_consumer=true&consumer_no=$id');

    var iddata = await networkhelper.getData();

    print("Anas khan" + iddata[1]["consumer_no"]);
    if (iddata[1]["consumer_no"] == null ||
        iddata[1]["consumer_no"] == "null" ||
        iddata[1]["consumer_no"] == "") {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            // Future.delayed(const Duration(milliseconds: 1500), () {
            //   Navigator.of(context).pop(true);
            // });
            return const AlertDialog(
              title: Text('No such data'),
            );
          });
    } else {
      _consumerNameTextController.text =
          iddata[1]["consumer_name"] ?? "";
      name = iddata[1]["consumer_name"] ?? "";

      _mobileNumberTextController.text =
          iddata[1]["consumer_phone"] ?? "";
      number = iddata[1]["consumer_phone"] ?? "";

      _emailTextController.text = iddata[1]["consumer_email"] ?? "";
      email = iddata[1]["consumer_email"] ?? "";

      _oldAddressTextController.text =
          iddata[1]["consumer_address"] ?? "";
      oldAddress = iddata[1]["consumer_address"] ?? "";

      _oldconsumerIdTextController.text =
          iddata[1]["consumer_no"] ?? "";
      oldconsumerID = iddata[1]["consumer_no"] ?? "";

      setState(() {
        String cid = id.toString();
        int startIndexZone = 0;
        int endIndexZone = 2;
        String resultZone = cid.substring(startIndexZone, endIndexZone);
        _zoneTextController.text = resultZone;
        int startIndexWard = 3;
        int endIndexWard = 5;
        String resultWard = cid.substring(startIndexWard, endIndexWard);
        _wardTextController.text = resultWard;
      });

      // _zoneTextController.text =
      //     iddata[1]["consumer_no"].toString() ?? "";
      // zone = iddata[1]["consumer_no"].toString() ?? "";

      // _wardTextController.text =
      //     iddata[1]["consumer_no"].toString() ?? "";
      // ward = iddata[1]["consumer_no"].toString() ?? "";

      // _plottypeTextController.text =
      //     iddata[1]["consumer_status"].toString() ?? "";
      // plotType = iddata[1]["consumer_status"].toString() ?? "";

      if (iddata[1]["consumer_status"].toString() == "Domestic") {
        _plottypeTextController.text = "D";
        setState(() => plotType = "D");
      } else if (iddata[1]["consumer_status"].toString() == "Commercial") {
        _plottypeTextController.text = "C";
        setState(() => plotType = "C");
      }

      print(name);

      return iddata[1];
    }
  }

  var numberFormatter = MaskTextInputFormatter(
      mask: '####-#######', filter: {"#": RegExp(r'[0-9]')});

  var nicNumberFormatter = MaskTextInputFormatter(
      mask: '#####-#######-#', filter: {"#": RegExp(r'[0-9]')});

  var blockFormatter = MaskTextInputFormatter(
      mask: '*-##',
      filter: {"#": RegExp(r'[0-9]'), "*": RegExp(r'[a-z, A-Z]')});

  var consumerIdFormatter = MaskTextInputFormatter(
      mask: '##-##-#####-#-*',
      filter: {"#": RegExp(r'[0-9]'), "*": RegExp(r'[A-Z]')});

  var plotTypeMask =
  MaskTextInputFormatter(mask: '#', filter: {"#": RegExp(r'[C-D]')});

  var zoneFormatter =
  MaskTextInputFormatter(mask: '0#', filter: {"#": RegExp(r'[1-9]')});

  var wardFormatter =
  MaskTextInputFormatter(mask: '0#', filter: {"#": RegExp(r'[1-9]')});

  void clearForm() {
    if (!mounted) return;
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
    if (!mounted) return;
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
      if (!mounted) return;
      setState(() => isConnected = false);
    } else {
      if (!mounted) return;
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
    super.dispose();
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
    imageList.clear();
    markers.clear();
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
                                          scanBarcode();
                                        });
                                      },
                                      child: Expanded(
                                        child: Text("Scan QR/Barcode",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kMaroon)),
                                      )),
                                  const Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: TextFormField(
                                                    controller:
                                                    _oldconsumerIdTextController,
                                                    inputFormatters: [
                                                      consumerIdFormatter
                                                    ],
                                                    textCapitalization:
                                                    TextCapitalization
                                                        .characters,
                                                    decoration: InputDecoration(
                                                      labelText: 'Consumer ID',
                                                      suffixIcon: GestureDetector(
                                                          onTap: () {
                                                            consumerIdSubstring(
                                                                oldconsumerID);
                                                            Navigator.of(context)
                                                                .pop(true);

                                                            getDataFromID(
                                                                oldconsumerID);
                                                          },
                                                          child: const Icon(Icons
                                                              .navigate_next_outlined)),
                                                    ),
                                                    onChanged: (val) =>
                                                        setState(() {
                                                          oldconsumerID =
                                                              val.toString();
                                                        }),
                                                    validator: (String? val) {
                                                      if (val == null ||
                                                          val.trim().isEmpty) {
                                                        return "Please enter Consumer ID First";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                );
                                              });
                                        });
                                      },
                                      child: Expanded(
                                        child: Row(
                                          children: [
                                            Icon(Icons.search, color: kMaroon),
                                            const SizedBox(
                                              width: 3.2,
                                            ),
                                            Text("Search ID",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kMaroon)),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              TextFormField(
                                enabled: false,
                                controller: _oldconsumerIdTextController,
                                inputFormatters: [consumerIdFormatter],
                                textCapitalization: TextCapitalization.characters,
                                decoration: const InputDecoration(
                                  labelText: 'Old Consumer ID',
                                ),
                                onChanged: (val) => setState(() {
                                  oldconsumerID = val.toString();
                                }),
                              ),
                              TextFormField(
                                controller: _plottypeTextController,
                                inputFormatters: [plotTypeMask],
                                textCapitalization: TextCapitalization.characters,
                                decoration: const InputDecoration(
                                  labelText: 'Plot Type',
                                ),
                                onChanged: (val) => setState(() {
                                  plotType = val.toString();
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
                              DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                                    hintText: "Tariff"
                                ),
                                  items:
                                  _tariffList.map((tariff) {
                                    return DropdownMenuItem(
                                      child: Text(tariff),
                                      value: tariff,
                                    );
                                  }).toList(),
                                  onChanged: plotType == "D" ?
                                      (val) {
                                  setState(() => tariffOrDia = val.toString());
                                } :
                                  null,
                              ),
                              DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                                      hintText: "Dia"
                                  ),
                                  items:
                                  _diaList.map((dia) {
                                    return DropdownMenuItem(
                                      child: Text(dia.toString()),
                                      value: dia,
                                    );
                                  }).toList(),
                                  onChanged: plotType == "C" ?
                                      (val) {
                                    setState(() => tariffOrDia = val.toString());
                                  } :
                                      null,
                                  ),
                              // DropdownButtonFormField(
                              //   value: "Select Tariff or Dia",
                              //     items: plotType == "Domestic" ? _tariffList.map((tariff) {
                              //   return DropdownMenuItem(
                              //     child: Text(tariff),
                              //     value: tariff,
                              //   );
                              // }).toList()
                              //     :
                              //   _diaList.map((dia) {
                              //     return DropdownMenuItem(
                              //       child: Text(dia.toString()),
                              //       value: dia,
                              //     );
                              //   }).toList(),
                              //     decoration: const InputDecoration(
                              //       contentPadding: EdgeInsets.symmetric(vertical: 16),
                              //       hintText: "Tariff / Dia"
                              //     ),
                              //     onChanged: (val) {
                              //       setState(() => tariffOrDia = val.toString());
                              //     }),
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
                          /* UC list commented because it is not needed by Wasa currently, it will be
                              uncommented once they need it and have the relevant data  */
                              // DropdownButtonFormField(
                              //     decoration: const InputDecoration(
                              //       labelText: "UC",
                              //     ),
                              //     items: _ucNumList.map((ucNum) {
                              //       return DropdownMenuItem(
                              //         child: Text(ucNum),
                              //         value: ucNum,
                              //       );
                              //     }).toList(),
                              //     validator: (String? val) {
                              //       if (val == null || val.trim().isEmpty) {
                              //         return "Please select a UC";
                              //       } else {
                              //         return null;
                              //       }
                              //     },
                              //     onChanged: (val) {
                              //       setState(() => uc = val.toString());
                              //     }),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _zoneTextController,
                                      inputFormatters: [zoneFormatter],
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Zone',
                                        suffixText: '*',
                                        suffixStyle: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      onChanged: (val) => setState(() {
                                        zone = val;
                                      }),
                                      validator: (String? val) {
                                        if (val == null || val.trim().isEmpty) {
                                          return "Please select a Zone";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _wardTextController,
                                      inputFormatters: [wardFormatter],
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Ward',
                                        suffixText: '*',
                                        suffixStyle: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      onChanged: (val) => setState(() {
                                        ward = val;
                                      }),
                                      validator: (String? val) {
                                        if (val == null || val.trim().isEmpty) {
                                          return "Please Enter a Ward";
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
                        "Take Image",
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
                          }
                          else {
                            entryNum = await _db.countEntriesInZoneWard(zone, ward) + 1;
                            // plotType == "D" ? plotTypeLetter = "D" : plotTypeLetter = "C";
                            consumerID = zone + "-" + ward + "-" + entryNum.toString() + "-" + plotType;
                            address = "";
                            address += "House # " +
                                houseNum.toString() +
                                " " +
                                " block " +
                                block.toString() +
                                " " +
                                unitNum.toString() +
                                " " +
                                area.toString();

                            if (!isConnected) {
                              // If network detected is found to be false, then the consumer records are stored in SQLite db using the method below
                              DBProvider.db.insertConsumerEntryOffline(
                                  consumerId: consumerID,
                                plotType: plotType == "D"
                                    ? "Domestic"
                                    : "Commercial",
                                  name: name,
                                  number: number,
                                  email: email,
                                  cnic: nicNumber,
                                  tariffOrDia: tariffOrDia,
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
                                  landlineCompany: landlineNumber,
                                surveyorName: loggedInUserName,
                                surveyorEmail: loggedInUserEmail,
                                dateTime: json.encode(DateTime.now().toIso8601String()),
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
                                ConsumerFields.plotType: plotType == "D"
                                  ? "Domestic"
                                  : "Commercial",
                                ConsumerFields.id: consumerID,
                                ConsumerFields.name: name,
                                ConsumerFields.number: number,
                                ConsumerFields.cnicNum: nicNumber,
                                ConsumerFields.email: email,
                                ConsumerFields.tariffOrDia: tariffOrDia,
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
                                ConsumerFields.electricCompanyId: electricCompany,
                                ConsumerFields.landlineCompanyId: landlineNumber,
                                ConsumerFields.dateTime: json.encode(DateTime.now().toIso8601String()) ,
                              };
                              CoolAlert.show(context: context, type: CoolAlertType.loading);
                              await uploadFile();
                              Navigator.pop(context);
                              await ConsumerSheetsAPI.insert([consumer]);
                            }
                            // Along storing the data to sqlite, we also insert to Firebase, the data will be stored in firebase cache, and when network status changes, the offline data is synced with firebase
                            _db.addConsumerEntry(
                                plotType: plotType == "D"
                                    ? "Domestic"
                                    : "Commercial",
                              oldConsumerId: "",
                              consumerID: consumerID,
                              name: name,
                              number: number,
                              email: email,
                              tariffOrDia: tariffOrDia,
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
                            } else {
                              clearFormLocked();
                              _formKey.currentState!.reset();
                            }
                            _markers.clear();
                          }
                        }
                      },
                      child: Text(
                        "Save",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, color: kMaroon),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showAlertMoreDetails();
                      },
                      child: Text(
                        "More",
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
                        "Back",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kMaroon),
                      ),
                    ),
                    Text(
                      "Save",
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

  Future<void> _goToCurrentLocation() async {
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
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       vertical: 12.0),
                                  //   child: DropdownButtonFormField(
                                  //       decoration: const InputDecoration(
                                  //           labelText: "UC",
                                  //           border: OutlineInputBorder()),
                                  //       items: _ucNumList.map((ucNum) {
                                  //         return DropdownMenuItem(
                                  //           child: Text(ucNum),
                                  //           value: ucNum,
                                  //         );
                                  //       }).toList(),
                                  //       onChanged: (val) {
                                  //         Navigator.push(context,
                                  //             MaterialPageRoute(
                                  //                 builder: (context) {
                                  //                   return RetrieveMarkersBySearch(
                                  //                     name: "UC",
                                  //                     searchID: val.toString(),
                                  //                   );
                                  //                 }));
                                  //       }),
                                  // ),
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
                            ConsumerFields.gasCompanyId: element["Gas_Company_Id"],
                            ConsumerFields.electricCompanyId: element["Electricity_Company_Id"],
                            ConsumerFields.landlineCompanyId: element["Landline_Company_Id"],
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
                        onPressed: _goToCurrentLocation,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: const Color(0xffb11118),
                        child: const Icon(
                          Icons.my_location,
                          size: 36.0,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      FloatingActionButton(
                        heroTag: "btn2",
                        onPressed: () {
                          setState(() {
                            _markers.clear();
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: const Color(0xffb11118),
                        child: const Icon(
                          Icons.delete_forever,
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