import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServicee extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // Firebase user one-time fetch
  User? get getUser => _auth.currentUser;
  // Firebase user a realtime stream
  Stream<User?> get user => _auth.authStateChanges();

  FutureOr<bool> isAdmin(String? uid) async {
    bool _isAdmin = false as bool;
    final User? user = _auth.currentUser;
    print('userService $uid');
    final DocumentSnapshot adminRef =
    await _db.collection('employes').doc(user?.uid).get();
    print('adminRef $adminRef.exists');
    if (adminRef.exists) {
      print('exists');
      _isAdmin = true as bool;
    }
    return _isAdmin;
  }

  CollectionReference db = FirebaseFirestore.instance.collection('admin');
  FutureOr<void> addAdminToken(Map<String, dynamic> data) async {
    final User? user = _auth.currentUser;
    db.doc(user?.uid).set(data);
  }
}
