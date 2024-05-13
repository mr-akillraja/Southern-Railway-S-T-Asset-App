import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  runApp(MaterialApp(
    home: RegistrationDetails(),
  ));
}

class RegistrationDetails extends StatefulWidget {
  @override
  _RegistrationDetailsState createState() => _RegistrationDetailsState();
}

class _RegistrationDetailsState extends State<RegistrationDetails> {
  final pfnoController = TextEditingController();
  final passwdController = TextEditingController();
  bool isDataExist = false;

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
                    "New Registration Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: pfnoController,
                    decoration: InputDecoration(
                      labelText: 'PF Number',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
                    onChanged: (value) {
                      checkIfSLNoExists(value);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: passwdController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(209, 0, 0, 0)),
                    ),
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
      await FirebaseFirestore.instance.collection('Registration_Details').add({
        'PF Number': pfnoController.text,
        'Password': passwdController.text,
      });

      clearTextFields();
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  Future<void> updateDataInFirestore() async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('Registration_Details');

      DocumentReference newDocRef = await collectionRef.add({
        'PF Number': pfnoController.text,
        'Password': passwdController.text,
      });

      clearTextFields();

      QuerySnapshot querySnapshot = await collectionRef
          .where('PF Number', isEqualTo: pfnoController.text)
          .get();

      querySnapshot.docs.forEach((doc) {
        if (doc.reference == newDocRef) {
          var data = doc.data() as Map<String, dynamic>;

          setState(() {
            pfnoController.text = data['PF Number'] ?? '';
            passwdController.text = data['Password'] ?? '';
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
          .collection('Registration_Details')
          .where('PF Number', isEqualTo: pfnoController.text)
          .get();
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });

      clearTextFields();
    } catch (e) {
      print('Error deleting data: $e');
    }
  }

  Future<void> checkIfSLNoExists(String pfNo) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Registration_Details')
          .where('PF Number', isEqualTo: pfNo)
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
      print('Error checking PF number existence: $e');
    }
  }

  void clearTextFields() {
    pfnoController.clear();
    passwdController.clear();

    setState(() {
      isDataExist = false;
    });
  }
}
