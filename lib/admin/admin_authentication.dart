import 'package:flutter/material.dart';
import 'package:survey_app/admin/detail_page.dart';
import 'package:survey_app/admin/survey_model.dart';

import '../widget.dart';
import './admin_form.dart';

enum AdminScreenState {
  adminLoggedOut,
  adminEmailPassword,
  authenticating,
  adminLoggedIn,
}

class AdminAuthentication extends StatelessWidget {
  AdminAuthentication({
    required this.adminScreenState,
    required this.signInWithEmailAndPassword,
    required this.authenticateAsAdmin,
    required this.surveyList,
    required this.signOut,
  });
  final void Function(
      void Function(
    Exception e,
  )) authenticateAsAdmin;

  final AdminScreenState adminScreenState;
  final void Function(
    String email,
    String password,
    void Function(Exception e) signInError,
  ) signInWithEmailAndPassword;
  final List<SurveyModel> surveyList;

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
              e,
            ),
          );
        });
      case AdminScreenState.adminLoggedIn:
        return ListView(
          children: [
            StyledButton(
              child: const Text("LOG OUT"),
              onPressed: signOut,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Number of Person Who Took the survey: ${surveyList.length}."),
            ),
            ...surveyList
                .map((e) => Card(
                      child: ListTile(
                        leading: Container(
                          child: const Icon(Icons.person),
                          decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 1.0, color: Colors.white24))),
                        ),
                        trailing: Icon(Icons.arrow_right_sharp),
                        title: Text(e.name),
                        subtitle: Text(e.email),
                        tileColor: Colors.blue[50],
                        dense: true,
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(e),
                            ),
                          )
                        },
                      ),
                    ))
                .toList(),
          ],
        );

      case AdminScreenState.authenticating:
        authenticateAsAdmin(
            (error) => _showErrorDialog(context, "Your are not Admin", error));
        return const Center(
          child:  CircularProgressIndicator(),
        );

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
