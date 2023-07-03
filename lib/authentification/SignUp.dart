import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';
import '../components/mytextfeild.dart';
import '../controllers/employe_controller.dart';
import '../models/employe_model.dart';
import '../ui/pages/HomeEmp.dart';
import '../ui/pages/user_provider.dart';

import 'SelectLogin.dart';

class SignUp extends StatefulWidget {
  final employe_model? employe;

  SignUp({this.employe});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController id = TextEditingController();
  final TextEditingController nom = TextEditingController();
  final TextEditingController prenom = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final _form_key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.employe != null) {
      id.text = widget.employe!.id ?? '';
      nom.text = widget.employe!.nom ?? '';
      prenom.text = widget.employe!.prenom ?? '';
      email.text = widget.employe!.email ?? '';
      password.text = widget.employe!.password ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      appBar: AppBar(title: Text("Inscription")),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: const Text("Inscription", style: TextStyle(fontSize: 30)),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _form_key, // Ajout de la clé globale du formulaire
                child: Column(
                  children: [
                    MytextField(
                      labeledtext: "Nom",
                      hintedtext: "Nom",
                      mycontroller: nom,
                    ),
                    const SizedBox(height: 24),
                    MytextField(
                      labeledtext: "Prénom",
                      hintedtext: "Prénom",
                      mycontroller: prenom,
                    ),
                    const SizedBox(height: 24),
                    MytextField(
                        labeledtext: "Email",
                        hintedtext: "Email",
                        mycontroller: email),
                    const SizedBox(height: 24),
                    MytextField(
                        labeledtext: "Mot de passe",
                        hintedtext: "Mot de passe",
                        mycontroller: password),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: () async {
                  if(await employe_controller().isEmailValid(email.text)) {
                    final emailAvailable = await employe_controller()
                        .isEmailAvailable(email.text);
                    if (emailAvailable) {
                      employe_controller().add_employe(employe_model(
                        nom: nom.text,
                        prenom: prenom.text,
                        email: email.text,
                        password: password.text,
                      ));

                      Fluttertoast.showToast(
                      msg:"Bienvenu "+nom.text );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeEmp(email:email.text)),
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg: "Cet email est déjà utilisé.");
                    }
                  } else {
                       Fluttertoast.showToast(
                       msg: "Le email n'est pas correct.");
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(150, 55), // Set the minimum width and height
                  // Other button styles if needed
                ),
                child: Text(
                  "S'inscrire",
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      )),
    );
  }
}
