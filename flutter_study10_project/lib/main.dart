import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_study10_project/flutter_project.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlutterProject(),
      theme: ThemeData(
        primaryColorDark: Colors.blueGrey,
      ),
    );
  }
}





