import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huen_delivery_mobile/components/login/login_view_model.dart';
import 'package:huen_delivery_mobile/styles/palette.dart';
import 'package:huen_delivery_mobile/util/dialog.dart';

class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginViewModel _loginViewModel;

  _LoginViewState() {
    _loginViewModel = new LoginViewModel();
  }

  @override
  void dispose() {
    _loginViewModel.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Container(
      width: deviceSize.width,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('images/huen-logo.png'),
            width: 100,
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            width: deviceSize.width * 0.9,
            child: Column(
              children: [
                TextField(
                  controller: _loginViewModel.idController,
                  style: TextStyle(
                    fontSize: 12,
                    height: 0.5,
                    color: Palette.gray444444,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Palette.grayFAFAFA,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Palette.grayDCDCDC),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    labelText: '아이디',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _loginViewModel.pwController,
                  obscureText: true,
                  style: TextStyle(
                    fontSize: 12,
                    height: 0.5,
                    color: Palette.gray444444,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Palette.grayFAFAFA,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Palette.grayDCDCDC),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    labelText: '비밀번호',
                  ),
                ),
                SizedBox(height: 30),
                ButtonTheme(
                  minWidth: deviceSize.width * 0.9,
                  height: 50,
                  child: RaisedButton(
                      color: Palette.gray444444,
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _loginViewModel
                            .login()
                            .then((value) =>
                                Navigator.pushNamed(context, '/main'))
                            .catchError((error) => showCustomDialog(
                                context, '로그인 실패', error.toString()));
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
