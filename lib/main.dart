import 'package:flutter/material.dart';
import 'package:huen_delivery_mobile/notifiers/deliveries_notifier.dart';
import 'package:huen_delivery_mobile/screens/main_screen.dart';
import 'package:huen_delivery_mobile/screens/login_screen.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  LocalStorage storage = new LocalStorage('auth');

  @override
  Widget build(BuildContext context) {
    bool isTokenExist = storage.getItem('token') == null;



    return MaterialApp(
      home:  isTokenExist ? MainScreenWrapper() : LoginScreen(),
      routes: {
        '/main': (context) => MainScreenWrapper(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
