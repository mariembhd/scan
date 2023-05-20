

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scan/models/employe_model.dart';

final CollectionReference _employes =FirebaseFirestore.instance.collection("employes");

class employe_controller {
 // add data to firebase
  Future add_employe(employe_model employe) async {
    await  _employes.doc().set(employe.add_data());
  }
  // update data
  Future update_employe(employe_model employe) async {
    await  _employes.doc(employe.id).update(employe.add_data());
  }

  // delete data
  Future delete_employe(employe_model employe) async {
     await  _employes.doc(employe.id).delete();
  }
}