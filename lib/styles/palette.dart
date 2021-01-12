import 'dart:ui';

import 'package:flutter/material.dart';

class Palette {
  static Color blueF4F7FB = _hexToRGBOColor('F4F7FB');
  static Color blueE5E5E5 = _hexToRGBOColor('E5E5E5');
  static Color blueE2E8F1 = _hexToRGBOColor('E2E8F1');
  static Color blue6685A8 = _hexToRGBOColor('6685A8');
  static Color grayC4C4C4 = _hexToRGBOColor('C4C4C4');
  static Color grayF1F3F5 = _hexToRGBOColor('F1F3F5');
  static Color gray444444 = _hexToRGBOColor('444444');

  static Color _hexToRGBOColor(String hexCode) {
    String hexR = hexCode.substring(0, 2);
    String hexG = hexCode.substring(2, 4);
    String hexB = hexCode.substring(4, 6);

    int r = int.parse('0x$hexR');
    int g = int.parse('0x$hexG');
    int b = int.parse('0x$hexB');

    return Color.fromRGBO(r, g, b, 100);
  }
}