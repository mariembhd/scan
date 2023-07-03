import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
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
                                    builder: (context) => DroitDAcces(
                                        records.id,
                                        employe_model(
                                          id: records.id,
                                          nom: records["nom"],
                                          prenom: records["prenom"],
                                          email: records["email"],
                                        )),
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

class DroitDAcces extends StatefulWidget {
  final String itemId;
  final employe_model? employe;

  DroitDAcces(this.itemId, this.employe);

  @override
  _DroitDAccesState createState() => _DroitDAccesState();
}

class _DroitDAccesState extends State<DroitDAcces> {
  final CollectionReference _employe =
      FirebaseFirestore.instance.collection('employes');

  bool RcanAccessScan = false;
  bool RcanAccessStatistics = false;
  bool RcanAccessGallery = false;
  SharedPreferences? preferences;

  final _form_key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchEmployeValues();
  }

  void fetchEmployeValues() async {
    DocumentSnapshot snapshot = await _employe.doc(widget.itemId).get();
    if (snapshot.exists) {
      Map<String, dynamic> itemData = snapshot.data() as Map<String, dynamic>;
      setState(() {
        RcanAccessGallery = itemData['canAccessGallery'] ?? false;
        RcanAccessStatistics = itemData['canAccessStatistics'] ?? false;
        RcanAccessScan = itemData['canAccessScan'] ?? false;
      });
    }
  }
  void saveEmployeValues() async {
    String employeId = widget.itemId;

    await _employe.doc(employeId).update({
      'canAccessGallery': RcanAccessGallery,
      'canAccessStatistics': RcanAccessStatistics,
      'canAccessScan': RcanAccessScan,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Enregistrement effectué')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      appBar: AppBar(
        title: Text('Droits d accès'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _employe.doc(widget.itemId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }
          if (snapshot.hasData) {
            Map<String, dynamic>? itemData =
                snapshot.data!.data() as Map<String, dynamic>?;

            if (itemData != null) {
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
                  child: Form(
                    key: _form_key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Prénom : ${EmpModel.prenom}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Nom : ${EmpModel.nom}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Email : ${EmpModel.email}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        CheckboxListTile(
                          title: Text('Accès à la Scan'),
                          value: RcanAccessScan,
                          onChanged: (value) {
                            setState(() {
                              RcanAccessScan = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Accès à la galerie'),
                          value: RcanAccessGallery,
                          onChanged: (value) {
                            setState(() {
                              RcanAccessGallery = value!;
                            });
                          },
                        ),

                        CheckboxListTile(
                          title: Text('Accès aux statistiques'),
                          value: RcanAccessStatistics,
                          onChanged: (value) {
                            setState(() {
                              RcanAccessStatistics = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              saveEmployeValues();
                              Navigator.pop(context);
                            },

                            child: Text("Enregistrer"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: Text('Champ non trouvé dans les données'),
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
