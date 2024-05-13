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
        home: Inverter_Details(),
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

class Inverter_Details extends StatefulWidget {
  @override
  _Inverter_State createState() => _Inverter_State();
}

class _Inverter_State extends State<Inverter_Details> {
  final sectionController = TextEditingController();
  final stationController = TextEditingController();
  final typeController = TextEditingController();
  final makeController = TextEditingController();
  final batterymakeController = TextEditingController();
  final lmlavrlaController = TextEditingController();
  final installeddateController = TextEditingController();
  final batterycapacityController = TextEditingController();
  final batteryinstalleddateController = TextEditingController();
  final batterymfdController = TextEditingController();
  final warrantyamcController = TextEditingController();
  final frominstalledController = TextEditingController();
  final toinstalledController = TextEditingController();

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
                    "Inverter Details",
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
                    labelText: "Type",
                    options: [
                      'Select Option',
                      '4 Roads',
                      '6 Roads',
                      'LC/IB',
                      'AUTO HUTS',
                    ],
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
                      labelText: "Make",
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
                  TextField(
                    controller: batterymakeController,
                    decoration: InputDecoration(
                      labelText: "Battery Make",
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "LMLA/VRLA",
                    options: [
                      'Select Option',
                      'LMLA',
                      'VRLA',
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          lmlavrlaController.clear();
                        } else {
                          lmlavrlaController.text = newValue!;
                        }
                      });
                    },
                    controller: lmlavrlaController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: batterycapacityController,
                    decoration: InputDecoration(
                      labelText: "Battery Capacity",
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: batteryinstalleddateController,
                    decoration: InputDecoration(
                      labelText: 'Battery Date of Installation',
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
                        batteryinstalleddateController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: batterymfdController,
                    decoration: InputDecoration(
                      labelText: 'Battery MFD (Y)',
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
                        batterymfdController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Warranty / AMC",
                    options: [
                      'Select Option',
                      'Warranty',
                      'AMC',
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          warrantyamcController.clear();
                        } else {
                          warrantyamcController.text = newValue!;
                        }
                      });
                    },
                    controller: warrantyamcController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  if (warrantyamcController.text == 'Warranty') ...[
                    SizedBox(height: 10.0),
                    TextField(
                      controller: frominstalledController,
                      decoration: InputDecoration(
                        labelText: 'From Date',
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
                          frominstalledController.text = formattedDate;
                        }
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: toinstalledController,
                      decoration: InputDecoration(
                        labelText: 'To Date',
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
                          toinstalledController.text = formattedDate;
                        }
                      },
                    ),
                  ],
                  SizedBox(height: 10.0),
                  if (warrantyamcController.text == 'AMC') ...[
                    SizedBox(height: 10.0),
                    TextField(
                      controller: frominstalledController,
                      decoration: InputDecoration(
                        labelText: 'From date',
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
                          frominstalledController.text = formattedDate;
                        }
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: toinstalledController,
                      decoration: InputDecoration(
                        labelText: 'To Date',
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
                          toinstalledController.text = formattedDate;
                        }
                      },
                    ),
                  ],
                  SizedBox(height: 10.0),
                  if (warrantyamcController.text == 'ARC') ...[
                    SizedBox(height: 10.0),
                    TextField(
                      controller: frominstalledController,
                      decoration: InputDecoration(
                        labelText: 'From Date',
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
                          frominstalledController.text = formattedDate;
                        }
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: toinstalledController,
                      decoration: InputDecoration(
                        labelText: 'To Date',
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
                          toinstalledController.text = formattedDate;
                        }
                      },
                    ),
                  ],
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
      await FirebaseFirestore.instance.collection('IPS_Details').add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Type': typeController.text,
        "Make": makeController.text,
        'Date of Installation': installeddateController.text,
        'Battery Capacity': batterycapacityController.text,
        'Battery Make': batterymakeController.text,
        'LMLA/VRLA': lmlavrlaController.text,
        'Battery Date of Installation': batteryinstalleddateController.text,
        'Battery MFD (Y)': batterymfdController.text,
        'From Date': frominstalledController.text,
        'To Date': toinstalledController.text,
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
          FirebaseFirestore.instance.collection('IPS_Details');

      DocumentReference newDocRef = await collectionRef.add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Type': typeController.text,
        "Make": makeController.text,
        'Date of Installation': installeddateController.text,
        'Battery Capacity': batterycapacityController.text,
        'Battery Make': batterymakeController.text,
        'LMLA/VRLA': lmlavrlaController.text,
        'Battery Date of Installation': batteryinstalleddateController.text,
        'Battery MFD (Y)': batterymfdController.text,
        'From Date': frominstalledController.text,
        'To Date': toinstalledController.text,
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
            typeController.text = data['Type'] ?? '';
            makeController.text = data["Make"] ?? '';
            installeddateController.text = data["Date of Installation"] ?? '';
            lmlavrlaController.text = data["Date of Testing"] ?? '';
            batterymakeController.text = data['Battery Make'] ?? '';
            lmlavrlaController.text = data['LMLA/VRLA'] ?? '';
            batterycapacityController.text = data['Battery Capacity'] ?? '';
            batteryinstalleddateController.text =
                data['Battery Date of Installation'] ?? '';
            batterymfdController.text = data['Battery MFD (Y)'] ?? '';
            frominstalledController.text = data['From Date'] ?? '';
            toinstalledController.text = data['To Date'] ?? '';
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
          .collection('IPS_Details')
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
          .collection('IPS_Details')
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
          .collection('IPS_Details')
          .where('station', isEqualTo: slNo)
          .orderBy('updatedAt', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          sectionController.text = data['section'] ?? '';
          stationController.text = data['station'] ?? '';
          typeController.text = data['Type'] ?? '';
          makeController.text = data["Make"] ?? '';
          installeddateController.text = data["Date of Installation"] ?? '';
          lmlavrlaController.text = data["Date of Testing"] ?? '';
          batterymakeController.text = data['Battery Make'] ?? '';
          lmlavrlaController.text = data['LMLA/VRLA'] ?? '';
          batterycapacityController.text = data['Battery Capacity'] ?? '';
          batteryinstalleddateController.text =
              data['Battery Date of Installation'] ?? '';
          batterymfdController.text = data['Battery MFD (Y)'] ?? '';
          frominstalledController.text = data['From Date'] ?? '';
          toinstalledController.text = data['To Date'] ?? '';
        });
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  void clearTextFields() {
    sectionController.clear();
    stationController.clear();
    typeController.clear();
    makeController.clear();
    installeddateController.clear();
    batterymakeController.clear();
    lmlavrlaController.clear();
    batteryinstalleddateController.clear();
    batterycapacityController.clear();
    batterymfdController.clear();
    frominstalledController.clear();
    toinstalledController.clear();

    setState(() {
      isDataExist = false;
    });

    _textFieldWithOptionsState?.clearSelectedOption();
  }
}
