import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/admin/admin_state.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) =>  AdminState(),
      builder: (context, _) => AdminScreen(),

    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(appBar: AppBar(title: Text("Admin"),),body: Text("Welcome to admin page"),),
    );
  }
}