import 'package:flutter/material.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
            child: ElevatedButton(
              child: const Text("Log in"),
              onPressed: () => {},
              autofocus: true,
            ),
          ),
        ),
      ),
    );
  }
}
