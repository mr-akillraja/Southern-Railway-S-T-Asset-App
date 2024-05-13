// Completed code with options,date,clearing,and retrieving the code..

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'section_options.dart';
import 'station_options.dart';

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
        home: SPD_Details(),
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

class SPD_Details extends StatefulWidget {
  @override
  _SPD_State createState() => _SPD_State();
}

class _SPD_State extends State<SPD_Details> {
  final sectionController = TextEditingController();
  final stationController = TextEditingController();
  final ficircuitController = TextEditingController();
  final indicativeController = TextEditingController();
  final earthvalueController = TextEditingController();
  final dateoftestingController = TextEditingController();
  final installeddateController = TextEditingController();
  final testdateController = TextEditingController();
  final distbtwController = TextEditingController();
  final wirednotController = TextEditingController();
  final indicativespdController = TextEditingController();
  final networkednotController = TextEditingController();

  _TextFieldWithOptionsState? _textFieldWithOptionsState;
  bool isDataExist = false;

  @override
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
                    "SPD_Details",
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
                                Text('No data found for the given Station'),
                          ),
                        );
                      }
                    },
                    child: Text('Check'),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "EI Circuit/AFTC/MSDAC/IPS/LOC",
                    options: [
                      'Select Option',
                      'EI Circuit',
                      'AFTC HUT',
                      'MSDAC HUT',
                      'IPS HUT',
                      'STATION POWER ROOM',
                      'AC 230V MAINS',
                      'LC GATE HUT',
                      'EI-OC HUT',
                      'IB HUT'
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          ficircuitController.clear();
                        } else {
                          ficircuitController.text = newValue!;
                        }
                      });
                    },
                    controller: ficircuitController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Indicative / Non Indicative Type",
                    options: [
                      'Select Option',
                      'Indicative',
                      'Non Indicative Type',
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          indicativeController.clear();
                        } else {
                          indicativeController.text = newValue!;
                        }
                      });
                    },
                    controller: indicativeController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  if (indicativeController.text == 'Indicative') ...[
                    SizedBox(height: 10.0),
                    TextField(
                      controller: installeddateController,
                      decoration: InputDecoration(
                        labelText: 'Date of Installed',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                            color: const Color.fromARGB(209, 0, 0, 0)),
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
                    TextField(
                      controller: testdateController,
                      decoration: InputDecoration(
                        labelText: 'Tested Date',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                            color: const Color.fromARGB(209, 0, 0, 0)),
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
                          testdateController.text = formattedDate;
                        }
                      },
                    ),
                  ],
                  SizedBox(height: 10.0),
                  if (indicativeController.text == 'Non Indicative Type') ...[
                    SizedBox(height: 10.0),
                    TextField(
                      controller: installeddateController,
                      decoration: InputDecoration(
                        labelText: 'Date of Installed',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                            color: const Color.fromARGB(209, 0, 0, 0)),
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
                    TextField(
                      controller: testdateController,
                      decoration: InputDecoration(
                        labelText: 'Tested Date',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                            color: const Color.fromARGB(209, 0, 0, 0)),
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
                          testdateController.text = formattedDate;
                        }
                      },
                    ),
                  ],
                  SizedBox(height: 10.0),
                  TextField(
                    controller: earthvalueController,
                    decoration: InputDecoration(
                      labelText: "Ordinary Earth Value",
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: dateoftestingController,
                    decoration: InputDecoration(
                      labelText: 'Date of Testing',
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
                        dateoftestingController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: distbtwController,
                    decoration: InputDecoration(
                      labelText: "Distance Between SPD And Earth Bus Bar",
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Wired/Not Wired",
                    options: [
                      'Select Option',
                      'Wired',
                      'NOT Wired',
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          wirednotController.clear();
                        } else {
                          wirednotController.text = newValue!;
                        }
                      });
                    },
                    controller: wirednotController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: indicativespdController,
                    decoration: InputDecoration(
                      labelText:
                          "INDICATIVE SPD PROVIDED STATION WITH PF CONTACT",
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "NETWORKED / NOT NETWORKED",
                    options: ['Select Option', 'NETWORKED', 'NOT NETWORKED'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          networkednotController.clear();
                        } else {
                          networkednotController.text = newValue!;
                        }
                      });
                    },
                    controller: networkednotController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
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
      await FirebaseFirestore.instance.collection('SPD_Details').add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'EI Circuit/AFTC/MSDAC/IPS/LOC': ficircuitController.text,
        "Indicative / Non Indicative Type": indicativeController.text,
        'Date of Installed': installeddateController.text,
        'Date of Testing': testdateController.text,
        'Ordinary Earth Value': earthvalueController.text,
        'Tested Date': dateoftestingController.text,
        'Distance Between SPD And Earth Bus Bar': distbtwController.text,
        'Wired/Not Wired': wirednotController.text,
        'INDICATIVE SPD PROVIDED STATION WITH PF CONTACT':
            indicativespdController.text,
        'Networked/Not Worked': networkednotController.text,
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
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('SPD_Details');

      DocumentReference newDocRef = await collectionRef.add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'EI Circuit/AFTC/MSDAC/IPS/LOC': ficircuitController.text,
        "Indicative / Non Indicative Type": indicativeController.text,
        'Date of Installed ': installeddateController.text,
        'Date of Testing': testdateController.text,
        'Ordinary Earth Value': earthvalueController.text,
        'Tested Date': dateoftestingController.text,
        'Distance Between SPD And Earth Bus Bar': distbtwController.text,
        'Wired/Not Wired': wirednotController.text,
        'INDICATIVE SPD PROVIDED STATION WITH PF CONTACT':
            indicativespdController.text,
        'Networked/Not Worked': networkednotController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      clearTextFields();

      QuerySnapshot querySnapshot = await collectionRef
          .where('station', isEqualTo: stationController.text)
          .get();

      querySnapshot.docs.forEach((doc) {
        if (doc.reference == newDocRef) {
          var data = doc.data() as Map<String, dynamic>;

          setState(() {
            sectionController.text = data['section'] ?? '';
            stationController.text = data['station'] ?? '';
            ficircuitController.text =
                data['EI Circuit/AFTC/MSDAC/IPS/LOC'] ?? '';
            indicativeController.text =
                data["Indicative / Non Indicative Type"] ?? '';
            installeddateController.text = data["Date of Installed"] ?? '';
            testdateController.text = data["Date of Testing"] ?? '';
            earthvalueController.text = data['Ordinary Earth Value'] ?? '';
            dateoftestingController.text = data['Tested Date'] ?? '';
            distbtwController.text =
                data['Distance Between SPD And Earth Bus Bar'] ?? '';
            wirednotController.text = data['Wired/Not Wired'] ?? '';
            indicativespdController.text =
                data['INDICATIVE SPD PROVIDED STATION WITH PF CONTACT'] ?? '';
            networkednotController.text = data['Networked/Not Worked'] ?? '';
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
          .collection('SPD_Details')
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
          .collection('SPD_Details')
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

  Future<void> retrieveDataFromFirestore(String slNo) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('SPD_Details')
          .where('station', isEqualTo: slNo)
          .orderBy('updatedAt', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          sectionController.text = data['section'] ?? '';
          stationController.text = data['station'] ?? '';
          ficircuitController.text =
              data['EI Circuit/AFTC/MSDAC/IPS/LOC'] ?? '';
          indicativeController.text =
              data["Indicative / Non Indicative Type"] ?? '';
          installeddateController.text = data["Date of Installed"] ?? '';
          testdateController.text = data["Date of Testing"] ?? '';
          earthvalueController.text = data['Ordinary Earth Value'] ?? '';
          dateoftestingController.text = data['Tested Date'] ?? '';
          distbtwController.text =
              data['Distance Between SPD And Earth Bus Bar'] ?? '';
          wirednotController.text = data['Wired/Not Wired'] ?? '';
          indicativespdController.text =
              data['INDICATIVE SPD PROVIDED STATION WITH PF CONTACT'] ?? '';
          networkednotController.text = data['Networked/Not Worked'] ?? '';
        });
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  void clearTextFields() {
    sectionController.clear();
    stationController.clear();
    ficircuitController.clear();
    indicativeController.clear();
    installeddateController.clear();
    testdateController.clear();
    earthvalueController.clear();
    dateoftestingController.clear();
    distbtwController.clear();
    wirednotController.clear();
    indicativeController.clear();
    networkednotController.clear();
    indicativespdController.clear();

    setState(() {
      isDataExist = false;
    });

    _textFieldWithOptionsState?.clearSelectedOption();
  }
}
