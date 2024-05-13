// Completed code with options,date,clearing,and retrieving the code..

import 'package:asset_app/AFTC_Track_Circuits.dart';
import 'package:asset_app/Axle_Counter.dart';
import 'package:asset_app/DC_Track_Circuits.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
        home: Track_Circuit_Details(),
      ),
    ),
  );
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

class Track_Circuit_Details extends StatefulWidget {
  @override
  _Track_Circuit_State createState() => _Track_Circuit_State();
}

class _Track_Circuit_State extends State<Track_Circuit_Details> {
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

  bool isDataExist = false;

  @override
  @override
  Widget build(BuildContext context) {
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
                    "Track_Circuit_Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2, // Adjust this value as needed

                          shrinkWrap: true,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DC_Track_Circuit_Details(),
                                  ),
                                );
                              },
                              child: CustomCard(
                                title: 'DC Track Circuits',
                                subtitle: 'DC Track Circuits Details',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AFTC_Details(),
                                  ),
                                );
                              },
                              child: CustomCard(
                                title: 'AFTC',
                                subtitle: 'AFTC Details',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Axle_Counter_Details(),
                                  ),
                                );
                              },
                              child: CustomCard(
                                title: 'Axle Counter',
                                subtitle: 'Axle Counter Details',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
