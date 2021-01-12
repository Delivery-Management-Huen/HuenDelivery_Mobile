import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huen_delivery_mobile/styles/palette.dart';

class LoginView extends StatelessWidget {
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
                    onPressed: () => Navigator.pushNamed(context, '/main'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
