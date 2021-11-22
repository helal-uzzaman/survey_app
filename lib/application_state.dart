import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './authentication.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationLoginState loginState = ApplicationLoginState.loggedOut;

  // user input variables
  String? _email;
  String? get email => _email;

  ApplicationState() {
    myInit();
  }
  Future<void> myInit() async {
    FirebaseApp firebaseInit = await Firebase.initializeApp();
    print("Firebase init fun call => $firebaseInit");

    FirebaseAuth.instance.userChanges().listen(
      (user) {
        if (user != null) {
          loginState = ApplicationLoginState.loggedIn;
          print("User logged in: User = $user");
        } else {
          loginState = ApplicationLoginState.loggedOut;
          print("User logged out");
        }
        notifyListeners();
      },
    );
  }

  void startLoginFlow() {
    loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains("password")) {
        loginState = ApplicationLoginState.password;
      } else {
        loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    loginState = ApplicationLoginState.loggedOut;
    notifyListeners();
  }

  void registerAccount(
    String email,
    String displayName,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // servey related methods

  void startSurvey() {
    loginState = ApplicationLoginState.inSurvey;
    notifyListeners();
  }
}
