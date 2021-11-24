import 'package:flutter/material.dart';

import '../widget.dart';
import './admin_form.dart';

enum AdminScreenState {
  adminLoggedOut,
  adminEmailPassword,
  adminLoggedIn,
  detailPage,
}

class AdminAuthentication extends StatelessWidget {
  const AdminAuthentication({
    required this.adminScreenState,
    // required this.startLoginFlow,
    required this.signInWithEmailAndPassword,
    required this.signOut,
  });

  final AdminScreenState adminScreenState;
  // final String? email;
  // final String? password;
  // final void Function() startLoginFlow;

  final void Function(
    String email,
    String password,
    void Function(Exception e) signInError,
    void Function(Exception e) adminNotFound,
  ) signInWithEmailAndPassword;

  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    switch (adminScreenState) {
      case AdminScreenState.adminEmailPassword:
        return AdminForm(adminLogin: (email, password) {
          signInWithEmailAndPassword(
            email,
            password,
            (e) => _showErrorDialog(
                context,
                "Failed to sign in. Put valid credentials for admin log in.",
                e),
            (e) => _showErrorDialog(
                context,
                "Failed to sign in. You are not admin.",
                e),
          );
        });
      case AdminScreenState.adminLoggedIn:
        return Text("all survey will be show here.");

      default:
        return Row(
          children: const [
            Text("Internal error, this shouldn't happen..."),
          ],
        );
    }
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            StyledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }
}
