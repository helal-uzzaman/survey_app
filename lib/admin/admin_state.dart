import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/admin/admin_authentication.dart';
import 'package:survey_app/admin/survey_model.dart';

// ui logic
class AdminState extends ChangeNotifier {
  AdminScreenState adminState = AdminScreenState.authenticating;
  late StreamSubscription<QuerySnapshot> surveySubscription;
  List<SurveyModel> _surveyList = [];
  List<SurveyModel> get surveyList => _surveyList;

  AdminState() {
    myInit();
  }
  Future<void> myInit() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        adminState = AdminScreenState.authenticating;
        adminValidation(user.uid);
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
    if (admin.exists) {
      adminState = AdminScreenState.adminLoggedIn;
      getSurveyData();
    } else {
      adminState = AdminScreenState.adminEmailPassword;
      throw Exception(
          "You can take survey only. Use your admin login credentials to log in here.");
    }
    notifyListeners();
  }

  void adminValidationOverLoad() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var admin =
        await FirebaseFirestore.instance.collection("admin").doc(uid).get();
    if (!admin.exists) {
      adminState = AdminScreenState.adminEmailPassword;
      throw Exception(
          "You can take survey only. Use your admin login credentials to log in here.");
    } else {
      adminState = AdminScreenState.adminLoggedIn;
      getSurveyData();
      notifyListeners();
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void getSurveyData() async {
    surveySubscription = FirebaseFirestore.instance
        .collection('surveys')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      _surveyList = [];

      for (var document in snapshot.docs) {
        _surveyList.add(SurveyModel(
            name: document.data()['name'].toString(),
            email: document.data()['email'].toString(),
            questions: document.data()['questions'],
            answers: document.data()['answers']));
      }
      print("survey list: $_surveyList");
      notifyListeners();
    });
  }
}
