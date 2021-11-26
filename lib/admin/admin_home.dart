import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/admin/admin_authentication.dart';
import 'package:survey_app/admin/admin_state.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminState(),
      builder: (context, _) => AdminScreen(),
    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
      ),
      body: Consumer<AdminState>(
        builder: (context, adstate, _) => AdminAuthentication(
          adminScreenState: adstate.adminState,
          signInWithEmailAndPassword: adstate.signInWithEmailAndPassword,
          authenticateAsAdmin: adstate.adminValidationOverLoad,
          surveyList: adstate.surveyList,
          signOut: adstate.signOut,
        ),
      ),
    );
  }
}
