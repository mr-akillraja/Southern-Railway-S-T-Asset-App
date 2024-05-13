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
        home: LevelCrossing_Gates(),
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

class LevelCrossing_Gates extends StatefulWidget {
  @override
  _BlockInstrumentState createState() => _BlockInstrumentState();
}

class _BlockInstrumentState extends State<LevelCrossing_Gates> {
  final sectionController = TextEditingController();
  final stationController = TextEditingController();
  final routeController = TextEditingController();
  final lcController = TextEditingController();
  final kmController = TextEditingController();
  final typeController = TextEditingController();
  final classController = TextEditingController();
  final typestationController = TextEditingController();
  final rtuController = TextEditingController();
  final operatedController = TextEditingController();
  final avalabilityController = TextEditingController();
  final atController = TextEditingController();
  final rangeController = TextEditingController();
  final backupController = TextEditingController();
  final ipsupsController = TextEditingController();
  final circuitController = TextEditingController();
  final selectRange = TextEditingController();
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
                    "LevelCrossing Gates Details",
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
                    controller: lcController,
                    decoration: InputDecoration(
                      labelText: 'LC No',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      await checkIfSLNoExists(
                          lcController.text, stationController.text);
                      if (isDataExist) {
                        await retrieveDataFromFirestore(lcController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Data retrieved successfully.'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No data found for the given LC No.'),
                          ),
                        );
                      }
                    },
                    child: Text('Check'),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: kmController,
                    decoration: InputDecoration(
                      labelText: 'KM',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Type",
                    options: ['Select Option', 'ELB', 'MLB'],
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
                  TextFieldWithOptions(
                    labelText: "Class",
                    options: [
                      'Select Option',
                      'Engineering Gate (E)',
                      'Traffic Gate (E)'
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          classController.clear();
                        } else {
                          classController.text = newValue!;
                        }
                      });
                    },
                    controller: classController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Type Of Section",
                    options: [
                      'Select Option',
                      'Auto Section',
                      'Block Section',
                      'IBS Section'
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          typestationController.clear();
                        } else {
                          typestationController.text = newValue!;
                        }
                      });
                    },
                    controller: typestationController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: rtuController,
                    decoration: InputDecoration(
                      labelText: 'RTU',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Operated By",
                    options: ['Select Option', 'Panel', 'Lever', 'SM Slide'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          operatedController.clear();
                        } else {
                          operatedController.text = newValue!;
                        }
                      });
                    },
                    controller: operatedController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Availability of AT",
                    options: ['Select Option', 'Yes', 'No', 'Not Available'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          avalabilityController.clear();
                        } else {
                          avalabilityController.text = newValue!;
                        }
                      });
                    },
                    controller: avalabilityController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "AT Capacity/Load",
                    options: ['Select Option', 'Available', 'Not Available'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          atController.clear();
                        } else {
                          atController.text = newValue!;
                        }
                      });
                    },
                    controller: atController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  if (atController.text == 'Available') ...[
                    SizedBox(height: 10.0),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Enter the range',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(209, 0, 0, 0))),
                      onChanged: (value) {
                        setState(() {
                          rangeController.text = value;
                        });
                      },
                      controller: rangeController,
                    ),
                  ],
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Backup",
                    options: ['Select Option', 'Yes', 'NIL'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          avalabilityController.clear();
                        } else {
                          backupController.text = newValue!;
                        }
                      });
                    },
                    controller: backupController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "IPS/UPS/INVERTER",
                    options: ['Select Option', 'IPS', 'UPS', 'INVERTER'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          avalabilityController.clear();
                        } else {
                          ipsupsController.text = newValue!;
                        }
                      });
                    },
                    controller: ipsupsController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: circuitController,
                    decoration: InputDecoration(
                      labelText: 'Circuit Modification Box Status',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Conditionally call either updateDataInFirestore or saveDataToFirestore
                      if (isDataExist) {
                        updateDataInFirestore();
                      } else {
                        saveDataToFirestore();
                      }
                      // Display a snackbar after the button is pressed
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              isDataExist ? 'Data Updated' : 'Data Submitted'),
                        ),
                      );
                    },
                    child: Text(isDataExist ? 'Update' : 'Submit'),
                  ),
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
          .collection('LevelCrossing_Gate_Details')
          .add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'LC No': lcController.text,
        'KM': kmController.text,
        'Type': typeController.text,
        'Class': classController.text,
        'Type Of Section': typestationController.text,
        'RTU': rtuController.text,
        'Operated By': operatedController.text,
        'Availability of AT': avalabilityController.text,
        'AT Capacity/Load': atController.text,
        'Enter the Range': rangeController.text,
        'Backup': backupController.text,
        'IPS/UPS/INVERTER': ipsupsController.text,
        'Circuit Modification Box Status': circuitController.text,
        'createdAt': FieldValue.serverTimestamp(), // Add createdAt field
        'updatedAt': FieldValue.serverTimestamp(), // Add updatedAt field
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
          FirebaseFirestore.instance.collection('LevelCrossing_Gate_Details');

      // Add a new document with auto-generated ID
      DocumentReference newDocRef = await collectionRef.add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'LC No': lcController.text,
        'KM': kmController.text,
        'Type': typeController.text,
        'Class': classController.text,
        'Type Of Section': typestationController.text,
        'RTU': rtuController.text,
        'Operated By': operatedController.text,
        'Availability of AT': avalabilityController.text,
        'AT Capacity/Load': atController.text,
        'Enter the Range': rangeController.text,
        'Backup': backupController.text,
        'IPS/UPS/INVERTER': ipsupsController.text,
        'Circuit Modification Box Status': circuitController.text,
        'createdAt': FieldValue.serverTimestamp(), // Add createdAt field
        'updatedAt': FieldValue.serverTimestamp(), // Add updatedAt field
      });

      // Clear existing text fields
      clearTextFields();

      // Fetch all documents with the same SL NO
      QuerySnapshot querySnapshot = await collectionRef
          .where('LC No', isEqualTo: lcController.text)
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
            lcController.text = data['LC No'] ?? '';
            kmController.text = data['KM'] ?? '';
            typeController.text = data['Type'] ?? '';
            classController.text = data['Class'] ?? '';
            typestationController.text = data['Type Of Section'] ?? '';
            rtuController.text = data['RTU'] ?? '';
            operatedController.text = data['Operated By'] ?? '';
            avalabilityController.text = data['Availability of AT'] ?? '';
            atController.text = data['AT Capacity/Load'] ?? '';
            rangeController.text = data['Enter the Range'] ?? '';
            backupController.text = data['Backup'] ?? '';
            ipsupsController.text = data['IPS/UPS/INVERTER'] ?? '';
            circuitController.text =
                data['Circuit Modification Box Status'] ?? '';
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
          .collection('LevelCrossing_Gate_Details')
          .where('LC No', isEqualTo: lcController.text)
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
          .collection('LevelCrossing_Gate_Details')
          .where('station', isEqualTo: station)
          .where('LC No', isEqualTo: slNo)
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
      print('Error checking Version existence: $e');
    }
  }

  Future<void> retrieveDataFromFirestore(String slNo) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('LevelCrossing_Gate_Details')
          .where('LC No', isEqualTo: slNo)
          .orderBy('updatedAt', descending: true) // Order by updatedAt field
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;

        // Check if the required fields exist in the retrieved data
        setState(() {
          sectionController.text = data['section'] ?? '';
          stationController.text = data['station'] ?? '';
          lcController.text = data['LC No'] ?? '';
          kmController.text = data['KM'] ?? '';
          typeController.text = data['Type'] ?? '';
          classController.text = data['Class'] ?? '';
          typestationController.text = data['Type Of Section'] ?? '';
          rtuController.text = data['RTU'] ?? '';
          operatedController.text = data['Operated By'] ?? '';
          avalabilityController.text = data['Availability of AT'] ?? '';
          atController.text = data['AT Capacity/Load'] ?? '';
          rangeController.text = data['Enter the Range'] ?? '';
          backupController.text = data['Backup'] ?? '';
          ipsupsController.text = data['IPS/UPS/INVERTER'] ?? '';
          circuitController.text =
              data['Circuit Modification Box Status'] ?? '';
        });
      } else {
        // Clear existing text fields only if no data is retrieved
        clearTextFields();
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  void clearTextFields() {
    // Clear all text fields
    sectionController.clear();
    stationController.clear();
    lcController.clear();
    kmController.clear();
    typeController.clear();
    classController.clear();
    typestationController.clear();
    rtuController.clear();
    operatedController.clear();
    avalabilityController.clear();
    atController.clear();
    rangeController.clear();
    backupController.clear();
    ipsupsController.clear();
    circuitController.clear();
    selectRange.clear();

    // Reset the selected option in TextFieldWithOptions
    _textFieldWithOptionsState?.clearSelectedOption();

    setState(() {
      isDataExist = false;
    });
  }
}
