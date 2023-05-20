

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scan/models/mesure_model.dart';

final CollectionReference _pantalon =
FirebaseFirestore.instance.collection("pantalon");
final CollectionReference _jupe =FirebaseFirestore.instance.collection("jupe");

class pantalon_controller {
  // add data to firebase
  Future add_pantalon(pantalon_model pantalon) async {
    await  _pantalon.doc().set(pantalon.add_data());
  }
  // update data
  Future update_pantalon(pantalon_model pantalon) async {
    await  _pantalon.doc(pantalon.id).update(pantalon.add_data());
  }

  // delete data
  Future delete_pantalon(pantalon_model pantalon) async {
    await  _pantalon.doc(pantalon.id).delete();
  }
}

class jupe_controller {
  // add data to firebase
  Future add_jupe(jupe_model jupe) async {
    await  _jupe.doc().set(jupe.add_data());
  }
  // update data
  Future update_jupe(jupe_model jupe) async {
    await  _jupe.doc(jupe.id).update(jupe.add_data());
  }

  // delete data
  Future delete_jupe(jupe_model jupe) async {
    await  _jupe.doc(jupe.id).delete();
  }
}