/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vfproj/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(MyApp());
}

class SignIn extends StatefulWidget {
  const SignIn({Key? key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final auth = FirebaseAuth.instance;

  var showPass = true;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF16a1b1),
        title: Center(
          child: Text(
            'Se Connecter',
            style: TextStyle(color: Color(0xFFF7F4E9)),
          ),
        ),
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Se connecter',
                  style: TextStyle(
                    letterSpacing: 2.5,
                    fontSize: 25.0,
                    color: Color(0xFF16a1b1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  //key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      TextFormField(
                        onChanged: (value) {
                          email = value;
                        },
                        //obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          hintText: 'Entrez votre E-mail',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color(0xFF5CA7BA),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color(0xFF2E8FA8),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Merci d'entrer votre E-mail";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                          hintText: 'Entrez votre mot de passe',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color(0xFF5CA7BA),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color(0xFF2E8FA8),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {}
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      var user = await auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        //Navigator.push( context,MaterialPageRout builder: (context) => home(),));
                      }
                    } catch (e) {
                      print(e);
                    }

                    //print(nom);
                    //print(prenom);
                    //print(email);
                    //print(password);
                    //print(password);
                  },
                  child: Text(
                    "Se Connecter",
                    style: TextStyle(
                      letterSpacing: 1.0,
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF16a1b1),
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scan/ui/pages/HomeAdmin.dart';
import '../../ui/pages/user_service.dart';

import '../ui/pages/HomeEmp.dart';
import 'admin_home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _uid = '';
  Color greenColor = const Color(0XFF006400);
  var showPass = true;
  late String email;
  late String password;
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  String? validateEmail(String value) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Email incorrect';
    }
    if (!regExp.hasMatch(value)) {
      return 'Email incorrect';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Se connecter',
                  style: TextStyle(
                    letterSpacing: 2.5,
                    fontSize: 25.0,
                    color: Color(0xFF16a1b1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                          onChanged: (value) {
                            emailcontroller.text = value;
                            emailcontroller.selection = TextSelection.collapsed(
                                offset: emailcontroller.text.length);
                          },
                          //obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            hintText: 'Entrez votre E-mail',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(0xFF5CA7BA),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(0xFF2E8FA8),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.red,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Merci d'entrer votre E-mail";
                            } else {
                              validateEmail(value);
                            }
                          }),
                      const SizedBox(height: 16),
                      TextFormField(
                        onChanged: (value) {
                          passwordcontroller.text = value;
                          passwordcontroller.selection =
                              TextSelection.collapsed(
                                  offset: passwordcontroller.text.length);
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                          hintText: 'Entrez votre mot de passe',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color(0xFF5CA7BA),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color(0xFF2E8FA8),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {}
                          return null;
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    SignInM(emailcontroller.text, passwordcontroller.text);

                    //print(nom);
                    //print(prenom);
                    //print(email);
                    //print(password);
                    //print(password);
                  },
                  child: Text(
                    "Se Connecter",
                    style: TextStyle(
                      letterSpacing: 1.0,
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF16a1b1),
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void SignInM(String email, String password) async {
    print("singInM");
    dynamic columnValue = false;
    final CollectionReference _employee =
        FirebaseFirestore.instance.collection('employes');
    print('email $email');
    print('password $password');

      try {

          //String uid = userCredential.user!.uid;
         QuerySnapshot querySnapshot = await _employee
              .where('email', isEqualTo: '$email')
              .where('password', isEqualTo: '$password')
              .get();
            QueryDocumentSnapshot firstDoc = querySnapshot.docs.first;
            String? uid = firstDoc.id;
            String nom = querySnapshot.docs.first.get('nom');
          if (querySnapshot.docs.isNotEmpty) {
             columnValue = querySnapshot.docs.first.get('role');

          }
          Fluttertoast.showToast(msg: "Login Successful");

          if (columnValue == true ) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeAdmin(userName: nom)));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeEmp(email: email)));
          }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(
              msg: "Informations d'identification non valides",
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              fontSize: 16.0,
              backgroundColor: greenColor);
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
              msg: 'mot de passe incorrect.',
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: greenColor);
        } else {
          Fluttertoast.showToast(
              msg: e.message.toString(),
              gravity: ToastGravity.TOP,
              backgroundColor: greenColor);
        }
      }

  }
}
