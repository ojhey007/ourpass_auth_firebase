import 'package:flutter/material.dart';
import 'package:ourpass/screens/login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ourpass Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: LoginPage(
        title: 'Ourpass Firebase Auth',
      ),
    );
  }
}
