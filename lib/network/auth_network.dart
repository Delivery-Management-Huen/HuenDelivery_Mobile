import 'package:http/http.dart' as http;
import 'package:huen_delivery_mobile/config/config.dart';

class AuthNetwork {
  Future<http.Response> login(String id, String pw) async {
    var res = await http.post('$END_POINT/auth/login/driver', body: {
      'id': id,
      'password': pw,
    });

    return res;
  }
}
