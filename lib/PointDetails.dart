// Completed code with options,date,clearing,and retrieving the code..

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
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
        home: PointDetails(),
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

class PointDetails extends StatefulWidget {
  @override
  _PointState createState() => _PointState();
}

class _PointState extends State<PointDetails> {
  final sectionController = TextEditingController();
  final stationController = TextEditingController();
  final routeController = TextEditingController();
  final mainLoopController = TextEditingController();
  final pointnoController = TextEditingController();
  final typeController = TextEditingController();
  final pointslController = TextEditingController();
  final yearmanufactureController = TextEditingController();
  final makeController = TextEditingController();
  final installdateController = TextEditingController();
  final telescopicController = TextEditingController();
  final pbracketController = TextEditingController();
  final layoutController = TextEditingController();
  final tiebarController = TextEditingController();
  final ssdavailableController = TextEditingController();
  final ssdinsulationController = TextEditingController();
  final motorslController = TextEditingController();
  final motortypeController = TextEditingController();
  final dueController = TextEditingController();
  final circuitController = TextEditingController();
  final noqbca1Controller = TextEditingController();
  final manuController = TextEditingController();
  final testedController = TextEditingController();
  final manu1Controller = TextEditingController();
  final tested2Controller = TextEditingController();
  final manu3Controller = TextEditingController();
  final tested3Controller = TextEditingController();

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
                    "Point Details",
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
                    controller: pointnoController,
                    decoration: InputDecoration(
                      labelText: 'Point No',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      await checkIfSLNoExists(
                          pointnoController.text, stationController.text);
                      if (isDataExist) {
                        await retrieveDataFromFirestore(
                            pointnoController.text, stationController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Data retrieved successfully.'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('No data found for the given Point no.'),
                          ),
                        );
                      }
                    },
                    child: Text('Check'),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: routeController,
                    decoration: InputDecoration(
                      labelText: 'Route',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Main Line/Loop Line",
                    options: ['Select Option', 'Main Line', 'Loop Line'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          mainLoopController.clear();
                        } else {
                          mainLoopController.text = newValue!;
                        }
                      });
                    },
                    controller: mainLoopController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: typeController,
                    decoration: InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: pointslController,
                    decoration: InputDecoration(
                      labelText: 'Point Machine Sl.No',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: yearmanufactureController,
                    decoration: InputDecoration(
                      labelText: 'Year Of Manufacture',
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
                        yearmanufactureController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: makeController,
                    decoration: InputDecoration(
                      labelText: 'Make',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: installdateController,
                    decoration: InputDecoration(
                      labelText: 'Installed Date',
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
                        installdateController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: telescopicController,
                    decoration: InputDecoration(
                      labelText:
                          'With Telescopic stretcher bar with clamp and fish tail arrangement',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: pbracketController,
                    decoration: InputDecoration(
                      labelText: 'P Bracket only for 200mm point machine',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: layoutController,
                    decoration: InputDecoration(
                      labelText: 'Layout',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Tie Bar",
                    options: ['Select Option', 'Available', 'Not Available'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          tiebarController.clear();
                        } else {
                          tiebarController.text = newValue!;
                        }
                      });
                    },
                    controller: tiebarController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "SSD Available",
                    options: ['Select Option', 'Connected', 'Not Connected'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          ssdavailableController.clear();
                        } else {
                          ssdavailableController.text = newValue!;
                        }
                      });
                    },
                    controller: ssdavailableController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "SSD Insulation",
                    options: ['Select Option', 'Claw', 'T Type'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          ssdinsulationController.clear();
                        } else {
                          ssdinsulationController.text = newValue!;
                        }
                      });
                    },
                    controller: ssdinsulationController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: motorslController,
                    decoration: InputDecoration(
                      labelText: 'Motor Sl.No',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Motor Type",
                    options: [
                      'Select Option',
                      'IP67',
                      'Normal',
                      'Motor Make',
                      'At-Km',
                      'Location Number'
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          motortypeController.clear();
                        } else {
                          motortypeController.text = newValue!;
                        }
                      });
                    },
                    controller: motortypeController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: dueController,
                    decoration: InputDecoration(
                      labelText: 'Due for renewel on',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: circuitController,
                    decoration: InputDecoration(
                      labelText: 'Circuit',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: noqbca1Controller,
                    decoration: InputDecoration(
                      labelText: 'No. of QBCA1 Relays',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: manuController,
                    decoration: InputDecoration(
                      labelText: 'Date of Manufacture.1',
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
                        manuController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: testedController,
                    decoration: InputDecoration(
                      labelText: 'Date of Tested.1',
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
                        testedController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: manu1Controller,
                    decoration: InputDecoration(
                      labelText: 'Date of Manufacture.2',
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
                        manu1Controller.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: tested2Controller,
                    decoration: InputDecoration(
                      labelText: 'Date of Tested.2',
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
                        tested2Controller.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: manu3Controller,
                    decoration: InputDecoration(
                      labelText: 'Date of Manufacture.3',
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
                        manu3Controller.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: tested3Controller,
                    decoration: InputDecoration(
                      labelText: 'Date of Tested.3',
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
                        tested3Controller.text = formattedDate;
                      }
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
      await FirebaseFirestore.instance.collection('Point_Details').add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Route': routeController.text,
        'Make': makeController.text,
        'Main Line / Loop Line': mainLoopController.text,
        'Point no': pointnoController.text,
        'Type': typeController.text,
        'Point Machine Sl.No': pointslController.text,
        'Year Of Manufacture': yearmanufactureController.text,
        'Installed Date': installdateController.text,
        'With Telescopic stretcher bar with clamp and fish tail arrangement':
            telescopicController.text,
        'P Bracket only for 200mm point machine': pbracketController.text,
        'Layout': layoutController.text,
        'Tie Bar': tiebarController.text,
        'SSD Available': ssdavailableController.text,
        'SSD Insulation': ssdinsulationController.text,
        'Motor Sl.No': motorslController.text,
        'Motor Type': motortypeController.text,
        'Due for renewel on': dueController.text,
        'Circuit': circuitController.text,
        'No. of QBCA1 Relays': noqbca1Controller.text,
        'Date of Manufacture.1': manuController.text,
        'Date of Tested.1': testedController.text,
        'Date of Manufacture.2': manu1Controller.text,
        'Date of Tested.2': tested2Controller.text,
        'Date of Manufacture.3': manu3Controller.text,
        'Date of Tested.3': tested3Controller.text,
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
          FirebaseFirestore.instance.collection('Point_Details');

      DocumentReference newDocRef = await collectionRef.add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Route': routeController.text,
        'Make': makeController.text,
        'Main Line / Loop Line': mainLoopController.text,
        'Point no': pointnoController.text,
        'Type': typeController.text,
        'Point Machine Sl.No': pointslController.text,
        'Year Of Manufacture': yearmanufactureController.text,
        'Installed Date': installdateController.text,
        'With Telescopic stretcher bar with clamp and fish tail arrangement':
            telescopicController.text,
        'P Bracket only for 200mm point machine': pbracketController.text,
        'Layout': layoutController.text,
        'Tie Bar': tiebarController.text,
        'SSD Available': ssdavailableController.text,
        'SSD Insulation': ssdinsulationController.text,
        'Motor Sl.No': motorslController.text,
        'Motor Type': motortypeController.text,
        'Due for renewel on': dueController.text,
        'Circuit': circuitController.text,
        'No. of QBCA1 Relays': noqbca1Controller.text,
        'Date of Manufacture.1': manuController.text,
        'Date of Tested.1': testedController.text,
        'Date of Manufacture.2': manu1Controller.text,
        'Date of Tested.2': tested2Controller.text,
        'Date of Manufacture.3': manu3Controller.text,
        'Date of Tested.3': tested3Controller.text,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      clearTextFields();

      QuerySnapshot querySnapshot = await collectionRef
          .where('Point no', isEqualTo: pointnoController.text)
          .get();

      querySnapshot.docs.forEach((doc) {
        if (doc.reference == newDocRef) {
          var data = doc.data() as Map<String, dynamic>;

          setState(() {
            sectionController.text = data['section'] ?? '';
            stationController.text = data['station'] ?? '';
            routeController.text = data['Route'] ?? '';
            makeController.text = data['Make'] ?? '';
            pointslController.text = data['Point Machine Sl.No'] ?? '';
            mainLoopController.text = data['Main Line / Loop Line'] ?? '';
            yearmanufactureController.text = data['Year Of Manufacture'] ?? '';
            installdateController.text = data['Installed Date'] ?? '';
            telescopicController.text = data[
                    'With Telescopic stretcher bar with clamp and fish tail arrangement'] ??
                '';
            pbracketController.text =
                data['P Bracket only for 200mm point machine'] ?? '';
            layoutController.text = data['Layout'] ?? '';
            tiebarController.text = data['Tie Bar'] ?? '';
            ssdavailableController.text = data['SSD Available'] ?? '';
            ssdinsulationController.text = data['SSD Insualtion'] ?? '';
            motorslController.text = data['Motor Sl.No'] ?? '';
            motortypeController.text = data['Motor Type'] ?? '';
            layoutController.text = data['Due for renewel on'] ?? '';
            circuitController.text = data['Circuit'] ?? '';
            noqbca1Controller.text = data['No. of QBCA1 Relays'] ?? '';
            manuController.text = data['Date of Manufacture.1'] ?? '';
            testedController.text = data['Date of Tested.1'] ?? '';
            manu1Controller.text = data['Date of Manufacture.2'] ?? '';
            tested2Controller.text = data['Date of Tested.2'] ?? '';
            manu3Controller.text = data['Date of Manufacture.3'] ?? '';
            tested3Controller.text = data['Date of Tested.3'] ?? '';
            typeController.text = data['Type'] ?? '';
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
          .collection('Point_Details')
          .where('Point no', isEqualTo: pointnoController.text)
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
          .collection('Point_Details')
          .where('station', isEqualTo: station)
          .where('Point no', isEqualTo: slNo)
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

  Future<void> retrieveDataFromFirestore(String slNo, String station) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Point_Details')
          .where('station', isEqualTo: station)
          .where('Point no', isEqualTo: slNo)
          .orderBy('updatedAt', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          sectionController.text = data['section'] ?? '';
          stationController.text = data['station'] ?? '';
          routeController.text = data['Route'] ?? '';
          makeController.text = data['Make'] ?? '';
          pointslController.text = data['Point Machine Sl.No'] ?? '';
          mainLoopController.text = data['Main Line / Loop Line'] ?? '';
          yearmanufactureController.text = data['Year Of Manufacture'] ?? '';
          installdateController.text = data['Installed Date'] ?? '';
          telescopicController.text = data[
                  'With Telescopic stretcher bar with clamp and fish tail arrangement'] ??
              '';
          pbracketController.text =
              data['P Bracket only for 200mm point machine'] ?? '';
          layoutController.text = data['Layout'] ?? '';
          tiebarController.text = data['Tie Bar'] ?? '';
          ssdavailableController.text = data['SSD Available'] ?? '';
          ssdinsulationController.text = data['SSD Insualtion'] ?? '';
          motorslController.text = data['Motor Sl.No'] ?? '';
          motortypeController.text = data['Motor Type'] ?? '';
          layoutController.text = data['Due for renewel on'] ?? '';
          circuitController.text = data['Circuit'] ?? '';
          noqbca1Controller.text = data['No. of QBCA1 Relays'] ?? '';
          manuController.text = data['Date of Manufacture.1'] ?? '';
          testedController.text = data['Date of Tested.1'] ?? '';
          manu1Controller.text = data['Date of Manufacture.2'] ?? '';
          tested2Controller.text = data['Date of Tested.2'] ?? '';
          manu3Controller.text = data['Date of Manufacture.3'] ?? '';
          tested3Controller.text = data['Date of Tested.3'] ?? '';
          typeController.text = data['Type'] ?? '';
        });
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  void clearTextFields() {
    sectionController.clear();
    stationController.clear();
    routeController.clear();
    makeController.clear();
    mainLoopController.clear();
    pointnoController.clear();
    pointslController.clear();
    yearmanufactureController.clear();
    installdateController.clear();
    telescopicController.clear();
    pbracketController.clear();
    layoutController.clear();
    ssdavailableController.clear();
    ssdinsulationController.clear();
    tiebarController.clear();
    motorslController.clear();
    circuitController.clear();
    typeController.clear();
    noqbca1Controller.clear();
    manu1Controller.clear();
    manuController.clear();
    manu3Controller.clear();
    testedController.clear();
    tested2Controller.clear();
    tested3Controller.clear();

    setState(() {
      isDataExist = false;
    });

    _textFieldWithOptionsState?.clearSelectedOption();
  }
}
