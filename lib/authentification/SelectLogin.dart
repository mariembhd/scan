import '../../authentification/SignIn.dart';
import '../../authentification/SignUp.dart';
//import 'package:bienvenue/SelectLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';

//import 'package:flutter/src/widgets/placeholder.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(MyApp());
}

class SelectLogin extends StatefulWidget {
  const SelectLogin({Key? key}) : super(key: key);

  @override
  State<SelectLogin> createState() => _SelectLoginState();
}

class _SelectLoginState extends State<SelectLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUp(),
                  ),
                );
              },
              child: Text(
                "S'inscrire",
                style: TextStyle(
                  letterSpacing: 1.0,
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF16a1b1),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignIn(),
                  ),
                );
              },
              child: Text(
                'Se Connecter',
                style: TextStyle(
                  letterSpacing: 1.0,
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF16a1b1),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
