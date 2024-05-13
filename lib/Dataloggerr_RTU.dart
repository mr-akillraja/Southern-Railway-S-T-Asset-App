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
        home: DataLogger_RTU(),
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

class DataLogger_RTU extends StatefulWidget {
  @override
  _BlockInstrumentState createState() => _BlockInstrumentState();
}

class _BlockInstrumentState extends State<DataLogger_RTU> {
  final sectionController = TextEditingController();
  final stationController = TextEditingController();
  final doublecontroller = TextEditingController();
  final dlcontroller = TextEditingController();
  final installationController = TextEditingController();
  final validationController = TextEditingController();
  final amcwarrantyController = TextEditingController();
  final datefromController = TextEditingController();
  final datetoController = TextEditingController();
  final loaController = TextEditingController();
  final providedController = TextEditingController();

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
                    "DataLogger_RTU Details",
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
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      await checkIfStationExists(stationController.text);
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
                                Text('No data found for the given Station'),
                          ),
                        );
                      }
                    },
                    child: Text('Check'),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: doublecontroller,
                    decoration: InputDecoration(
                      labelText: 'Double Locking Monitoring',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: dlcontroller,
                    decoration: InputDecoration(
                      labelText: 'DL Capacity',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: installationController,
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
                        installationController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: validationController,
                    decoration: InputDecoration(
                      labelText: 'Validation',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "AMC/Warranty",
                    options: ['Select Option', 'AMC', 'Warranty'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          amcwarrantyController.clear();
                        } else {
                          amcwarrantyController.text = newValue!;
                        }
                      });
                    },
                    controller: amcwarrantyController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: datefromController,
                    decoration: InputDecoration(
                      labelText: 'From',
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
                        datefromController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: datetoController,
                    decoration: InputDecoration(
                      labelText: 'To',
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
                        datetoController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: loaController,
                    decoration: InputDecoration(
                      labelText: 'LOA',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFieldWithOptions(
                    labelText: "Provided By",
                    options: [
                      'Select Option',
                      'Construction',
                      'Project',
                      'Division'
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          providedController.clear();
                        } else {
                          providedController.text = newValue!;
                        }
                      });
                    },
                    controller: providedController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (isDataExist) {
                        updateDataInFirestore();
                      } else {
                        saveDataToFirestore();
                      }
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
          .collection('DataLogger_RTU_Details')
          .add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Double Locking Monitoring': doublecontroller.text,
        'DL Capacity': dlcontroller.text,
        'Date of Installation': installationController.text,
        'Validation': validationController.text,
        'AMC/Warranty': amcwarrantyController.text,
        'From': datefromController.text,
        'To': datetoController.text,
        'LOA': loaController.text,
        'Provided By': providedController.text,
        'createdAt': FieldValue.serverTimestamp(),
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
          FirebaseFirestore.instance.collection('DataLogger_RTU_Details');

      // Add a new document with auto-generated ID
      DocumentReference newDocRef = await collectionRef.add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Double Locking Monitoring': doublecontroller.text,
        'DL Capacity': dlcontroller.text,
        'Date of Installation': installationController.text,
        'Validation': validationController.text,
        'AMC/Warranty': amcwarrantyController.text,
        'From': datefromController.text,
        'To': datetoController.text,
        'LOA': loaController.text,
        'Provided By': providedController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Clear existing text fields
      clearTextFields();

      // Fetch all documents with the same station
      QuerySnapshot querySnapshot = await collectionRef
          .where('station', isEqualTo: stationController.text)
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
            doublecontroller.text = data['Double Locking Monitoring'] ?? '';
            dlcontroller.text = data['DL Capacity'] ?? '';
            validationController.text = data['validation'] ?? '';
            installationController.text = data['Date of Installation'] ?? '';
            amcwarrantyController.text = data['AMC/Warranty'] ?? '';
            datefromController.text = data['From'] ?? '';
            datetoController.text = data['To'] ?? '';
            providedController.text = data['Provided By'] ?? '';
            loaController.text = data['LOA'] ?? '';
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
          .collection('DataLogger_RTU_Details')
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

  Future<void> checkIfStationExists(String station) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('DataLogger_RTU_Details')
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
      print('Error checking station existence: $e');
    }
  }

  Future<void> retrieveDataFromFirestore(String station) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('DataLogger_RTU_Details')
          .where('station', isEqualTo: station)
          .orderBy('updatedAt', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          sectionController.text = data['section'] ?? '';
          stationController.text = data['station'] ?? '';
          doublecontroller.text = data['Double Locking Monitoring'] ?? '';
          dlcontroller.text = data['DL Capacity'] ?? '';
          validationController.text = data['validation'] ?? '';
          installationController.text = data['Date of Installation'] ?? '';
          amcwarrantyController.text = data['AMC/Warranty'] ?? '';
          datefromController.text = data['From'] ?? '';
          datetoController.text = data['To'] ?? '';
          providedController.text = data['Provided By'] ?? '';
          loaController.text = data['LOA'] ?? '';
        });
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  void clearTextFields() {
    sectionController.clear();
    stationController.clear();
    doublecontroller.clear();
    dlcontroller.clear();
    installationController.clear();
    validationController.clear();
    amcwarrantyController.clear();
    datefromController.clear();
    datetoController.clear();
    loaController.clear();
    providedController.clear();

    setState(() {
      isDataExist = false;
    });

    _textFieldWithOptionsState?.clearSelectedOption();
  }
}
