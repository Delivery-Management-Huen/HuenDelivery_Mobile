import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:huen_delivery_mobile/exception/UnexpectedResult.dart';
import 'package:huen_delivery_mobile/models/result_status.dart';
import 'package:huen_delivery_mobile/network/auth_network.dart';
import 'package:localstorage/localstorage.dart';

class LoginViewModel {
  final LocalStorage storage = new LocalStorage('auth');
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  AuthNetwork _authNetwork = AuthNetwork();

  Future<ResultStatus> login() async {
    String id = idController.text;
    String pw = pwController.text;

    try {
      final res = await _authNetwork.login(id, pw);

      switch (res.statusCode) {
        case 200:
          dynamic data = jsonDecode(res.body)['data'];
          storage.setItem('token', data['x-access-token']);

          return ResultStatus(res.statusCode, '로그인 성공', true);

        case 400:
          throw UnexpectedResult('아이디와 비밀번호를 입력해주세요');

        case 401:
          throw UnexpectedResult('아이디, 비밀번호를 확인해주세요');

        case 403:
          throw UnexpectedResult('배송기사만 접속할 수 있습니다');

        default:
          throw UnexpectedResult('다시 시도해주세요');
      }
    } catch (err) {
      if (err is UnexpectedResult) {
        throw err;
      }

      throw UnexpectedResult('다시 시도해주세요');
    }
  }

  disposeController() {
    idController.dispose();
    pwController.dispose();
  }
}
