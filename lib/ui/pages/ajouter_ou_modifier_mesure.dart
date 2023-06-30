import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scan/controllers/employe_controller.dart';
import 'package:scan/ui/pages/employe.page.dart';

import '../../components/mytextfeild.dart';
import '../../controllers/mesure_controller.dart';
import '../../models/employe_model.dart';
import '../../models/mesure_model.dart';
import 'HomeAdmin.dart';

class Managemesure extends StatefulWidget {
  final mesure_model? mesure;
  final index;
  const Managemesure({this.mesure, this.index});

  @override
  State<Managemesure> createState() => _ManageMesureState();
}

class _ManageMesureState extends State<Managemesure> {
  final TextEditingController id = TextEditingController();
  final TextEditingController code = TextEditingController();
  final TextEditingController longueur = TextEditingController();
  final TextEditingController largeur = TextEditingController();
  final TextEditingController type = TextEditingController();

  List<String> typeChoices = ['pantalon', 'jupe', 't-shirt', 'robe'];
  String? selectedType;

  bool iseditingmode = false;
  final _form_key = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.index != null) {
      iseditingmode = true;
      id.text = widget.mesure?.id ?? '';
      code.text = widget.mesure?.code ?? '';
      largeur.text = widget.mesure?.largeur ?? '';
      longueur.text = widget.mesure?.longueur ?? '';
      //type.text = widget.mesure?.type ?? '';
      selectedType = widget.mesure?.type ?? null; // Set the initial value
    } else {
      iseditingmode = false;
      selectedType = null;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      appBar: AppBar(
          title: iseditingmode == true
              ? Text("Modifier mesure")
              : Text("Ajouter mesure")),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: iseditingmode == true
                      ? const Text(
                          "Modifier mesure",
                          style: TextStyle(fontSize: 30),
                        )
                      : const Text(
                          "Ajouter mesure",
                          style: TextStyle(fontSize: 30),
                        ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: _form_key, // Ajout de la clé globale du formulaire
                    child: Column(
                      children: [
                        /* MytextField(
                          labeledtext: "Type" ,
                          hintedtext:  "Type",
                          mycontroller: type,),*/

                        const SizedBox(height: 28),
                        DropdownButtonFormField<String>(
                          value: selectedType,
                          items: typeChoices.map((String choice) {
                            return DropdownMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedType = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Sélectionner le type ',
                          ),
                        ),
                        const SizedBox(height: 28),
                        MytextField(
                          labeledtext: "Code",
                          hintedtext: "Code",
                          mycontroller: code,
                        ),
                        const SizedBox(height: 28),
                        MytextField(
                          labeledtext: "Largeur",
                          hintedtext: "Largeur",
                          mycontroller: largeur,
                        ),
                        const SizedBox(height: 28),
                        MytextField(
                            labeledtext: "Longueur",
                            hintedtext: "Longueur",
                            mycontroller: longueur),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                    onPressed: () {
                      if (_form_key.currentState!.validate()) {
                        _form_key.currentState!.save();

                        if (iseditingmode == true) {
                          mesure_controller().update_mesure(mesure_model(
                              id: id.text,
                              code: code.text,
                              type: selectedType,
                              largeur: largeur.text,
                              longueur: longueur.text));
                        } else {
                          mesure_controller().add_mesure(mesure_model(
                            code: code.text,
                            type: selectedType,
                            largeur: largeur.text,
                            longueur: longueur.text,
                          ));
                        }
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(150, 55), // Set the minimum width and height
                      // Other button styles if needed
                    ),
                    child: iseditingmode == true
                        ? Text(
                            "Modifier",
                            style: TextStyle(fontSize: 20),
                          )
                        : Text(
                            "Ajouter",
                            style: TextStyle(fontSize: 20),
                          ))
              ],
            ),
          ),
          const SizedBox(height: 1100),
          /* Positioned(
            bottom: 0,
            left: 0,
            child: ClipPath(
              clipper: DoubleCurvedClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 88,
                color: Color(0xFF16a1b1), // Replace with your desired color
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
