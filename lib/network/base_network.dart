import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:huen_delivery_mobile/config/config.dart';

Future<http.Response> getNetwork(String url, {String token = ''}) async {
  Map<String, String> headers = {};

  if (token.length > 0) {
    headers['x-access-token'] = token;
  }

  return http.get('$END_POINT$url', headers: headers);
}

Future<http.Response> postNetwork(String url, dynamic body, {String token = ''}) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  if (token.length > 0) {
    headers['x-access-token'] = token;
  }

  return http.post('$END_POINT$url', headers: headers, body: jsonEncode(body));
}
