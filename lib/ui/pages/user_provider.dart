// ignore_for_file: avoid_single_cascade_in_expression_statements, non_constant_identifier_names, avoid_print, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../models/user_model.dart';

class Userprovider with ChangeNotifier {
  void addUser({
    User? currentUser,
    String? userName,
    String? userEmail,
    String? userPrenom,
  }) async {
    await FirebaseFirestore.instance
        .collection('employes')
        .doc(currentUser!.uid)
        .set({
      "nom": userName,
      "prenom": userPrenom,
      "email": userEmail,
      "uid": currentUser.uid,
    });
  }

  UserModel? currentUser;
  Future<void> getUserDataFunction() async {
    UserModel userModel;
    var value = await FirebaseFirestore.instance
        .collection('employes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (value.exists) {
      userModel = UserModel(
        uid: value.get("uid"),
        email: value.get("email"),
        nom: value.get("nom"),
        prenom: value.get("prenom"),
      );
      currentUser = userModel;
      notifyListeners();
    }
  }

  UserModel? get getUserModel {
    return currentUser;
  }

  void updateUserName(
      String Username,
      ) async {
    FirebaseFirestore.instance
        .collection('employes')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "nom": Username,
    });
  }

  void changePassword(String yourPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    user?.updatePassword(yourPassword).then((_) {
      FirebaseFirestore.instance.collection("employes")
        ..doc(FirebaseAuth.instance.currentUser?.uid).update({
          "password": yourPassword,
        }).then((_) {
          // ignore: avoid_print
          print("Successfully changed password");
        });
    }).catchError((error) {
      print("Error " + error.toString());
    });
  }
}
