import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:huen_delivery_mobile/exception/TokenException.dart';
import 'package:huen_delivery_mobile/exception/UnexpectedResult.dart';
import 'package:huen_delivery_mobile/models/delivery.dart';
import 'package:huen_delivery_mobile/network/delivery_network.dart';
import 'package:huen_delivery_mobile/network/upload_network.dart';
import 'package:huen_delivery_mobile/styles/palette.dart';

class EndDeliveryNotifier with ChangeNotifier {
  DeliveryNetwork _deliveryNetwork = new DeliveryNetwork();
  UploadNetwork _uploadNetwork = new UploadNetwork();

  Delivery _delivery;
  File _image;

  setDelivery(Delivery delivery) {
    _delivery = delivery;
    notifyListeners();
  }

  Delivery getDelivery() {
    return _delivery;
  }

  setImage(File image) {
    this._image = image;
  }

  Future<void> endDelivery() async {
    String fileName = '';
    try {
      final res = await _uploadNetwork.upload(_image);
      fileName = jsonDecode(res.body)['data']['file']['filename'];
    } catch (err) { }

    final res = await _deliveryNetwork.endDelivery(_delivery.idx, fileName);

    if (res.statusCode == 200) {
      return;
    }

    switch (res.statusCode) {
      case 401:
      case 403:
      case 400:
      case 410:
        throw new TokenException('세션 만료');
        
      case 404:
        throw UnexpectedResult('취소된 배송입니다');

      case 409:
        throw UnexpectedResult('이미 완료된 배송입니다');

      default:
        throw UnexpectedResult('다시 시도해주세요');
    }
  }
}
