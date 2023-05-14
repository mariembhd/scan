import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scan/ui/pages/employe.page.dart';





class ajouterEmp extends StatelessWidget {


  final controllerNom = TextEditingController();
  final controllerPrenom = TextEditingController();
  final CollectionReference _employe = FirebaseFirestore.instance.collection('employes') ;
  /* await _employe.add({"nom": nom, "prenom": prenom});
     await _employe.update({"nom": nom, "prenom": prenom});
     await _employe.doc(employeId).delete();
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter employé')),
      body: ListView(
           padding : EdgeInsets.all(16),
           children : <Widget>[
             TextField(

                  controller: controllerNom,
                  decoration: InputDecoration (
                      labelText:'Nom' ,
                      border: OutlineInputBorder(),
                  ),
              ),

             const SizedBox(height: 24 ),

             TextField(
                 controller: controllerPrenom,
                 decoration: InputDecoration (
                       labelText:'Prenom' ,
                       border: OutlineInputBorder(),

                 ),
             ),
               const SizedBox(height: 24 ),

             TextField(
               decoration: InputDecoration (
                 labelText:'Departement' ,
                 border: OutlineInputBorder(),
               ),
             ),
             const SizedBox(height: 24 ),


             const SizedBox(height: 32),

               ElevatedButton(
                  child: Text('créer'),
                  onPressed: () {
                   /* final  newEmploye = Employe(
                      nom: controllerNom.text,
                      prenom: controllerPrenom.text,
                    );
                  createEmploye(newEmploye);*/
                  Navigator.pop(context);

                   },
               ),

      ]
      ),
    );
  }


  /*Future createEmploye(Employe newEmploye ) async {
    final docEmploye = FirebaseFirestore.instance.collection('employes').doc();
    newEmploye.id= docEmploye.id;
    final json = newEmploye.toJson();
    await docEmploye.set(json);

  }*/

}

/*class Employe {
  String nom;
  String prenom;
  String id;
  Employe({
    required this.nom,
    required this.prenom,
    this.id = '',
  });

  toJson() {}*/




