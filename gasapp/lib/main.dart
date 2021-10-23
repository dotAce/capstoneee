import 'package:flutter/material.dart';
import 'package:gasapp/src/Login_Page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "APP",
      debugShowCheckedModeBanner: false,
      home: loginPage(),
    );
  }
}
