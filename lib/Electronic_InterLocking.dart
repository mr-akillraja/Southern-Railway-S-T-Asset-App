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
        home: EarthLeakage_Details(),
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

class EarthLeakage_Details extends StatefulWidget {
  @override
  EarthLeakage_State createState() => EarthLeakage_State();
}

class EarthLeakage_State extends State<EarthLeakage_Details> {
  final sectionController = TextEditingController();
  final stationController = TextEditingController();
  final makeController = TextEditingController();
  final centralizedController = TextEditingController();
  final dateofinstallationController = TextEditingController();
  final versionController = TextEditingController();
  final standbyController = TextEditingController();
  final dualController = TextEditingController();
  final upgradedController = TextEditingController();
  final upgradeddateController = TextEditingController();
  final mtavailableController = TextEditingController();
  final amcwarrantyController = TextEditingController();
  final fromwarrantydateController = TextEditingController();
  final towarrantydateController = TextEditingController();
  final fromamcdateController = TextEditingController();
  final toamcdateController = TextEditingController();
  final availablenotController = TextEditingController();
  final powersupplyController = TextEditingController();
  final emergencypanelController = TextEditingController();
  final workingnotController = TextEditingController();

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
                    "Electronic_Interlocking_Details",
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
                  TextField(
                    controller: makeController,
                    decoration: InputDecoration(
                      labelText: "Make",
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFieldWithOptions(
                    labelText: "Centralized/Distributed",
                    options: ['Select Option', 'Centralized', 'Distributed'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          centralizedController.clear();
                        } else {
                          centralizedController.text = newValue!;
                        }
                      });
                    },
                    controller: centralizedController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
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
                  SizedBox(height: 20.0),
                  TextFieldWithOptions(
                    labelText: "Dual/Panel",
                    options: [
                      'Select Option',
                      'Dual Panel',
                      'VDU Panel',
                      'Panel'
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          dualController.clear();
                        } else {
                          dualController.text = newValue!;
                        }
                      });
                    },
                    controller: dualController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFieldWithOptions(
                    labelText: "STAND BY",
                    options: ['Select Option', 'HOT STAND BY', 'WARM STAND BY'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          standbyController.clear();
                        } else {
                          standbyController.text = newValue!;
                        }
                      });
                    },
                    controller: standbyController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: versionController,
                    decoration: InputDecoration(
                      labelText: "Version",
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFieldWithOptions(
                    labelText: "Upgraded/Not Upgraded",
                    options: ['Select Option', 'Upgraded', 'Not Upgraded'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          upgradedController.clear();
                        } else {
                          upgradedController.text = newValue!;
                        }
                      });
                    },
                    controller: upgradedController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: upgradeddateController,
                    decoration: InputDecoration(
                      labelText: 'Upgraded Date',
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
                        upgradeddateController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFieldWithOptions(
                    labelText: "'MT AVAILABLE INSIDE/OUTSIDE RELAY ROOM'",
                    options: ['Select Option', 'INSIDE', 'OUTSIDE'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          mtavailableController.clear();
                        } else {
                          mtavailableController.text = newValue!;
                        }
                      });
                    },
                    controller: mtavailableController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFieldWithOptions(
                    labelText: "Warranty/AMC",
                    options: ['Select Option', 'Warranty', 'AMC'],
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
                  if (amcwarrantyController.text == 'Warranty') ...[
                    SizedBox(height: 10.0),
                    TextField(
                      controller: fromwarrantydateController,
                      decoration: InputDecoration(
                        labelText: 'From warranty Date',
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
                          fromwarrantydateController.text = formattedDate;
                        }
                      },
                    ),
                  ],
                  SizedBox(height: 10.0),
                  if (amcwarrantyController.text == 'Warranty') ...[
                    SizedBox(height: 10.0),
                    TextField(
                      controller: towarrantydateController,
                      decoration: InputDecoration(
                        labelText: 'To warranty Date',
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
                          towarrantydateController.text = formattedDate;
                        }
                      },
                    ),
                  ],
                  SizedBox(height: 10.0),
                  if (amcwarrantyController.text == 'AMC') ...[
                    SizedBox(height: 10.0),
                    TextField(
                      controller: fromamcdateController,
                      decoration: InputDecoration(
                        labelText: 'From AMC Date',
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
                          fromamcdateController.text = formattedDate;
                        }
                      },
                    ),
                  ],
                  SizedBox(height: 10.0),
                  if (amcwarrantyController.text == 'AMC') ...[
                    SizedBox(height: 10.0),
                    TextField(
                      controller: toamcdateController,
                      decoration: InputDecoration(
                        labelText: 'To warranty Date',
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
                          toamcdateController.text = formattedDate;
                        }
                      },
                    ),
                  ],
                  SizedBox(height: 20.0),
                  TextFieldWithOptions(
                    labelText: "AC PROVIDED/NOT PROVIDED",
                    options: ['Select Option', 'PROVIDED', 'NOT PROVIDED'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          availablenotController.clear();
                        } else {
                          availablenotController.text = newValue!;
                        }
                      });
                    },
                    controller: availablenotController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFieldWithOptions(
                    labelText: "Power Supply",
                    options: ['Select Option', 'IPS Supply', 'Charger'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          powersupplyController.clear();
                        } else {
                          powersupplyController.text = newValue!;
                        }
                      });
                    },
                    controller: powersupplyController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFieldWithOptions(
                    labelText: "Emergency Panel",
                    options: ['Select Option', 'Available', 'Not Available'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          emergencypanelController.clear();
                        } else {
                          emergencypanelController.text = newValue!;
                        }
                      });
                    },
                    controller: emergencypanelController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  if (emergencypanelController.text == 'Available') ...[
                    SizedBox(height: 20.0),
                    TextFieldWithOptions(
                      labelText: "Working or Not Working",
                      options: ['Select Option', 'Working', 'Not Working'],
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue == 'Select Option') {
                            workingnotController.clear();
                          } else {
                            workingnotController.text = newValue!;
                          }
                        });
                      },
                      controller: workingnotController,
                      setTextFieldWithOptionsState: (state) {
                        _textFieldWithOptionsState = state;
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
          .collection('Electronic_Interlocking_Details')
          .add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Make': makeController.text,
        'Centralized/Distributed': centralizedController.text,
        "Version": versionController.text,
        'Date of Installatoin': dateofinstallationController.text,
        'Dual/Panel': dualController.text,
        'Stand by': standbyController.text,
        'Upgraded/Not Upgraded': upgradedController.text,
        'Upgraded Date': upgradeddateController.text,
        "'MT AVAILABLE INSIDE/OUTSIDE RELAY ROOM'": mtavailableController.text,
        "Warranty/AMC": amcwarrantyController.text,
        "From warranty Date": fromwarrantydateController.text,
        "To warranty Date": towarrantydateController.text,
        "From AMC Date": fromamcdateController.text,
        "To AMC Date": toamcdateController.text,
        "AC PROVIDED/NOT PROVIDED": availablenotController.text,
        "Power Supply": powersupplyController.text,
        "Emergency Panel": emergencypanelController.text,
        'Working/Not Working': workingnotController.text,
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
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('Electronic_Interlocking_Details');

      DocumentReference newDocRef = await collectionRef.add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Make': makeController.text,
        'Centralized/Distributed': centralizedController.text,
        "Version": versionController.text,
        'Date of Installatoin': dateofinstallationController.text,
        'Dual/Panel': dualController.text,
        'Stand by': standbyController.text,
        'Upgraded/Not Upgraded': upgradedController.text,
        'Upgraded Date': upgradeddateController.text,
        "'MT AVAILABLE INSIDE/OUTSIDE RELAY ROOM'": mtavailableController.text,
        "Warranty/AMC": amcwarrantyController.text,
        "From warranty Date": fromwarrantydateController.text,
        "To warranty Date": towarrantydateController.text,
        "From AMC Date": fromamcdateController.text,
        "To AMC Date": toamcdateController.text,
        "AC PROVIDED/NOT PROVIDED": availablenotController.text,
        "Power Supply": powersupplyController.text,
        "Emergency Panel": emergencypanelController.text,
        'Working/Not Working': workingnotController.text,
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
            makeController.text = data['Make'] ?? '';
            centralizedController.text = data['Centralized/Distributed'] ?? '';
            versionController.text = data["Version"] ?? '';
            dateofinstallationController.text =
                data['Date of Installatoin'] ?? '';
            dualController.text = data['Dual/Panel'] ?? '';
            standbyController.text = data['Stand by'] ?? '';
            upgradedController.text = data['Upgraded/Not Upgraded'] ?? '';
            upgradeddateController.text = data['Upgraded Date'] ?? '';
            mtavailableController.text =
                data["'MT AVAILABLE INSIDE/OUTSIDE RELAY ROOM'"] ?? '';
            amcwarrantyController.text = data['Warranty/AMC'] ?? '';
            fromwarrantydateController.text = data['From warranty Date'] ?? '';
            towarrantydateController.text = data["To warranty Date"] ?? '';
            fromamcdateController.text = data['From AMC Date'] ?? '';
            toamcdateController.text = data["To AMC Date"] ?? '';
            availablenotController.text =
                data['AC PROVIDED/NOT PROVIDED'] ?? '';
            powersupplyController.text = data["Power Supply"] ?? '';
            emergencypanelController.text = data["Emergency Panel"] ?? '';
            workingnotController.text = data["Working/Not Working"] ?? '';
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
          .collection('Electronic_Interlocking_Details')
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
          .collection('Electronic_Interlocking_Details')
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
          .collection('Electronic_Interlocking_Details')
          .where('station', isEqualTo: slNo)
          .orderBy('updatedAt', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          sectionController.text = data['section'] ?? '';
          stationController.text = data['station'] ?? '';
          makeController.text = data['Make'] ?? '';
          centralizedController.text = data['Centralized/Distributed'] ?? '';
          versionController.text = data["Version"] ?? '';
          dateofinstallationController.text =
              data['Date of Installatoin'] ?? '';
          dualController.text = data['Dual/Panel'] ?? '';
          standbyController.text = data['Stand by'] ?? '';
          upgradedController.text = data['Upgraded/Not Upgraded'] ?? '';
          upgradeddateController.text = data['Upgraded Date'] ?? '';
          mtavailableController.text =
              data["'MT AVAILABLE INSIDE/OUTSIDE RELAY ROOM'"] ?? '';
          amcwarrantyController.text = data['Warranty/AMC'] ?? '';
          fromwarrantydateController.text = data['From warranty Date'] ?? '';
          towarrantydateController.text = data["To warranty Date"] ?? '';
          fromamcdateController.text = data['From AMC Date'] ?? '';
          toamcdateController.text = data["To AMC Date"] ?? '';
          availablenotController.text = data['AC PROVIDED/NOT PROVIDED'] ?? '';
          powersupplyController.text = data["Power Supply"] ?? '';
          emergencypanelController.text = data["Emergency Panel"] ?? '';
          workingnotController.text = data["Working/Not Working"] ?? '';
        });
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  void clearTextFields() {
    sectionController.clear();
    stationController.clear();
    makeController.clear();
    centralizedController.clear();
    dateofinstallationController.clear();
    versionController.clear();
    standbyController.clear();
    dualController.clear();
    upgradedController.clear();
    upgradeddateController.clear();
    mtavailableController.clear();
    amcwarrantyController.clear();
    fromwarrantydateController.clear();
    towarrantydateController.clear();
    fromamcdateController.clear();
    toamcdateController.clear();
    availablenotController.clear();
    powersupplyController.clear();
    emergencypanelController.clear();
    workingnotController.clear();

    setState(() {
      isDataExist = false;
    });

    _textFieldWithOptionsState?.clearSelectedOption();
  }
}
