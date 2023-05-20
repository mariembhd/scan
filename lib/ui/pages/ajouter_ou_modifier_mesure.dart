import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scan/controllers/employe_controller.dart';
import 'package:scan/ui/pages/employe.page.dart';

import '../../components/mytextfeild.dart';
import '../../controllers/mesure_controller.dart';
import '../../models/employe_model.dart';
import '../../models/mesure_model.dart';


class Managejupe extends StatefulWidget {
  final jupe_model? jupe ;
  final index ;
  const Managejupe({this.jupe, this.index});

  @override
  State<Managejupe> createState() =>  _ManagejupeState();
}


class Managepantalon extends StatefulWidget {
      final pantalon_model? pantalon ;
      final index ;
      const Managepantalon({this.pantalon, this.index});

     @override
     _ManagepantalonState createState() =>  _ManagepantalonState();
}




class _ManagejupeState extends State<Managejupe> {

  final TextEditingController id = TextEditingController();
  final TextEditingController ref = TextEditingController();
  final TextEditingController longueur = TextEditingController();
  final TextEditingController largeur = TextEditingController();
  bool  iseditingmode = false ;
  final _form_key = GlobalKey<FormState>();


  @override
  void initState(){
    if (widget.index != null){
      iseditingmode = true ;
      id.text = widget.jupe?.id ?? '';
      ref.text = widget.jupe?.ref ?? '';
      largeur.text = widget.jupe?.largeur ?? '';
      longueur.text = widget.jupe?.longueur ?? '';
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
              ? Text("Modifier jupe")
              : Text("Ajouter jupe")),

      body: SafeArea(
          child : SingleChildScrollView(
            child: Column(
              children :[
                const SizedBox(height: 40 ),
                Center(
                  child: iseditingmode == true ?
                  const Text("Modifier jupe", style: TextStyle(fontSize: 30),) :
                  const Text("Ajouter jupe", style: TextStyle(fontSize: 30) ,
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
                          labeledtext: "référence" ,
                          hintedtext:  "référence",
                          mycontroller: ref,),
                        const SizedBox(height: 24 ),

                        MytextField(
                          labeledtext: "largeur" ,
                          hintedtext:  "largeur",
                          mycontroller: largeur,),
                        const SizedBox(height: 24 ),


                        MytextField(
                            labeledtext: "longueur" ,
                            hintedtext:  "longueur",
                            mycontroller: longueur ),
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
                          jupe_controller().update_jupe(jupe_model(
                              id: id.text,
                              ref: ref.text,
                              largeur: largeur.text,
                              longueur: longueur.text));
                        }else {
                          jupe_controller().add_jupe(jupe_model(
                              ref: ref.text,
                              largeur: largeur.text,
                              longueur: longueur.text));
                        }
                      Navigator.pop(context);
                    }
                    },

                    child: iseditingmode == true ? Text("Modifier") : Text("Ajouter")

                )

              ],

            ),
          )),
    );

  }
}
class _ManagepantalonState extends State<Managepantalon> {

  final TextEditingController id = TextEditingController();
  final TextEditingController ref = TextEditingController();
  final TextEditingController longueur = TextEditingController();
  final TextEditingController largeur = TextEditingController();
  final TextEditingController tourDeTaille = TextEditingController();

  bool  iseditingmode = false ;
  final _form_key = GlobalKey<FormState>();


  @override
  void initState(){
    if (widget.index != null){
      iseditingmode = true ;
      id.text = widget.pantalon?.id ?? '';
      ref.text = widget.pantalon?.ref ?? '';
      largeur.text = widget.pantalon?.largeur ?? '';
      longueur.text = widget.pantalon?.longueur ?? '';
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
              ? Text("Modifier pantalon")
              : Text("Ajouter pantalon")),

      body: SafeArea(
          child : SingleChildScrollView(
            child: Column(
              children :[
                const SizedBox(height: 40 ),
                Center(
                  child: iseditingmode == true ?
                  const Text("Modifier pantalon", style: TextStyle(fontSize: 30),) :
                  const Text("Ajouter pantalon", style: TextStyle(fontSize: 30) ,
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
                          labeledtext: "référence" ,
                          hintedtext:  "référence",
                          mycontroller: ref,),
                        const SizedBox(height: 24 ),

                        MytextField(
                          labeledtext: "largeur" ,
                          hintedtext:  "largeur",
                          mycontroller: largeur,),
                        const SizedBox(height: 24 ),


                        MytextField(
                            labeledtext: "longueur" ,
                            hintedtext:  "longueur",
                            mycontroller: longueur ),
                        const SizedBox(height: 24 ),

                        MytextField(
                            labeledtext: "tour de taille" ,
                            hintedtext:  "tourDeTaille",
                            mycontroller: tourDeTaille ),
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
                          pantalon_controller().update_pantalon(pantalon_model(
                              id: id.text,
                              ref: ref.text,
                              largeur: largeur.text,
                              longueur: longueur.text,
                              tourDeTaille: tourDeTaille.text));
                        }else {
                          pantalon_controller().add_pantalon(pantalon_model(
                              ref: ref.text,
                              largeur: largeur.text,
                              longueur: longueur.text,
                              tourDeTaille: tourDeTaille.text));
                        }
                        Navigator.pop(context);
                      }
                    },

                    child: iseditingmode == true ? Text("Modifier") : Text("Ajouter")

                )

              ],

            ),
          )),
    );

  }
}



