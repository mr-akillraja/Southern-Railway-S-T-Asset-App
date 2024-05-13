// Completed code with options,date,clearing,and retrieving the code..
// Data Retrieved Successfully while importing..

import 'package:asset_app/A_MARKER.dart';
import 'package:asset_app/CALLING_ON.dart';
import 'package:asset_app/DG.dart';
import 'package:asset_app/HG.dart';
import 'package:asset_app/HHG.dart';
import 'package:asset_app/RG.dart';
import 'package:asset_app/ROUTE.dart';
import 'package:asset_app/SHUNT.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
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
        home: Signal_Details(),
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

class Signal_Details extends StatefulWidget {
  @override
  _SignalState createState() => _SignalState();
}

class _SignalState extends State<Signal_Details> {
  final sectionController = TextEditingController();
  final stationController = TextEditingController();
  final signalnoController = TextEditingController();
  final signaltypeController = TextEditingController();
  final kmController = TextEditingController();
  final lhsrhsController = TextEditingController();
  final visiblereasonController = TextEditingController();
  final sodreasonController = TextEditingController();
  final anyreasonController = TextEditingController();
  final painteddateController = TextEditingController();
  final slnoController = TextEditingController();
  final makeController = TextEditingController();
  final typeController = TextEditingController();
  final dateofmanuController = TextEditingController();
  final dateofinstallationController = TextEditingController();
  final dateofjointController = TextEditingController();
  final inbetweenController = TextEditingController();
  final betweentracksController = TextEditingController();
  final inplatformController = TextEditingController();
  final outterController = TextEditingController();
  final outterrhController = TextEditingController();
  final infringeController = TextEditingController();

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
                    "Signal_Details",
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
                    controller: signalnoController,
                    decoration: InputDecoration(
                      labelText: 'Signal No',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      await checkIfSLNoExists(
                          signalnoController.text, stationController.text);
                      if (isDataExist) {
                        await retrieveDataFromFirestore(
                            signalnoController.text);
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
                    labelText: "Type of Signal",
                    options: [
                      'Select Option',
                      'Starter',
                      'LSS/Advance Started',
                      'Home',
                      'Distant',
                      'Double Distant',
                      'IBS',
                      'Gate Signal',
                      'Gate cum Signal',
                      'AUto Signal',
                      'Shunt Signal',
                      'SPI Signal'
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          signaltypeController.clear();
                        } else {
                          signaltypeController.text = newValue!;
                        }
                      });
                    },
                    controller: signaltypeController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: kmController,
                    decoration: InputDecoration(
                      labelText: "KM",
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "LHS/RHS",
                    options: ['Select Option', 'LHS', 'RHS'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          lhsrhsController.clear();
                        } else {
                          lhsrhsController.text = newValue!;
                        }
                      });
                    },
                    controller: lhsrhsController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  if (lhsrhsController.text == 'RHS') ...[
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Visibility'),
                    ),
                    TextField(
                      controller: visiblereasonController,
                      decoration: InputDecoration(
                        labelText: 'Enter the Reason',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                            color: const Color.fromARGB(209, 0, 0, 0)),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('SOD'),
                    ),
                    TextField(
                      controller: sodreasonController,
                      decoration: InputDecoration(
                        labelText: 'Enter the Reason',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                            color: const Color.fromARGB(209, 0, 0, 0)),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Any Other Reason'),
                    ),
                    TextField(
                      controller: anyreasonController,
                      decoration: InputDecoration(
                        labelText: 'Enter the Reason',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                            color: const Color.fromARGB(209, 0, 0, 0)),
                      ),
                    ),
                  ],
                  SizedBox(height: 10.0),
                  TextField(
                    controller: painteddateController,
                    decoration: InputDecoration(
                      labelText: 'Last Painted Date',
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
                        painteddateController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: dateofjointController,
                    decoration: InputDecoration(
                      labelText: 'Date of joint measurement with P.WAY',
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
                        dateofjointController.text = formattedDate;
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "In Between Tracks",
                    options: ['Select Option', 'Yes', 'No'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          inbetweenController.clear();
                        } else {
                          inbetweenController.text = newValue!;
                        }
                      });
                    },
                    controller: inbetweenController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  if (inbetweenController == 'Yes') ...[
                    SizedBox(height: 10.0),
                    TextField(
                      controller: betweentracksController,
                      decoration: InputDecoration(
                        labelText:
                            "If in between Tracks Inter distance between Track Centers",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                            color: const Color.fromARGB(209, 0, 0, 0)),
                      ),
                    ),
                  ],
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "Whether Situated on Platform",
                    options: ['Select Option', 'Yes', 'No'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          inplatformController.clear();
                        } else {
                          inplatformController.text = newValue!;
                        }
                      });
                    },
                    controller: inplatformController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: outterController,
                    decoration: InputDecoration(
                      labelText:
                          "Outter most protruding part of the Gear to the Centre Line of Track (LH)",
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: outterrhController,
                    decoration: InputDecoration(
                      labelText:
                          "Outter most protruding part of the Gear to the Centre Line of Track (RH)",
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFieldWithOptions(
                    labelText: "if infringing Whether Signal ladder blank done",
                    options: ['Select Option', 'Yes', 'No'],
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Select Option') {
                          infringeController.clear();
                        } else {
                          infringeController.text = newValue!;
                        }
                      });
                    },
                    controller: infringeController,
                    setTextFieldWithOptionsState: (state) {
                      _textFieldWithOptionsState = state;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Shunt_Details()),
                          );
                        },
                        child: CustomCard(
                          title: 'Shunt Details',
                          subtitle: 'Shunt Details',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => A_Marker_Details()),
                          );
                        },
                        child: CustomCard(
                          title: 'A Marker',
                          subtitle: 'Details about A Marker',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Route_Details()),
                          );
                        },
                        child: CustomCard(
                          title: 'Route',
                          subtitle: 'Route Details',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Calling_on_Details()),
                          );
                        },
                        child: CustomCard(
                          title: 'Calling on',
                          subtitle: 'Calling on Details',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RG_Details()),
                          );
                        },
                        child: CustomCard(
                          title: 'RG Details',
                          subtitle: 'Details about RG',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HG_Details()),
                          );
                        },
                        child: CustomCard(
                          title: 'HG Details',
                          subtitle: 'Details about HG',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HHG_Details()),
                          );
                        },
                        child: CustomCard(
                          title: 'HHG Details',
                          subtitle: 'Details about HHG',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DG_Details()),
                          );
                        },
                        child: CustomCard(
                          title: 'DG Details',
                          subtitle: 'Details about DG',
                        ),
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
      await FirebaseFirestore.instance.collection('Signal_Details').add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Signal No': signalnoController.text,
        "Signal Type": signaltypeController.text,
        'KM': kmController.text,
        'LHS/RHS': lhsrhsController.text,
        'Visible Reason': visiblereasonController.text,
        'SOD Reason': sodreasonController.text,
        'Any Other Reason': anyreasonController.text,
        'Last Painted Date': painteddateController.text,
        'Date of joint measurement with P.WAY': dateofjointController.text,
        "In Between Tracks": inbetweenController.text,
        'If in between Tracks Inter distance between Track Centers':
            betweentracksController.text,
        'Whether Situated on Platform': inplatformController.text,
        'Outter most protruding part of the Gear to the Centre Line of Track (LH)':
            outterController.text,
        'Outter most protruding part of the Gear to the Centre Line of Track (RH)':
            outterrhController.text,
        'if infringing Whether Signal ladder blank done':
            infringeController.text,
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
          FirebaseFirestore.instance.collection('Signal_Details');

      DocumentReference newDocRef = await collectionRef.add({
        'pfNumber':
            Provider.of<PFNumberProvider>(context, listen: false).pfNumber,
        'section': sectionController.text,
        'station': stationController.text,
        'Signal No': signalnoController.text,
        "Signal Type": signaltypeController.text,
        'KM': kmController.text,
        'LHS/RHS': lhsrhsController.text,
        'Visible Reason': visiblereasonController.text,
        'SOD Reason': sodreasonController.text,
        'Any Other Reason': anyreasonController.text,
        'Last Painted Date': painteddateController.text,
        'Date of joint measurement with P.WAY': dateofjointController.text,
        "In Between Tracks": inbetweenController.text,
        'If in between Tracks Inter distance between Track Centers':
            betweentracksController.text,
        'Whether Situated on Platform': inplatformController.text,
        'Outter most protruding part of the Gear to the Centre Line of Track (LH)':
            outterController.text,
        'Outter most protruding part of the Gear to the Centre Line of Track (RH)':
            outterrhController.text,
        'if infringing Whether Signal ladder blank done':
            infringeController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      clearTextFields();

      QuerySnapshot querySnapshot = await collectionRef
          .where('Signal No', isEqualTo: signalnoController.text)
          .get();

      querySnapshot.docs.forEach((doc) {
        if (doc.reference == newDocRef) {
          var data = doc.data() as Map<String, dynamic>;

          setState(() {
            sectionController.text = data['section'] ?? '';
            stationController.text = data['station'] ?? '';
            signalnoController.text = data['Signal No'] ?? '';
            signaltypeController.text = data["Signal Type"] ?? '';
            kmController.text = data['KM'] ?? '';
            lhsrhsController.text = data['LHS/RHS'] ?? '';
            painteddateController.text = data['Last Painted Date'] ?? '';
            visiblereasonController.text = data['Visble Reason'] ?? '';
            sodreasonController.text = data['SOD Reason'] ?? '';
            anyreasonController.text = data['Any Other Reason'] ?? '';
            sectionController.text = data['section'] ?? '';
            stationController.text = data['station'] ?? '';
            dateofjointController.text =
                data['Date of joint measurement with P.WAY'] ?? '';
            inbetweenController.text = data["In Between Tracks"] ?? '';
            betweentracksController.text = data[
                    'If in between Tracks Inter distance between Track Centers'] ??
                '';
            inplatformController.text =
                data['Whether Situated on Platform'] ?? '';
            outterrhController.text = data[
                    'Outter most protruding part of the Gear to the Centre Line of Track (RH)'] ??
                '';
            outterController.text = data[
                    'Outter most protruding part of the Gear to the Centre Line of Track (LH)'] ??
                '';
            infringeController.text =
                data['if infringing Whether Signal ladder blank done'] ?? '';
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
          .collection('Signal_Details')
          .where('Signal No', isEqualTo: signalnoController.text)
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
          .collection('Signal_Details')
          .where('station', isEqualTo: station)
          .where('Signal No', isEqualTo: slNo)
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
          .collection('Signal_Details')
          .where('Signal No', isEqualTo: slNo)
          .orderBy('updatedAt', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          sectionController.text = data['section'] ?? '';
          stationController.text = data['station'] ?? '';
          signalnoController.text = data['Signal No'] ?? '';
          signaltypeController.text = data["Signal Type"] ?? '';
          kmController.text = data['KM'] ?? '';
          lhsrhsController.text = data['LHS/RHS'] ?? '';
          painteddateController.text = data['Last Painted Date'] ?? '';
          visiblereasonController.text = data['Visble Reason'] ?? '';
          sodreasonController.text = data['SOD Reason'] ?? '';
          anyreasonController.text = data['Any Other Reason'] ?? '';
          sectionController.text = data['section (A Marker)'] ?? '';
          stationController.text = data['station (A Marker)'] ?? '';
          slnoController.text = data['slno (A Marker)'] ?? '';
          typeController.text = data["Type (A Marker)"] ?? '';
          makeController.text = data['make (A Marker)'] ?? '';
          sectionController.text = data['section'] ?? '';
          stationController.text = data['station'] ?? '';
          dateofjointController.text =
              data['Date of joint measurement with P.WAY'] ?? '';
          inbetweenController.text = data["In Between Tracks"] ?? '';
          betweentracksController.text = data[
                  'If in between Tracks Inter distance between Track Centers'] ??
              '';
          inplatformController.text =
              data['Whether Situated on Platform'] ?? '';
          outterrhController.text = data[
                  'Outter most protruding part of the Gear to the Centre Line of Track (RH)'] ??
              '';
          outterController.text = data[
                  'Outter most protruding part of the Gear to the Centre Line of Track (LH)'] ??
              '';
          infringeController.text =
              data['if infringing Whether Signal ladder blank done'] ?? '';
        });
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  void clearTextFields() {
    sectionController.clear();
    stationController.clear();
    signalnoController.clear();
    kmController.clear();
    lhsrhsController.clear();
    visiblereasonController.clear();
    painteddateController.clear();
    signaltypeController.clear();
    sodreasonController.clear();
    anyreasonController.clear();
    dateofjointController.clear();
    inbetweenController.clear();
    betweentracksController.clear();
    inplatformController.clear();
    outterController.clear();
    outterrhController.clear();
    infringeController.clear();

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
            SizedBox(height: 5),
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
