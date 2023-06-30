import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scan/controllers/employe_controller.dart';
import 'package:scan/models/employe_model.dart';
import 'package:scan/ui/pages/ajouter_ou_modifier_emp.dart';

class EmployePage extends StatelessWidget {
  final CollectionReference employe =
      FirebaseFirestore.instance.collection("employes");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/ajouter_ou_modifier_emp");
        },
        child: Icon(Icons.person_add),
      ),
      appBar: AppBar(title: Text('Employés')),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: StreamBuilder(
              stream: employe.snapshots(),
              builder: (context, AsyncSnapshot snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                }

                if (snapshots.hasData) {
                  return ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot records =
                            snapshots.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Slidable(
                            startActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    final employe = employe_model(
                                      id: records.id,
                                      nom: records["nom"],
                                      prenom: records["prenom"],
                                      email: records["email"],
                                    );
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                ManageEmploye(
                                                  employe: employe,
                                                  index: index,
                                                ))));
                                  },
                                  icon: Icons.edit_note,
                                  backgroundColor: Color(0xFF16a1b1),
                                ),
                              ], // children
                            ),
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    employe_controller().delete_employe(
                                        employe_model(id: records.id));
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: Color(0xFF16a1b1),
                                ),
                              ], // children
                            ),
                            child: ListTile(
                              tileColor: Colors.white70,
                              title: Text(records['nom']),
                              subtitle: Text(records['prenom']),
                              trailing: Text(records['email']),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DroitDAcces(records.id),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      });
                } // end if

                else {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                }

                // else
              },
            ),
          ),
        ] // children
            ),
      ),
    );
  } // widget
} //

class DroitDAcces extends StatelessWidget {
  final String itemId;
  DroitDAcces(this.itemId);
  final CollectionReference _employe =
  FirebaseFirestore.instance.collection('employes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      appBar: AppBar(
        title: Text('Droits d accés'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _employe.doc(itemId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }
          if (snapshot.hasData) {
            Map<String, dynamic>? itemData =
            snapshot.data!.data() as Map<String, dynamic>?;

            if (itemData != null && itemData.containsKey('email')) {
              employe_model EmpModel = employe_model(
                id: snapshot.data!.id,
                nom: itemData['nom'] as String,
                prenom: itemData['prenom'] as String,
                email: itemData['email'] as String,
              );

              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text('Prenom : ${EmpModel.prenom}'),
                      SizedBox(height: 10),
                      Text('Nom : ${EmpModel.nom}'),
                      SizedBox(height: 10),
                      Text('Email : ${EmpModel.email}'),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text('Champ nom non trouvé dans les données'),
              );
            }
          } else {
            return Center(
              child: Text('Erreur lors du chargement des données'),
            );
          }
        },
      ),
    );
  }
}
