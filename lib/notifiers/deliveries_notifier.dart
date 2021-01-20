import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:huen_delivery_mobile/exception/TokenException.dart';
import 'package:huen_delivery_mobile/exception/UnexpectedResult.dart';
import 'package:huen_delivery_mobile/models/delivery.dart';
import 'package:huen_delivery_mobile/network/delivery_network.dart';
import 'package:huen_delivery_mobile/third_party/google_third_party.dart';
import 'package:huen_delivery_mobile/util/token.dart';

class DeliveriesNotifier with ChangeNotifier {
  DeliveryNetwork _deliveryNetwork = new DeliveryNetwork();
  GoogleThirdParty _googleThirdParty = new GoogleThirdParty();

  List<Delivery> _deliveries = [];

  Future<void> fetchDeliveries() async {
    final res = await _deliveryNetwork.getDeliveries();

    if (res.statusCode == 200) {
      List jsonDeliveries = jsonDecode(res.body)['data']['deliveries'] as List;
      List deliveries =
          jsonDeliveries.map((e) => Delivery.fromJson(e)).toList();

      _deliveries = deliveries;
      notifyListeners();

      for (final delivery in _deliveries) {
        _googleThirdParty
            .convertAddress(delivery.customer.address)
            .then((addressPoint) {
          delivery.addressPoint = addressPoint;
          notifyListeners();
        });
      }

      return;
    }

    switch (res.statusCode) {
      case 400:
      case 401:
      case 403:
      case 410:
        await removeToken();
        throw TokenException('다시 로그인 해주세요');

      default:
        throw UnexpectedResult('서버 오류가 발생했습니다');
    }
  }

  List<Delivery> getDeliveries() {
    return _deliveries;
  }

  void setDeliveries(List<Delivery> deliveries) {
    _deliveries = deliveries;
    notifyListeners();
  }

  void addDelivery(Delivery delivery) {
    _deliveries.add(delivery);
    notifyListeners();
  }

  void removeDelivery(Delivery delivery) {
    int arrayIndex = _deliveries.indexWhere((e) => e.idx == delivery.idx);
    _deliveries.removeAt(arrayIndex);
    notifyListeners();
  }

  void updateDelivery(num idx, Delivery delivery) {
    int index = _deliveries.indexWhere((e) => e.idx == idx);
    _deliveries[index] = delivery;

    notifyListeners();
  }
}
