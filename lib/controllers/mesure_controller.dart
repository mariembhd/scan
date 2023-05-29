

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scan/models/mesure_model.dart';


final CollectionReference _mesure =FirebaseFirestore.instance.collection("mesure");



class mesure_controller {
  // add data to firebase
  Future add_mesure(mesure_model mesure) async {
    await  _mesure.doc().set(mesure.add_data());
  }
  // update data
  Future update_mesure(mesure_model mesure) async {
    await  _mesure.doc(mesure.id).update(mesure.add_data());
  }

  // delete data
  Future delete_mesure(mesure_model mesure) async {
    await  _mesure.doc(mesure.id).delete();
  }
}