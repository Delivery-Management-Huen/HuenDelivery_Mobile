import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:huen_delivery_mobile/screens/camera_screen.dart';
import 'package:huen_delivery_mobile/screens/main_screen.dart';
import 'package:huen_delivery_mobile/screens/login_screen.dart';
import 'package:huen_delivery_mobile/util/token.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isTokenExist() ? MainScreenWrapper() : LoginScreen(),
      routes: {
        '/main': (context) => MainScreenWrapper(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
