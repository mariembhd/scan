import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scan/controllers/employe_controller.dart';
import 'package:scan/models/employe_model.dart';
import 'package:scan/ui/pages/ajouter_ou_modifier_emp.dart';

class EmployePage extends StatelessWidget {

  final CollectionReference employe = FirebaseFirestore.instance.collection("employes");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/ajouter_ou_modifier_emp");
        },
           child: Icon(Icons.person) ,
      ),

      appBar: AppBar(title: Text('Employés')),
      body: SafeArea(

        child: Column(
          children: [

              Expanded(
              child: StreamBuilder(
                stream: employe.snapshots(),
                builder: (context, AsyncSnapshot snapshots){
                  if (snapshots.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(color: Colors.green,),
                    );
                  }

                  if (snapshots.hasData) {
                    return ListView.builder(
                        itemCount: snapshots.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot records = snapshots.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Slidable(
                              startActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      final employe = employe_model(
                                      id : records.id ,
                                      nom: records["nom"] ,
                                      prenom:  records["prenom"] ,
                                      email : records["email"] ,
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
                                    backgroundColor: Colors.teal,
                                  ),
                                ], // children
                              ),


                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      employe_controller().delete_employe(employe_model(id: records.id ));
                                    },
                                    icon: Icons.delete,
                                    backgroundColor: Colors.teal,
                                  ),
                                ], // children
                              ),


                              child: ListTile(
                                tileColor: Colors.white70,
                                title: Text(records['nom'] ),
                                subtitle: Text(records['prenom'] ),
                            //    trailing: Text(records['email']),
                              ),
                            ),
                          );
                        }
                    );
                  } // end if


                  else{
                    return Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  }// else

                },
              ),
            ),


          ] // children
          ),





        ),

    );


    } // widget
} //




