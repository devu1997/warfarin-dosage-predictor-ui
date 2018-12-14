import 'package:flutter/material.dart';
import 'package:anticoagulant_predictor/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anticoagulant Predictor',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            buttonColor: Colors.blue[400],
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blue[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)
              ),
              padding: EdgeInsets.symmetric(vertical: 14.0),
              minWidth: double.infinity,
            ),
            textTheme: TextTheme(
              button: TextStyle(color: Colors.white),
            ),
        ),
        home: LoginPage());
  }
}