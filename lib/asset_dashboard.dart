// updated fully..screen adapative
// Update completely...
import 'package:asset_app/track_circuit.dart';
import 'package:flutter/material.dart';
import 'package:asset_app/Signal_Log.dart';
import 'PointDetails.dart';
import 'Block_Instrument.dart';
import 'Power_Supply.dart';
import 'Fire_Alarm.dart';
import 'Electronic_InterLocking.dart';
import 'LC_Gates.dart';
import 'Dataloggerr_RTU.dart';
import 'Earth_Leakage_Detector.dart';
import 'Relays.dart';
import 'package:firebase_core/firebase_core.dart';
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
        home: Dashboard_Details(),
      ),
    ),
  );
}

class Dashboard_Details extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? pfNumber = Provider.of<PFNumberProvider>(context).pfNumber;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main title

            Text(
              'Welcome To The Dashboard',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              '       PF Number: ${pfNumber ?? "No PF Number"}', // Add your additional text here
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        centerTitle: true, // Centers the title
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"), // Change image path
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            // Signal Details Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Signal_Details(),
                  ),
                );
              },
              child: CustomCard(
                title: 'Signal Details',
                subtitle: 'Details about signals',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Track_Circuit_Details(),
                  ),
                );
              },
              child: CustomCard(
                title: 'Track Circuit Details',
                subtitle: 'Details about Track Circuit',
              ),
            ),
            // Relays Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Relays(),
                  ),
                );
              },
              child: CustomCard(
                title: 'Relays',
                subtitle: 'Details about relays',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PointDetails(),
                  ),
                );
              },
              child: CustomCard(
                title: 'Point',
                subtitle: 'Details about Point',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PowerSupply_Details(),
                  ),
                );
              },
              child: CustomCard(
                title: 'Power Supply',
                subtitle: 'Details about Power Supply',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EarthLeakage(),
                  ),
                );
              },
              child: CustomCard(
                title: 'ELD,CABLE',
                subtitle: 'Details about ELD,CABLE',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LevelCrossing_Gates(),
                  ),
                );
              },
              child: CustomCard(
                title: 'LevelCrossing Gates',
                subtitle: 'Details about LevelCrossing Gates',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataLogger_RTU(),
                  ),
                );
              },
              child: CustomCard(
                title: 'DataLogger',
                subtitle: 'Details about DataLogger',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EarthLeakage_Details(),
                  ),
                );
              },
              child: CustomCard(
                title: 'Electronic InterLocking',
                subtitle: 'Details about Electronic InterLocking',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      title: "SPDS/TWS",
                    ),
                  ),
                );
              },
              child: CustomCard(
                title: 'SPAU/TWS Details',
                subtitle: 'Details about SPAU/TWS',
              ),
            ),

            // Block Instrument Details Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlockInstrument(),
                  ),
                );
              },
              child: CustomCard(
                title: 'Block Instrument Details',
                subtitle: 'Details about block instruments',
              ),
            ),
            // Fire Alarm Details Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FireAlarm(),
                  ),
                );
              },
              child: CustomCard(
                title: 'Fire Alarm Details',
                subtitle: 'Details about fire alarms',
              ),
            ),
          ],
        ),
      ),
    );
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
            SizedBox(height: 8),
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

class DetailPage extends StatelessWidget {
  final String title;

  DetailPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Details for $title'),
      ),
    );
  }
}
