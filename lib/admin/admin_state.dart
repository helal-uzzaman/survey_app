import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/admin/admin_authentication.dart';

// ui logic
class AdminState extends ChangeNotifier {
  AdminScreenState adminState = AdminScreenState.adminEmailPassword;

  AdminState() {
    myInit();
  }
  Future<void> myInit() async {
    await Firebase.initializeApp();
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        // adminState = AdminScreenState.adminLoggedIn;
      } else {
        adminState = AdminScreenState.adminEmailPassword;
      }
      notifyListeners();
    });
  }

  void signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
    void Function(Exception e) adminNotFound,
  ) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      var user = FirebaseAuth.instance.currentUser;
      var uid = user!.uid;
      adminValidation(uid);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    } on Exception catch (e) {
      adminNotFound(e);
    }
  }

  void adminValidation(String uid) async {
    var admin =
        await FirebaseFirestore.instance.collection("admin").doc(uid).get();
    if (!admin.exists) {
      throw Exception(
          "You can take survey only. Use your admin login credentials to log in here.");
    } else {
      adminState = AdminScreenState.adminLoggedIn;
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
