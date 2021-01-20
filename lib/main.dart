import 'package:flutter/material.dart';
import 'package:huen_delivery_mobile/screens/main_screen.dart';
import 'package:huen_delivery_mobile/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  Widget home = token == null ? LoginScreen() : MainScreenWrapper();
  runApp(MyApp(home));
}

class MyApp extends StatelessWidget {
  Widget _home;

  MyApp(this._home);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _home,
      routes: {
        '/main': (context) => MainScreenWrapper(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
