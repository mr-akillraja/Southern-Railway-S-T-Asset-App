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
        home: Route_Details(),
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

class Route_Details extends StatefulWidget {
  @override
  _Route_State createState() => _Route_State();
}

class _Route_State extends State<Route_Details> {
  final sectionController = TextEditingController();
  final stationController = TextEditingController();
  final slnoController = TextEditingController();
  final makeController = TextEditingController();
  final typeController = TextEditingController();
  final dateofmanuController = TextEditingController();
  final dateofinstallationController = TextEditingController();
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
                    "Route_Details",
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
                    controller: slnoController,
                    decoration: InputDecoration(
                      labelText: 'slno',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      await checkIfSLNoExists(
                          slnoController.text, stationController.text);
                      if (isDataExist) {
                        await retrieveDataFromFirestore(slnoController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Data retrieved successfully.'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('No data found for the given Serial no.'),
                          ),
                        );
                      }
                    },
                    child: Text('Check'),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "TYPE (RG)",
                    options: ['Select Option', 'Integrated', 'Non Intergrated'],
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
                    controller: makeController,
                    decoration: InputDecoration(
                      labelText: "make",
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: dateofmanuController,
                    decoration: InputDecoration(
                      labelText: 'Date of Manufacture',
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
                        dateofmanuController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: dateofinstallationController,
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
                        dateofinstallationController.text = formattedDate;
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
      await FirebaseFirestore.instance.collection('Route_Details').add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'slno': slnoController.text,
        "Type": typeController.text,
        'make': makeController.text,
        'Date of Manufacture': dateofmanuController.text,
        'Date of Installation': dateofinstallationController.text,
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
          FirebaseFirestore.instance.collection('Route_Details');

      DocumentReference newDocRef = await collectionRef.add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'slno': slnoController.text,
        "Type": typeController.text,
        'make': makeController.text,
        'Date of Manufacture': dateofmanuController.text,
        'Date of Installation': dateofinstallationController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      clearTextFields();

      QuerySnapshot querySnapshot = await collectionRef
          .where('slno', isEqualTo: slnoController.text)
          .get();

      querySnapshot.docs.forEach((doc) {
        if (doc.reference == newDocRef) {
          var data = doc.data() as Map<String, dynamic>;

          setState(() {
            sectionController.text = data['section'] ?? '';
            stationController.text = data['station'] ?? '';
            slnoController.text = data['slno'] ?? '';
            typeController.text = data["Type"] ?? '';
            makeController.text = data['make'] ?? '';
            dateofmanuController.text = data['Date of Manufacture'] ?? '';
            dateofinstallationController.text =
                data['Date of Installation'] ?? '';
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
          .collection('Route_Details')
          .where('slno', isEqualTo: slnoController.text)
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
          .collection('Route_Details')
          .where('station', isEqualTo: station)
          .where('slno', isEqualTo: slNo)
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
          .collection('Route_Details')
          .where('slno', isEqualTo: slNo)
          .orderBy('updatedAt', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          sectionController.text = data['section'] ?? '';
          stationController.text = data['station'] ?? '';
          slnoController.text = data['slno'] ?? '';
          typeController.text = data["Type"] ?? '';
          makeController.text = data['make'] ?? '';
          dateofmanuController.text = data['Date of Manufacture'] ?? '';
          dateofinstallationController.text =
              data['Date of Installation'] ?? '';
        });
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  void clearTextFields() {
    sectionController.clear();
    stationController.clear();
    slnoController.clear();
    makeController.clear();
    typeController.clear();
    dateofinstallationController.clear();
    dateofmanuController.clear();

    setState(() {
      isDataExist = false;
    });

    _textFieldWithOptionsState?.clearSelectedOption();
  }
}
