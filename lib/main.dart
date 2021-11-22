import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void init() async {
    var result = await Firebase.initializeApp();
    print(result);
  }

  Future<UserCredential> signIn(
    String email,
    String password,
  )
  // void Function(FirebaseAuthException e) errorCallBack)
  async {
    var user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return user;
  }
  Future<UserCredential> register(
    String email,
    String password,
  )
  // void Function(FirebaseAuthException e) errorCallBack)
  async {
    var user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Survey App",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Login Page"),
        ),
        body: Center(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    child: const Text("Initialize firebase"),
                    onPressed: () => {init()},
                    autofocus: true,
                  ),
                  ElevatedButton(
                    child: const Text("Log in"),
                    onPressed: () => {
                      register("helal@gmail.com", "helal@1234"),
                    },
                    autofocus: true,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
