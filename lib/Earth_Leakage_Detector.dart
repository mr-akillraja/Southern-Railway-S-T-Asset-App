// Completed code with options,date,clearing,and retrieving the code..
// Problem in Retreiving the data has to updated in the last

import 'package:asset_app/Cable_Meggering.dart';
import 'package:asset_app/Earth_meggering.dart';
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
        home: EarthLeakage(),
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

class EarthLeakage extends StatefulWidget {
  @override
  _EarthLeakageState createState() => _EarthLeakageState();
}

class _EarthLeakageState extends State<EarthLeakage> {
  final sectionController = TextEditingController();
  final stationController = TextEditingController();
  final slnoController = TextEditingController();
  final eldController = TextEditingController();
  final versionnoController = TextEditingController();
  final connectedchannelsController = TextEditingController();
  final dateofmanuController = TextEditingController();
  final makeController = TextEditingController();
  final commissioneddateController = TextEditingController();
  final dlrtuController = TextEditingController();
  final connectednotController = TextEditingController();
  final consigneeController = TextEditingController();

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
                    "Earth Leakage Detector Details",
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
                      labelText: 'Serial No',
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
                  TextField(
                    controller: eldController,
                    decoration: InputDecoration(
                      labelText: "No of ELD's Connected",
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
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
                    controller: versionnoController,
                    decoration: InputDecoration(
                      labelText: 'Version No',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: connectedchannelsController,
                    decoration: InputDecoration(
                      labelText: 'Connected Channels',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: dateofmanuController,
                    decoration: InputDecoration(
                      labelText: 'Manufactured Date',
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
                    controller: commissioneddateController,
                    decoration: InputDecoration(
                      labelText: 'Commissioned Date',
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
                  TextFieldWithOptions(
                    labelText: "DL/RTU",
                    options: ['Select Option', 'DL', 'RTU'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          dlrtuController.clear();
                        } else {
                          dlrtuController.text = newValue!;
                        }
                      });
                    },
                    controller: dlrtuController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  if (dlrtuController.text == 'DL') ...[
                    TextFieldWithOptions(
                      labelText: "DL/RTU",
                      options: ['Select Option', 'Connected', 'Not Connected'],
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue == 'Select Option') {
                            connectednotController.clear();
                          } else {
                            connectednotController.text = newValue!;
                          }
                        });
                      },
                      controller: connectednotController,
                      setTextFieldWithOptionsState: (state) {
                        _textFieldWithOptionsState = state;
                      },
                    ),
                  ],
                  if (dlrtuController.text == 'RTU') ...[
                    TextFieldWithOptions(
                      labelText: "DL/RTU",
                      options: ['Select Option', 'Connected', 'Not Connected'],
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue == 'Select Option') {
                            connectednotController.clear();
                          } else {
                            connectednotController.text = newValue!;
                          }
                        });
                      },
                      controller: connectednotController,
                      setTextFieldWithOptionsState: (state) {
                        _textFieldWithOptionsState = state;
                      },
                    ),
                  ],
                  SizedBox(height: 10.0),
                  TextField(
                    controller: consigneeController,
                    decoration: InputDecoration(
                      labelText: 'Consignee',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0, width: 10.0),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EarthMeggering()),
                          );
                        },
                        child: Text('Earth_Meggering'),
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CableMeggering()),
                          );
                        },
                        child: Text('Cable_Meggering'),
                      ),
                    ],
                  ),
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
      await FirebaseFirestore.instance.collection('EarthLeakge_Details').add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'slno': slnoController.text,
        'Make': makeController.text,
        "No of ELD's Connected": eldController.text,
        'Version No': versionnoController.text,
        'Connected Channels': connectedchannelsController.text,
        'Manufactured Date': dateofmanuController.text,
        'Commissioned Date': commissioneddateController.text,
        'DL/RTU': dlrtuController.text,
        'Connected/Not Connected': connectednotController.text,
        'Consignee': consigneeController.text,
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
          FirebaseFirestore.instance.collection('EarthLeakage_Details');

      DocumentReference newDocRef = await collectionRef.add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'slno': slnoController.text,
        'Make': makeController.text,
        "No of ELD's Connected": eldController.text,
        'Version No': versionnoController.text,
        'Connected Channels': connectedchannelsController.text,
        'Manufactured Date': dateofmanuController.text,
        'Commissioned Date': commissioneddateController.text,
        'DL/RTU': dlrtuController.text,
        'Connected/Not Connected': connectednotController.text,
        'Consignee': consigneeController.text,
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
            makeController.text = data['Make'] ?? '';
            slnoController.text = data['slno'] ?? '';
            eldController.text = data["No of ELD's Connected"] ?? '';
            versionnoController.text = data['Version No'] ?? '';
            connectedchannelsController.text = data['Connected Channels'] ?? '';
            dateofmanuController.text = data['Manufactured Date'] ?? '';
            commissioneddateController.text = data['Commissioned Date'] ?? '';
            dlrtuController.text = data['DL/RTu'] ?? '';
            connectednotController.text = data['Connected/Not Connected'] ?? '';
            consigneeController.text = data['Consignee'] ?? '';
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
          .collection('EarthLeakage_Details')
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
          .collection('EarthLeakage_Details')
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
          .collection('EarthLeakage_Details')
          .where('slno', isEqualTo: slNo)
          .orderBy('updatedAt', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          sectionController.text = data['section'] ?? '';
          stationController.text = data['station'] ?? '';
          makeController.text = data['Make'] ?? '';
          slnoController.text = data['slno'] ?? '';
          eldController.text = data["No of ELD's Connected"] ?? '';
          versionnoController.text = data['Version No'] ?? '';
          connectedchannelsController.text = data['Connected Channels'] ?? '';
          dateofmanuController.text = data['Manufactured Date'] ?? '';
          commissioneddateController.text = data['Commissioned Date'] ?? '';
          dlrtuController.text = data['DL/RTu'] ?? '';
          connectednotController.text = data['Connected/Not Connected'] ?? '';
          consigneeController.text = data['Consignee'] ?? '';
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
    eldController.clear();
    connectednotController.clear();
    versionnoController.clear();
    dateofmanuController.clear();
    connectedchannelsController.clear();
    dlrtuController.clear();
    consigneeController.clear();
    commissioneddateController.clear();

    setState(() {
      isDataExist = false;
    });

    _textFieldWithOptionsState?.clearSelectedOption();
  }
}
