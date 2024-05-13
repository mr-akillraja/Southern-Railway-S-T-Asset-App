// Completed code with options,date,clearing,and retrieving the code..
// Retrieved data successfully..

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
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
        home: FireAlarm(),
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

class FireAlarm extends StatefulWidget {
  @override
  _FireAlarmState createState() => _FireAlarmState();
}

class _FireAlarmState extends State<FireAlarm> {
  final sectionController = TextEditingController();
  final stationController = TextEditingController();
  final firealarmslnoController = TextEditingController();
  final selectedMake = TextEditingController();
  final selectedType = TextEditingController();
  final selectedRDSO = TextEditingController();
  final InstalledDate = TextEditingController();
  final selectedStatus = TextEditingController();
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
                    "Fire Alarm Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  TextFieldWithOptions(
                    labelText: 'Select the Section',
                    options: Sections
                        .getSections(), // Use Section class to get sections
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
                    options: Stations.getStations(sectionController
                        .text), // Use Stations class to get stations
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
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      await checkIfSLNoExists(stationController.text);
                      if (isDataExist) {
                        await retrieveDataFromFirestore(stationController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Data retrieved successfully.'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('No data found for the given Serial No.'),
                          ),
                        );
                      }
                    },
                    child: Text('Check'),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: firealarmslnoController,
                    decoration: InputDecoration(
                      labelText: 'Fire_Alarm_Sl_No',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: selectedMake,
                    decoration: InputDecoration(
                      labelText: 'Make',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Type",
                    options: [
                      'Select Option',
                      'Addressable Fire Alarm System',
                      'Semi-Addressable Fire Alarm system',
                      'AUTO HUTS',
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          selectedType.clear();
                        } else {
                          selectedType.text = newValue!;
                        }
                      });
                    },
                    controller: selectedType,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "RDSO/NON RDSO",
                    options: ['Select Option', 'RDSO', 'NON RDSO'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          selectedRDSO.clear();
                        } else {
                          selectedRDSO.text = newValue!;
                        }
                      });
                    },
                    controller: selectedRDSO,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: InstalledDate,
                    decoration: InputDecoration(
                      labelText: 'Date Of Installation',
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
                        setState(() {
                          InstalledDate.text = formattedDate;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Fire Alarm Status",
                    options: [
                      'Select Option',
                      'Working',
                      'Not Working',
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          selectedStatus.clear();
                        } else {
                          selectedStatus.text = newValue!;
                        }
                      });
                    },
                    controller: selectedStatus,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: remarksController,
                    decoration: InputDecoration(
                      labelText: 'REMRAKS',
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
      await FirebaseFirestore.instance.collection('Fire_Alarm_Details').add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Remarks': remarksController.text,
        'Fire_Alarm_Sl_No': firealarmslnoController.text,
        'Make': selectedMake.text,
        'Type': selectedType.text,
        'RDSO/NON RDSO': selectedRDSO.text,
        'Date of Installation': InstalledDate.text,
        'Status': selectedStatus.text,
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
          FirebaseFirestore.instance.collection('Fire_Alarm_Details');

      // Add a new document with auto-generated ID
      DocumentReference newDocRef = await collectionRef.add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Remarks': remarksController.text,
        'Fire_Alarm_Sl_No': firealarmslnoController.text,
        'Make': selectedMake.text,
        'Type': selectedType.text,
        'RDSO/NON RDSO': selectedRDSO.text,
        'Date of Installation': InstalledDate.text,
        'Status': selectedStatus.text,
        'createdAt': FieldValue.serverTimestamp(), // Add createdAt field
        'updatedAt': FieldValue.serverTimestamp(), // Add updatedAt field
      });

      // Clear existing text fields
      clearTextFields();

      // Fetch all documents with the same SL NO
      QuerySnapshot querySnapshot = await collectionRef
          .where('Fire_Alarm_Sl_No', isEqualTo: firealarmslnoController.text)
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
            remarksController.text = data['Remarks'] ?? '';
            firealarmslnoController.text = data['Fire_Alarm_Sl_No'] ?? '';
            selectedMake.text = data['Make'] ?? '';
            selectedType.text = data['Type'] ?? '';
            selectedRDSO.text = data['RDSO/NON RDSO'] ?? '';
            InstalledDate.text = data['Date of Installation'] ?? '';
            selectedStatus.text = data['Status'] ?? '';
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
          .collection('Fire_Alarm_Details')
          .where('station', isEqualTo: stationController.text)
          .get();
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });

      clearTextFields();
    } catch (e) {
      print('Error deleting data: $e');
    }
  }

  Future<void> checkIfSLNoExists(String station) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Fire_Alarm_Details')
          .where('station', isEqualTo: station)
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

  Future<void> retrieveDataFromFirestore(String station) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Fire_Alarm_Details')
          .where('station', isEqualTo: station)
          .orderBy('updatedAt', descending: true) // Order by updatedAt field
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          sectionController.text = data['section'] ?? '';
          stationController.text = data['station'] ?? '';
          remarksController.text = data['Remarks'] ?? '';
          firealarmslnoController.text = data['Fire_Alarm_Sl_No'] ?? '';
          selectedMake.text = data['Make'] ?? '';
          selectedType.text = data['Type'] ?? '';
          selectedRDSO.text = data['RDSO/NON RDSO'] ?? '';
          InstalledDate.text = data['Date of Installation'] ?? '';
          selectedStatus.text = data['Status'] ?? '';
        });
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  void clearTextFields() {
    sectionController.clear();
    stationController.clear();
    firealarmslnoController.clear();
    selectedMake.clear();
    selectedRDSO.clear();
    InstalledDate.clear();
    remarksController.clear();
    selectedType.clear();
    selectedStatus.clear();
    setState(() {
      isDataExist = false;
    });

    _textFieldWithOptionsState?.clearSelectedOption();
  }
}
