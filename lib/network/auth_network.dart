import 'package:http/http.dart' as http;
import 'package:huen_delivery_mobile/network/base_network.dart';

class AuthNetwork {
  Future<http.Response> login(String id, String pw) async {
    final res = await postNetwork('/auth/login/driver', {
      'id': id,
      'password': pw,
    });

    return res;
  }
}
