import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scan/controllers/employe_controller.dart';
import 'package:scan/ui/pages/employe.page.dart';

import '../../components/mytextfeild.dart';
import '../../models/employe_model.dart';


class ManageEmploye extends StatefulWidget {
  final employe_model? employe ;
  final index ;
  const ManageEmploye({this.employe, this.index});

  @override
  State<ManageEmploye> createState() =>  _ManageEmployeState();
}

class _ManageEmployeState extends State<ManageEmploye> {

  final TextEditingController id = TextEditingController();
  final TextEditingController nom = TextEditingController();
  final TextEditingController prenom = TextEditingController();
  final TextEditingController departement = TextEditingController();
  bool  iseditingmode = false ;
  final _form_key = GlobalKey<FormState>();


  @override
  void initState(){
    if (widget.index != null){
      iseditingmode = true ;
      id.text = widget.employe?.id ?? '';
      nom.text = widget.employe?.nom ?? '';
      prenom.text = widget.employe?.prenom ?? '';
      departement.text = widget.employe?.departement ?? '';
    }
    else {
      iseditingmode = false ;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: iseditingmode == true
              ? Text("Modifier employé")
              : Text("Ajouter employé")),

      body: SafeArea(
          child : SingleChildScrollView(
            child: Column(
              children :[
                const SizedBox(height: 40 ),
                Center(
                  child: iseditingmode == true ?
                  const Text("Modifier employé", style: TextStyle(fontSize: 30),) :
                  const Text("Ajouter employé", style: TextStyle(fontSize: 30) ,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child : Form (
                    key: _form_key,  // Ajout de la clé globale du formulaire
                    child: Column(
                      children: [
                        MytextField(
                          labeledtext: "Nom" ,
                          hintedtext:  "Nom",
                          mycontroller: nom,),
                        const SizedBox(height: 24 ),

                        MytextField(
                          labeledtext: "Prénom" ,
                          hintedtext:  "Prénom",
                          mycontroller: prenom,),
                        const SizedBox(height: 24 ),


                        MytextField(
                            labeledtext: "Département" ,
                            hintedtext:  "departement",
                            mycontroller: departement ),
                        const SizedBox(height: 24 ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () {
                      if (_form_key.currentState!.validate()) {
                         _form_key.currentState!.save();

                        if (iseditingmode == true) {
                          employe_controller().update_employe(employe_model(
                              id: id.text,
                              nom: nom.text,
                              prenom: prenom.text,
                              departement: departement.text));
                        }else {
                          employe_controller().add_employe(employe_model(
                              nom: nom.text,
                              prenom: prenom.text,
                              departement: departement.text));
                        }
                      Navigator.pop(context);
                    }
                    },

                    child: iseditingmode == true ? Text("Modifier") : Text("Créer")

                )

              ],

            ),
          )),
    );

  }
}
