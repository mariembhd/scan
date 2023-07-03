import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  String uid;
  String email;
  String nom;
  String prenom;
  bool isLogin = false;

  UserModel({
    required this.uid,
    required this.email,
    required this.nom,
    required this.prenom,
  });
}
