import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  return token;
}

Future<void> setToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token);
}

Future<void> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

