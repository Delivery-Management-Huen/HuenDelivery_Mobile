import 'package:localstorage/localstorage.dart';

String getToken() {
  LocalStorage storage = new LocalStorage('auth');
  return storage.getItem('token');
}

void setToken(String token) {
  LocalStorage storage = new LocalStorage('auth');
  storage.setItem('token', token);
}

void removeToken() {
  LocalStorage storage = new LocalStorage('auth');
  storage.deleteItem('token');
}

bool isTokenExist() {
  String token = getToken();
  if (token == null) {
    return false;
  }

  return true;
}
