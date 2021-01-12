import 'package:flutter/material.dart';
import 'package:huen_delivery_mobile/screens/main_screen.dart';
import 'package:huen_delivery_mobile/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      routes: {
        '/main': (context) => MainScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}

