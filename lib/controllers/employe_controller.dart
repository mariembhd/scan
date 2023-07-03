

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

  Future<bool> isEmailAvailable(String email) async {
    final querySnapshot = await _employes.where('email', isEqualTo: email).limit(1).get();
    return querySnapshot.docs.isEmpty;
  }
  bool isEmailValid(String email) {
    // Regular expression pattern for email validation
    RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.)+[a-zA-Z]{2,}$',
    );
    // Test the email against the regular expression
    print('Match $emailRegex.hasMatch(email)');
    return emailRegex.hasMatch(email);
  }

}