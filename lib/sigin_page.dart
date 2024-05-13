import 'package:asset_app/New_Registration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBQx2RstuydswMLoD00fkTHHCiUHdldAqQ',
      appId: '1:780979866129:web:63bdb92abddf68770e7fb0',
      messagingSenderId: '780979866129',
      projectId: 'asset-management-909aa',
      databaseURL: 'YOUR_DATABASE_URL',
      storageBucket: 'asset-management-909aa.appspot.com',
    ),
  );
  runApp(MaterialApp(
    home: LoginPage(),
  ));
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
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: pfnoController,
              decoration: InputDecoration(labelText: 'PF Number'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authenticateUser(context);
              },
              child: Text('Login'),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistrationDetails()),
                );
              },
              child: Text(
                'Click me to navigate',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration
                      .underline, // Optional: Adds underline to indicate it's clickable
                  color: Colors.black, // Set the text color to black
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void authenticateUser(BuildContext context) async {
    String pfNumber = pfnoController.text;
    String password = passwordController.text;

    bool isAuthenticated = await authenticate(pfNumber, password);

    if (isAuthenticated) {
      Map<String, dynamic>? userDetails = await getUserDetails(pfNumber);

      if (userDetails != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(userDetails),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error retrieving user details')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid PF number or password')),
      );
    }
  }

  Future<bool> authenticate(String pfNumber, String password) async {
    try {
      // Query Firestore to check if the provided PF number and password match
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Registration_Details')
          .where('PF Number', isEqualTo: pfNumber)
          .where('Password', isEqualTo: password)
          .limit(1)
          .get();

      // If any document is returned, authentication is successful
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error authenticating user: $e');
      return false; // Return false in case of any error
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String pfNumber) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Registration_Details')
          .doc(pfNumber)
          .get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving user details: $e');
      return null;
    }
  }
}

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> userDetails;

  ProfilePage(this.userDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PF Number: ${userDetails['pfNumber']}'),
            Text('Password: ${userDetails['password']}'),
            // Display other user details as needed
          ],
        ),
      ),
    );
  }
}
