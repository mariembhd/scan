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
      backgroundColor: Color(0xFFF7F4E9),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/Managemesure");
        },
        child: Icon(Icons.add_card),
      ),
      appBar: AppBar(title: Text('Mesures')),
      body: Center(
        child: Container(
          width: 300, // Set the desired width
          decoration: BoxDecoration(
            color: Color(0xFFF7F4E9), // Set the desired background color
            borderRadius:
                BorderRadius.circular(10), // Set the desired border radius
          ),
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              SizedBox(height: 100),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF16a1b1), // Set the desired background color
                  borderRadius: BorderRadius.circular(
                      10), // Set the desired border radius
                ),
                child: ListTile(
                  title: Text(
                    'Pantalon',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ), // Set the desired font color
                  ),
                  leading: Icon(
                    Icons.straighten,
                    color: Colors.white,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 50),
                  onTap: () {
                    Navigator.pushNamed(context, "/MesurePantalon");
                  },
                ),
              ),
              SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF16a1b1), // Set the desired background color
                  borderRadius: BorderRadius.circular(
                      10), // Set the desired border radius
                ),
                child: ListTile(
                  title: Text(
                    'Jupe',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ), // Set the desired font color
                  ),
                  leading: Icon(
                    Icons.straighten,
                    color: Colors.white,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 50),
                  onTap: () {
                    Navigator.pushNamed(context, "/MesureJupe");
                  },
                ),
              ),
              SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF16a1b1), // Set the desired background color
                  borderRadius: BorderRadius.circular(
                      10), // Set the desired border radius
                ),
                child: ListTile(
                  title: Text(
                    'T-shirt',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ), // Set the desired font color
                  ),
                  leading: Icon(
                    Icons.straighten,
                    color: Colors.white,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 50),
                  onTap: () {
                    Navigator.pushNamed(context, "/MesureTshirt");
                  },
                ),
              ),
              SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF16a1b1), // Set the desired background color
                  borderRadius: BorderRadius.circular(
                      10), // Set the desired border radius
                ),
                child: ListTile(
                  title: Text(
                    'Robe',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ), // Set the desired font color
                  ),
                  leading: Icon(
                    Icons.straighten,
                    color: Colors.white,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 50),
                  onTap: () {
                    Navigator.pushNamed(context, "/MesureRobe");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MesurePantalon extends StatelessWidget {
  final CollectionReference mesure =
  FirebaseFirestore.instance.collection("mesure");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/Managemesure");
        },
        child: Icon(Icons.add_card),
      ),
      appBar: AppBar(title: Text('Mesures')),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("mesure")
                  .where('type', isEqualTo: 'pantalon')
                  .snapshots(),
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
                                    final mesure = mesure_model(
                                      id: records.id,
                                      code: records["code"],
                                      type: records["type"],
                                      longueur: records["longueur"],
                                      largeur: records["largeur"],
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) => Managemesure(
                                          mesure: mesure,
                                          index: index,
                                        )),
                                      ),
                                    );
                                  },
                                  icon: Icons.edit_note,
                                  backgroundColor: Color(0xFF16a1b1),
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    mesure_controller().delete_mesure(
                                      mesure_model(id: records.id),
                                    );
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: Color(0xFF16a1b1),
                                ),
                              ],
                            ),
                            child: ListTile(
                              tileColor: Colors.white70,
                              title: Text(records['code']),

                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class MesureRobe extends StatelessWidget {
  final CollectionReference mesure =
  FirebaseFirestore.instance.collection("mesure");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/Managemesure");
        },
        child: Icon(Icons.add_card),
      ),
      appBar: AppBar(title: Text('Mesures')),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("mesure")
                  .where('type', isEqualTo: 'robe')
                  .snapshots(),
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
                                  final mesure = mesure_model(
                                    id: records.id,
                                    code: records["code"],
                                    type: records["type"],
                                    longueur: records["longueur"],
                                    largeur: records["largeur"],
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => Managemesure(
                                        mesure: mesure,
                                        index: index,
                                      )),
                                    ),
                                  );
                                },
                                icon: Icons.edit_note,
                                backgroundColor: Color(0xFF16a1b1),
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  mesure_controller().delete_mesure(
                                    mesure_model(id: records.id),
                                  );
                                },
                                icon: Icons.delete,
                                backgroundColor: Color(0xFF16a1b1),
                              ),
                            ],
                          ),
                          child: ListTile(
                            tileColor: Colors.white70,
                            title: Text(records['code']),

                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                }
              },
            ),
          ),
        ],
        ),
      ),
    );
  }
}



class MesureTshirt extends StatelessWidget {
  final CollectionReference mesure =
  FirebaseFirestore.instance.collection("mesure");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/Managemesure");
        },
        child: Icon(Icons.add_card),
      ),
      appBar: AppBar(title: Text('Mesures')),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("mesure")
                  .where('type', isEqualTo: 't-shirt')
                  .snapshots(),
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
                                  final mesure = mesure_model(
                                    id: records.id,
                                    code: records["code"],
                                    type: records["type"],
                                    longueur: records["longueur"],
                                    largeur: records["largeur"],
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => Managemesure(
                                        mesure: mesure,
                                        index: index,
                                      )),
                                    ),
                                  );
                                },
                                icon: Icons.edit_note,
                                backgroundColor: Color(0xFF16a1b1),
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  mesure_controller().delete_mesure(
                                    mesure_model(id: records.id),
                                  );
                                },
                                icon: Icons.delete,
                                backgroundColor: Color(0xFF16a1b1),
                              ),
                            ],
                          ),
                          child: ListTile(
                            tileColor: Colors.white70,
                            title: Text(records['code']),

                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                }
              },
            ),
          ),
        ],
        ),
      ),
    );
  }
}




class MesureJupe extends StatelessWidget {
  final CollectionReference mesure =
  FirebaseFirestore.instance.collection("mesure");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/Managemesure");
        },
        child: Icon(Icons.add_card),
      ),
      appBar: AppBar(title: Text('Mesures')),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("mesure")
                  .where('type', isEqualTo: 'jupe')
                  .snapshots(),
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
                                  final mesure = mesure_model(
                                    id: records.id,
                                    code: records["code"],
                                    type: records["type"],
                                    longueur: records["longueur"],
                                    largeur: records["largeur"],
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => Managemesure(
                                        mesure: mesure,
                                        index: index,
                                      )),
                                    ),
                                  );
                                },
                                icon: Icons.edit_note,
                                backgroundColor: Color(0xFF16a1b1),
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  mesure_controller().delete_mesure(
                                    mesure_model(id: records.id),
                                  );
                                },
                                icon: Icons.delete,
                                backgroundColor: Color(0xFF16a1b1),
                              ),
                            ],
                          ),
                          child: ListTile(
                            tileColor: Colors.white70,
                            title: Text(records['code']),

                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                }
              },
            ),
          ),
        ],
        ),
      ),
    );
  }
}
