// Completed code with options,date,clearing,and retrieving the code..

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'section_options.dart';
import 'station_options.dart';
import 'main.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyC3g5H5LGV0ehixQ6MeYv9Nec1NG884HBw',
      appId: '1:616869455453:android:700b310338c317d5064fb4',
      messagingSenderId: '616869455453',
      projectId: 'asset-app-3aa0a',
      databaseURL: 'YOUR_DATABASE_URL',
      storageBucket: 'asset-management-909aa.appspot.com',
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => PFNumberProvider(), // Provide your PFNumberProvider
      child: MaterialApp(
        home: DC_Track_Circuit_Details(),
      ),
    ),
  );
}

class TextFieldWithOptions extends StatefulWidget {
  final String labelText;
  final List<String> options;
  final void Function(String?) onChanged;
  final TextEditingController controller;
  final void Function(_TextFieldWithOptionsState?)?
      setTextFieldWithOptionsState;

  const TextFieldWithOptions({
    required this.labelText,
    required this.options,
    required this.onChanged,
    required this.controller,
    this.setTextFieldWithOptionsState,
  });

  @override
  _TextFieldWithOptionsState createState() => _TextFieldWithOptionsState();
}

class _TextFieldWithOptionsState extends State<TextFieldWithOptions> {
  String _selectedOption = '';

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.options.first;
    widget.setTextFieldWithOptionsState?.call(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: _selectedOption,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (String value) {
                setState(() {
                  _selectedOption = value;
                  widget.controller.text = value;
                });
                widget.onChanged(value);
              },
              itemBuilder: (BuildContext context) {
                return widget.options.map((String option) {
                  return PopupMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList();
              },
            ),
          ],
        ),
      ],
    );
  }

  void clearSelectedOption() {
    setState(() {
      _selectedOption = widget.options.first;
    });
  }
}

class DC_Track_Circuit_Details extends StatefulWidget {
  @override
  _DC_Track_Circuit_State createState() => _DC_Track_Circuit_State();
}

class _DC_Track_Circuit_State extends State<DC_Track_Circuit_Details> {
  final sectionController = TextEditingController();
  final stationController = TextEditingController();
  final slNoController = TextEditingController();
  final typeController = TextEditingController();
  final tracklengthController = TextEditingController();
  final btptstController = TextEditingController();
  final serialparallelController = TextEditingController();
  final locationnofeedendController = TextEditingController();
  final dateinstalledController = TextEditingController();
  final chainageController = TextEditingController();
  final trackchargercapcityController = TextEditingController();
  final resistanceavgController = TextEditingController();
  final chokecapacityController = TextEditingController();
  final fuseController = TextEditingController();
  final nobatteryusedController = TextEditingController();
  final batterymakeController = TextEditingController();
  final installeddateController = TextEditingController();
  final typeofleadController = TextEditingController();
  final typeofrelayController = TextEditingController();
  final dateofohController = TextEditingController();
  final nextduedateController = TextEditingController();
  final styletprController = TextEditingController();
  final locationnorelayendController = TextEditingController();
  final chaingeController = TextEditingController();
  final tprcontactsController = TextEditingController();
  final typeofjointstesteddateController = TextEditingController();
  final typeofbondsController = TextEditingController();
  final noofbondsController = TextEditingController();
  final paralleljumperController = TextEditingController();
  final tailcableController = TextEditingController();
  final ballastresistanceController = TextEditingController();
  final railresistanceController = TextEditingController();
  final availableController = TextEditingController();
  final anyremarksController = TextEditingController();
  final remarksController = TextEditingController();
  _TextFieldWithOptionsState? _textFieldWithOptionsState;
  bool isDataExist = false;

  @override
  Widget build(BuildContext context) {
    String? pfNumber = Provider.of<PFNumberProvider>(context).pfNumber;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Signal & Telecommunication (S&T) Department",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PF Number: ${pfNumber ?? "No PF Number"}', // Add your additional text here
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "DC Track Circuit Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  TextFieldWithOptions(
                    labelText: 'Select the Section',
                    options: Sections.getSections(),
                    onChanged: (String? newValue) {
                      setState(() {
                        sectionController.text = newValue ?? 'Select Option';
                        stationController.text = 'Select Option';
                      });
                      _textFieldWithOptionsState?.clearSelectedOption();
                    },
                    controller: sectionController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "STATION / AS / BS",
                    options: Stations.getStations(sectionController.text),
                    onChanged: (String? newValue) {
                      setState(() {
                        stationController.text = newValue ?? 'Select Option';
                      });
                    },
                    controller: stationController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: slNoController,
                    decoration: InputDecoration(
                      labelText: 'Track Circuit No',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      await checkIfSLNoExists(
                          slNoController.text, stationController.text);
                      if (isDataExist) {
                        await retrieveDataFromFirestore(slNoController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Data retrieved successfully.'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'No data found for the given Track Circuit No.'),
                          ),
                        );
                      }
                    },
                    child: Text('Check'),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Type of Track Circuit",
                    options: ['Select Option', 'DCTC'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          typeController.clear();
                        } else {
                          typeController.text = newValue!;
                        }
                      });
                    },
                    controller: typeController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: tracklengthController,
                    decoration: InputDecoration(
                      labelText: 'TRACK CIRCUIT LENGTH METRES',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText:
                        "POINT/STRAIGHT TRACK/ BERTHING TRACK [PT/ST/BT]",
                    options: ['Select Option', 'BT', 'PT', 'ST'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          btptstController.clear();
                        } else {
                          btptstController.text = newValue!;
                        }
                      });
                    },
                    controller: btptstController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText:
                        "WHETHER SERIES-PARALLEL DCTC/PARALLEL -PARALLEL DCTC",
                    options: [
                      'Select Option',
                      'SERIES-PARALLEL DCTC',
                      'PARALLEL -PARALLEL DCTC'
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          serialparallelController.clear();
                        } else {
                          serialparallelController.text = newValue!;
                        }
                      });
                    },
                    controller: serialparallelController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: locationnofeedendController,
                    decoration: InputDecoration(
                      labelText: 'LOCATION NO.(FEED END)',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: chainageController,
                    decoration: InputDecoration(
                      labelText: 'Chainage',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: trackchargercapcityController,
                    decoration: InputDecoration(
                      labelText: 'TRACK FEED CHARGER CAPACITY',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: dateinstalledController,
                    decoration: InputDecoration(
                      labelText: 'Date of Installed',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                    readOnly: true,
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        String formattedDate =
                            '${date.day}/${date.month}/${date.year}';
                        dateinstalledController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: resistanceavgController,
                    decoration: InputDecoration(
                      labelText: 'RESISTANCE AVERAGE VALUE IN THE YEAR',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "TYPE OF CHOKE/ CAPACITY",
                    options: ['Select Option', 'Choke', 'Capacity'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          chokecapacityController.clear();
                        } else {
                          chokecapacityController.text = newValue!;
                        }
                      });
                    },
                    controller: chokecapacityController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "TYPE OF FUSE ND/GF/PPTC",
                    options: ['Select Option', 'ND', 'GF', 'PPTC'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          fuseController.clear();
                        } else {
                          fuseController.text = newValue!;
                        }
                      });
                    },
                    controller: fuseController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: nobatteryusedController,
                    decoration: InputDecoration(
                      labelText: 'NO . BATTERIES USED IN TRACK CIRCUIT.',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: batterymakeController,
                    decoration: InputDecoration(
                      labelText: 'Battery Make/Capacity',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: installeddateController,
                    decoration: InputDecoration(
                      labelText: 'Date of Installation',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                    readOnly: true,
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        String formattedDate =
                            '${date.day}/${date.month}/${date.year}';
                        installeddateController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "TYPE OF LEAD WIRES",
                    options: ['Select Option', 'GI', 'F&F', 'ALU CABLE'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          typeofleadController.clear();
                        } else {
                          typeofleadController.text = newValue!;
                        }
                      });
                    },
                    controller: typeofleadController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "TYPE OF RELAY USED",
                    options: ['Select Option', 'QBAT', 'QTA2'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          typeofrelayController.clear();
                        } else {
                          typeofrelayController.text = newValue!;
                        }
                      });
                    },
                    controller: typeofrelayController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: dateofohController,
                    decoration: InputDecoration(
                      labelText: 'Date of OH',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                    readOnly: true,
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        String formattedDate =
                            '${date.day}/${date.month}/${date.year}';
                        dateofohController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: nextduedateController,
                    decoration: InputDecoration(
                      labelText: 'NEXT DUE DATE FOR OHD',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                    readOnly: true,
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        String formattedDate =
                            '${date.day}/${date.month}/${date.year}';
                        nextduedateController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: styletprController,
                    decoration: InputDecoration(
                      labelText: 'STYLE OF TPR USED',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: locationnorelayendController,
                    decoration: InputDecoration(
                      labelText: 'LOCATION NO.(Relay end )',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: chaingeController,
                    decoration: InputDecoration(
                      labelText: 'CHAINAGE',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: tprcontactsController,
                    decoration: InputDecoration(
                      labelText: 'WHETHER PARALLELING OF TPR CONTACTS DONE',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: typeofjointstesteddateController,
                    decoration: InputDecoration(
                      labelText: 'TYPE OF JOINTS LAST DATE OF TESTED - JI/MI/M',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                    readOnly: true,
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        String formattedDate =
                            '${date.day}/${date.month}/${date.year}';
                        nextduedateController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "TYPE OF BONDS",
                    options: ['Select Option', '', ''],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          typeofbondsController.clear();
                        } else {
                          typeofbondsController.text = newValue!;
                        }
                      });
                    },
                    controller: typeofbondsController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: noofbondsController,
                    decoration: InputDecoration(
                      labelText: 'NUMBER OF BONDS PER T. CKT.',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "PARALLAL JUMPERS/ POLARITY JUMBERS",
                    options: [
                      'Select Option',
                      'PARALLAL JUMPERS',
                      'POLARITY JUMBERS'
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          paralleljumperController.clear();
                        } else {
                          paralleljumperController.text = newValue!;
                        }
                      });
                    },
                    controller: paralleljumperController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: tailcableController,
                    decoration: InputDecoration(
                      labelText: 'TAIL CABLE MEGGERED ON',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                    readOnly: true,
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        String formattedDate =
                            '${date.day}/${date.month}/${date.year}';
                        tailcableController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: ballastresistanceController,
                    decoration: InputDecoration(
                      labelText: 'BALLAST RESISTANCE VALUE WET/ DRY',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: railresistanceController,
                    decoration: InputDecoration(
                      labelText: 'RAIL RESISTANCE VALUE WET/ DRY',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText:
                        "PARALLEL JUMPERS/ POLARITY JUMBERS AVAILABLE/NOT AVAILABLE",
                    options: ['Select Option', 'AVAILABLE', 'NOT AVAILABLE'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          availableController.clear();
                        } else {
                          availableController.text = newValue!;
                        }
                      });
                    },
                    controller: availableController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: anyremarksController,
                    decoration: InputDecoration(
                      labelText:
                          'ANY REMARKS AGAINST P.WAY DEPT.LIKE WATTER LOGGING , BR,DAMAGED SLEEPERS GJ VOLT, DROP. RUBBER PAD .LINEARS',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: remarksController,
                    decoration: InputDecoration(
                      labelText: 'REMARKS',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: isDataExist
                        ? updateDataInFirestore
                        : saveDataToFirestore,
                    child: Text(isDataExist ? 'Update' : 'Submit'),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveDataToFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('DC Track Circuit Details')
          .add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Track Circuit No': slNoController.text,
        'TYPE OF TRACK CIRCUIT': typeofrelayController.text,
        'TRACK CIRCUIT LENGTH METERS': tracklengthController.text,
        'POINT/STRAIGHT TRACK/ BERTHING TRACK[PT/ST/BT]': btptstController.text,
        'WHETHER SERIES-PARALLEL DCTC/PARALLEL -PARALLEL DCTC':
            serialparallelController.text,
        'CHAINAGE': chainageController.text,
        'TRACK FEED CHARGER CAPACITY': trackchargercapcityController.text,
        'DATE OF INSTALLED': dateinstalledController.text,
        'RESISTANCE AVERAGE VALUE IN THE YEAR': resistanceavgController.text,
        'TYPE OF CHOKE/ CAPACITY': chokecapacityController.text,
        'TYPE OF FUSE ND/GF/PPTC': fuseController.text,
        'NO . BATTERIES USED IN TRACK CIRCUIT.': nobatteryusedController.text,
        'Battery Make/Capacity': batterymakeController.text,
        'Date of Installation': installeddateController.text,
        'TYPE OF LEAD WIRES': typeofleadController.text,
        'TYPE OF RELAY USED': typeofrelayController.text,
        'Date of OH': dateofohController.text,
        'NEXT DUE DATE FOR OHD': nextduedateController.text,
        'STYLE OF TPR USED': styletprController.text,
        'LOCATION NO.(Relay end )': locationnorelayendController.text,
        'CHAINAGE ': chaingeController.text,
        'WHETHER PARALLELING OF TPR CONTACTS DONE': tprcontactsController.text,
        'TYPE OF JOINTS LAST DATE OF TESTED - JI/MI/M':
            typeofjointstesteddateController.text,
        'TYPE OF BONDS': typeofbondsController.text,
        'NUMBER OF BONDS PER T. CKT.': noofbondsController.text,
        'PARALLAL JUMPERS/ POLARITY JUMBERS': paralleljumperController.text,
        'TAIL CABLE MEGGERED ON': tailcableController.text,
        'BALLAST RESISTANCE VALUE WET/ DRY': ballastresistanceController.text,
        'RAIL RESISTANCE VALUE WET/ DRY': railresistanceController.text,
        'PARALLEL JUMPERS/ POLARITY JUMBERS AVAILABLE/NOT AVAILABLE':
            availableController.text,
        'ANY REMARKS AGAINST P.WAY DEPT.LIKE WATTER LOGGING , BR,DAMAGED SLEEPERS GJ VOLT, DROP. RUBBER PAD .LINEARS':
            anyremarksController.text,
        'REMARKS': remarksController.text,
        'createdAt': FieldValue.serverTimestamp(), // Add createdAt field
        'updatedAt': FieldValue.serverTimestamp(),
      });

      clearTextFields();
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  Future<void> updateDataInFirestore() async {
    try {
      // Reference the collection
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('DC Track Circuit Details');

      // Add a new document with auto-generated ID
      DocumentReference newDocRef = await collectionRef.add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Track Circuit No': slNoController.text,
        'TYPE OF TRACK CIRCUIT': typeofrelayController.text,
        'TRACK CIRCUIT LENGTH METERS': tracklengthController.text,
        'POINT/STRAIGHT TRACK/ BERTHING TRACK[PT/ST/BT]': btptstController.text,
        'WHETHER SERIES-PARALLEL DCTC/PARALLEL -PARALLEL DCTC':
            serialparallelController.text,
        'CHAINAGE': chainageController.text,
        'TRACK FEED CHARGER CAPACITY': trackchargercapcityController.text,
        'DATE OF INSTALLED': dateinstalledController.text,
        'RESISTANCE AVERAGE VALUE IN THE YEAR': resistanceavgController.text,
        'TYPE OF CHOKE/ CAPACITY': chokecapacityController.text,
        'TYPE OF FUSE ND/GF/PPTC': fuseController.text,
        'NO . BATTERIES USED IN TRACK CIRCUIT.': nobatteryusedController.text,
        'Battery Make/Capacity': batterymakeController.text,
        'Date of Installation': installeddateController.text,
        'TYPE OF LEAD WIRES': typeofleadController.text,
        'TYPE OF RELAY USED': typeofrelayController.text,
        'Date of OH': dateofohController.text,
        'NEXT DUE DATE FOR OHD': nextduedateController.text,
        'STYLE OF TPR USED': styletprController.text,
        'LOCATION NO.(Relay end )': locationnorelayendController.text,
        'CHAINAGE ': chaingeController.text,
        'WHETHER PARALLELING OF TPR CONTACTS DONE': tprcontactsController.text,
        'TYPE OF JOINTS LAST DATE OF TESTED - JI/MI/M':
            typeofjointstesteddateController.text,
        'TYPE OF BONDS': typeofbondsController.text,
        'NUMBER OF BONDS PER T. CKT.': noofbondsController.text,
        'PARALLAL JUMPERS/ POLARITY JUMBERS': paralleljumperController.text,
        'TAIL CABLE MEGGERED ON': tailcableController.text,
        'BALLAST RESISTANCE VALUE WET/ DRY': ballastresistanceController.text,
        'RAIL RESISTANCE VALUE WET/ DRY': railresistanceController.text,
        'PARALLEL JUMPERS/ POLARITY JUMBERS AVAILABLE/NOT AVAILABLE':
            availableController.text,
        'ANY REMARKS AGAINST P.WAY DEPT.LIKE WATTER LOGGING , BR,DAMAGED SLEEPERS GJ VOLT, DROP. RUBBER PAD .LINEARS':
            anyremarksController.text,
        'REMARKS': remarksController.text,
        'createdAt': FieldValue.serverTimestamp(), // Add createdAt field
        'updatedAt': FieldValue.serverTimestamp(), // Add updatedAt field
      });

      // Clear existing text fields
      clearTextFields();

      // Fetch all documents with the same SL NO
      QuerySnapshot querySnapshot = await collectionRef
          .where('SL NO', isEqualTo: slNoController.text)
          .get();

      // Process each document in the query snapshot
      querySnapshot.docs.forEach((doc) {
        // Retrieve data from the newly added document
        if (doc.reference == newDocRef) {
          var data = doc.data() as Map<String, dynamic>;
          // Update your UI here with the retrieved data
          setState(() {
            sectionController.text = data['section'] ?? '';
            stationController.text = data['station'] ?? '';
            slNoController.text = data['Track Circuit No'] ?? '';
            typeController.text = data['TYPE OF TRACK CIRCUIT'] ?? '';
            tracklengthController.text =
                data['TRACK CIRCUIT LENGTH METERS'] ?? '';
            btptstController.text =
                data['POINT/STRAIGHT TRACK/ BERTHING TRACK[PT/ST/BT]'] ?? '';
            serialparallelController.text =
                data['WHETHER SERIES-PARALLEL DCTC/PARALLEL -PARALLEL DCTC'] ??
                    '';
            locationnofeedendController.text =
                data['LOCATION NO.(FEED END)'] ?? '';
            chainageController.text = data['CHAINAGE'] ?? '';
            trackchargercapcityController.text =
                data['TRACK FEED CHARGER CAPACITY'] ?? '';
            dateinstalledController.text = data['DATE OF INSTALLED'] ?? '';
            resistanceavgController.text =
                data['RESISTANCE AVERAGE VALUE IN THE YEAR'] ?? '';
            chokecapacityController.text =
                data['TYPE OF CHOKE/ CAPACITY'] ?? '';
            nobatteryusedController.text =
                data['NO . BATTERIES USED IN TRACK CIRCUIT.'] ?? '';
            batterymakeController.text = data['Battery Make/Capacity'] ?? '';
            installeddateController.text = data['Date of Installation'] ?? '';
            typeofleadController.text = data['TYPE OF LEAD WIRES'] ?? '';
            typeofrelayController.text = data['TYPE OF RELAY USED'] ?? '';
            dateofohController.text = data['Date of OH'] ?? '';
            nextduedateController.text = data['NEXT DUE DATE FOR OHD'] ?? '';
            styletprController.text = data['STYLE OF TPR USED'] ?? '';
            locationnorelayendController.text =
                data['LOCATION NO.(Relay end )'] ?? '';
            chaingeController.text = data['CHAINAGE '] ?? '';
            tprcontactsController.text =
                data['WHETHER PARALLELING OF TPR CONTACTS DONE'] ?? '';
            typeofjointstesteddateController.text =
                data['TYPE OF JOINTS LAST DATE OF TESTED - JI/MI/M'] ?? '';
            typeofbondsController.text = data['TYPE OF BONDS'] ?? '';
            noofbondsController.text =
                data['NUMBER OF BONDS PER T. CKT.'] ?? '';
            paralleljumperController.text =
                data['PARALLAL JUMPERS/ POLARITY JUMBERS'] ?? '';
            tailcableController.text = data['TAIL CABLE MEGGERED ON'] ?? '';
            ballastresistanceController.text =
                data['BALLAST RESISTANCE VALUE WET/ DRY'] ?? '';
            railresistanceController.text =
                data['RAIL RESISTANCE VALUE WET/ DRY'] ?? '';
            availableController.text = data[
                    'PARALLEL JUMPERS/ POLARITY JUMBERS AVAILABLE/NOT AVAILABLE'] ??
                '';
            anyremarksController.text = data[
                    'ANY REMARKS AGAINST P.WAY DEPT.LIKE WATTER LOGGING , BR,DAMAGED SLEEPERS GJ VOLT, DROP. RUBBER PAD .LINEARS'] ??
                '';
            remarksController.text = data['REMARKS'] ?? '';
          });
        }
      });
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  Future<void> deleteDataInFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('DC Track Circuit Details')
          .where('Track Circuit No', isEqualTo: slNoController.text)
          .get();
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });

      clearTextFields();
    } catch (e) {
      print('Error deleting data: $e');
    }
  }

  Future<void> checkIfSLNoExists(String slNo, String station) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('DC Track Circuit Details')
          .where('station', isEqualTo: station)
          .where('Track Circuit No', isEqualTo: slNo)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          isDataExist = true;
        });
      } else {
        setState(() {
          isDataExist = false;
        });
      }
    } catch (e) {
      print('Error checking SL.No existence: $e');
    }
  }

  Future<void> retrieveDataFromFirestore(String slNo) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('DC Track Circuit Details')
          .where('Track Circuit No', isEqualTo: slNo)
          .orderBy('updatedAt', descending: true) // Order by updatedAt field
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          sectionController.text = data['section'] ?? '';
          stationController.text = data['station'] ?? '';
          slNoController.text = data['Track Circuit No'] ?? '';
          typeController.text = data['TYPE OF TRACK CIRCUIT'] ?? '';
          tracklengthController.text =
              data['TRACK CIRCUIT LENGTH METERS'] ?? '';
          btptstController.text =
              data['POINT/STRAIGHT TRACK/ BERTHING TRACK[PT/ST/BT]'] ?? '';
          serialparallelController.text =
              data['WHETHER SERIES-PARALLEL DCTC/PARALLEL -PARALLEL DCTC'] ??
                  '';
          locationnofeedendController.text =
              data['LOCATION NO.(FEED END)'] ?? '';
          chainageController.text = data['CHAINAGE'] ?? '';
          trackchargercapcityController.text =
              data['TRACK FEED CHARGER CAPACITY'] ?? '';
          dateinstalledController.text = data['DATE OF INSTALLED'] ?? '';
          resistanceavgController.text =
              data['RESISTANCE AVERAGE VALUE IN THE YEAR'] ?? '';
          chokecapacityController.text = data['TYPE OF CHOKE/ CAPACITY'] ?? '';
          nobatteryusedController.text =
              data['NO . BATTERIES USED IN TRACK CIRCUIT.'] ?? '';
          batterymakeController.text = data['Battery Make/Capacity'] ?? '';
          installeddateController.text = data['Date of Installation'] ?? '';
          typeofleadController.text = data['TYPE OF LEAD WIRES'] ?? '';
          typeofrelayController.text = data['TYPE OF RELAY USED'] ?? '';
          dateofohController.text = data['Date of OH'] ?? '';
          nextduedateController.text = data['NEXT DUE DATE FOR OHD'] ?? '';
          styletprController.text = data['STYLE OF TPR USED'] ?? '';
          locationnorelayendController.text =
              data['LOCATION NO.(Relay end )'] ?? '';
          chaingeController.text = data['CHAINAGE '] ?? '';
          tprcontactsController.text =
              data['WHETHER PARALLELING OF TPR CONTACTS DONE'] ?? '';
          typeofjointstesteddateController.text =
              data['TYPE OF JOINTS LAST DATE OF TESTED - JI/MI/M'] ?? '';
          typeofbondsController.text = data['TYPE OF BONDS'] ?? '';
          noofbondsController.text = data['NUMBER OF BONDS PER T. CKT.'] ?? '';
          paralleljumperController.text =
              data['PARALLAL JUMPERS/ POLARITY JUMBERS'] ?? '';
          tailcableController.text = data['TAIL CABLE MEGGERED ON'] ?? '';
          ballastresistanceController.text =
              data['BALLAST RESISTANCE VALUE WET/ DRY'] ?? '';
          railresistanceController.text =
              data['RAIL RESISTANCE VALUE WET/ DRY'] ?? '';
          availableController.text = data[
                  'PARALLEL JUMPERS/ POLARITY JUMBERS AVAILABLE/NOT AVAILABLE'] ??
              '';
          anyremarksController.text = data[
                  'ANY REMARKS AGAINST P.WAY DEPT.LIKE WATTER LOGGING , BR,DAMAGED SLEEPERS GJ VOLT, DROP. RUBBER PAD .LINEARS'] ??
              '';
          remarksController.text = data['REMARKS'] ?? '';
        });
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  void clearTextFields() {
    sectionController.clear();
    stationController.clear();
    slNoController.clear();
    typeController.clear();
    tracklengthController.clear();
    btptstController.clear();
    serialparallelController.clear();
    locationnofeedendController.clear();
    dateinstalledController.clear();
    chainageController.clear();
    trackchargercapcityController.clear();
    resistanceavgController.clear();
    chokecapacityController.clear();
    fuseController.clear();
    nobatteryusedController.clear();
    batterymakeController.clear();
    installeddateController.clear();
    typeofleadController.clear();
    typeofrelayController.clear();
    dateofohController.clear();
    nextduedateController.clear();
    styletprController.clear();
    locationnorelayendController.clear();
    chaingeController.clear();
    tprcontactsController.clear();
    typeofjointstesteddateController.clear();
    typeofbondsController.clear();
    noofbondsController.clear();
    paralleljumperController.clear();
    tailcableController.clear();
    ballastresistanceController.clear();
    railresistanceController.clear();
    availableController.clear();
    anyremarksController.clear();
    remarksController.clear();

    setState(() {
      isDataExist = false;
    });

    _textFieldWithOptionsState?.clearSelectedOption();
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;

  CustomCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
