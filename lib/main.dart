import 'package:asset_app/asset_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'New_Registration.dart';

// Define PFNumberProvider class
class PFNumberProvider extends ChangeNotifier {
  String? _pfNumber;

  String? get pfNumber => _pfNumber;

  void setPFNumber(String pfNumber) {
    _pfNumber = pfNumber;
    notifyListeners();
  }
}

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
      create: (context) =>
          PFNumberProvider(), // Provide PFNumberProvider instance
      child: MaterialApp(
        home: LoginPage(),
      ),
    ),
  );
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController pfnoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signal & Telecommunication (S&T) Department'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Image.asset(
                "images/logo1.jpeg",
                height: 100,
                width: 100,
                alignment: Alignment.center,
              ),
              SizedBox(height: 30),
              Center(
                child: Text(
                  'Signal & Telecommunication (S&T) Department Asset Management',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: pfnoController,
                decoration: InputDecoration(
                  labelText: 'PF Number',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold, // Set the label text to bold
                  ),
                  hintText: 'Enter your PF number',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold, // Set the hint text to bold
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold, // Set the label text to bold
                  ),
                  hintText: 'Enter your Password',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold, // Set the hint text to bold
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationDetails(),
                    ),
                  );
                },
                child: Text(
                  'New Registration',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  authenticateUser(context);
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void authenticateUser(BuildContext context) async {
    String pfNumber = pfnoController.text;
    String password = passwordController.text;

    bool isAuthenticated = await authenticate(pfNumber, password);

    if (isAuthenticated) {
      Provider.of<PFNumberProvider>(context, listen: false)
          .setPFNumber(pfNumber);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard_Details(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid PF number or password')),
      );
    }
  }

  Future<bool> authenticate(String pfNumber, String password) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Registration_Details')
          .where('PF Number', isEqualTo: pfNumber)
          .where('Password', isEqualTo: password)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error authenticating user: $e');
      return false;
    }
  }
}
