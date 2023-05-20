import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../controllers/mesure_controller.dart';
import '../../models/mesure_model.dart';
import 'ajouter_ou_modifier_mesure.dart';

class Mesure extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/");
        },
        child: Icon(Icons.add_card) ,
      ),
      appBar: AppBar(title: Text('Mesures')),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: Text('Mesures des jupes',style: TextStyle(fontSize: 28),),
              leading: Icon(Icons.straighten,color: Colors.teal,size: 40),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              onTap: (){
                Navigator.pushNamed(context, "/mesureJupe");
              },
            ),


            ListTile(
              title: Text('Mesures des pantalons',style: TextStyle(fontSize: 28),),
              leading: Icon(Icons.straighten,color: Colors.teal,size: 40),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              onTap: (){
                Navigator.pushNamed(context, "/mesurePantalon");
              },
            ),

          ],
        ),
      ),
    );
  }
}


class MesureJupe extends StatelessWidget {
  //MesureJupe ({super.key}) ;

  final CollectionReference jupe = FirebaseFirestore.instance.collection("jupe");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/Managejupe");
        },
        child: Icon(Icons.add_card) ,
      ),

      appBar: AppBar(title: Text('Mesures')),
      body: SafeArea(

        child: Column(
            children: [

              Expanded(
                child: StreamBuilder(
                  stream: jupe.snapshots(),
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
                                        final jupe = jupe_model(
                                          id : records.id ,
                                          ref: records["ref"] ,
                                          longueur:  records["longueur"] ,
                                          largeur : records["largeur"] ,
                                        );
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    Managejupe(
                                                      jupe: jupe,
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
                                        jupe_controller().delete_jupe(jupe_model(id: records.id ));
                                      },
                                      icon: Icons.delete,
                                      backgroundColor: Colors.teal,
                                    ),
                                  ], // children
                                ),


                                child: ListTile(
                                  tileColor: Colors.white70,
                                  title: Text(records['ref'] ),
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





class MesurePantalon extends StatelessWidget {
  final CollectionReference pantalon = FirebaseFirestore.instance.collection("pantalon");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/Managepantalon");
        },
        child: Icon(Icons.add_card) ,
      ),

      appBar: AppBar(title: Text('Mesures')),
      body: SafeArea(

        child: Column(
            children: [

              Expanded(
                child: StreamBuilder(
                  stream: pantalon.snapshots(),
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
                                        final pantalon = pantalon_model(
                                          id : records.id ,
                                          ref: records["ref"] ,
                                          longueur:  records["longueur"] ,
                                          largeur : records["largeur"] ,
                                          tourDeTaille : records["tourDeTaille"] ,
                                        );
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    Managepantalon(
                                                      pantalon: pantalon,
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
                                        pantalon_controller().delete_pantalon(pantalon_model(id: records.id ));
                                      },
                                      icon: Icons.delete,
                                      backgroundColor: Colors.teal,
                                    ),
                                  ], // children
                                ),


                                child: ListTile(
                                  tileColor: Colors.white70,
                                  title: Text(records['ref'] ),

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




