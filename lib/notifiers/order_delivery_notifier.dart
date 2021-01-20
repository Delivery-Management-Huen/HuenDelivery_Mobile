import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:huen_delivery_mobile/exception/TokenException.dart';
import 'package:huen_delivery_mobile/exception/UnexpectedResult.dart';
import 'package:huen_delivery_mobile/models/delivery.dart';
import 'package:huen_delivery_mobile/network/delivery_network.dart';
import 'package:huen_delivery_mobile/util/token.dart';

class OrderDeliveryNotifier with ChangeNotifier {
  DeliveryNetwork _deliveryNetwork;

  OrderDeliveryNotifier() {
    _deliveryNetwork = DeliveryNetwork();
  }

  List<Delivery> _deliveries = [];

  void reorderData(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final items = _deliveries.removeAt(oldIndex);
    _deliveries.insert(newIndex, items);

    notifyListeners();
  }

  List<Delivery> getDeliveries() {
    return _deliveries;
  }

  setDeliveries(List<Delivery> deliveries) {
    this._deliveries = deliveries;
    notifyListeners();
  }

  fetchDeliveries() async {
    final res = await _deliveryNetwork.getCompletedDeliveries();

    if (res.statusCode == 200) {
      List jsonDeliveries = jsonDecode(res.body)['data']['deliveries'] as List;
      List deliveries =
          jsonDeliveries.map((e) => Delivery.fromJson(e)).toList();

      _deliveries = deliveries;
      notifyListeners();

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

  Future<void> updateOrder() async {
    List orders = [];

    for (int i = 0; i < _deliveries.length; i += 1) {
      orders.add({
        'deliveryIdx': _deliveries[i].idx,
        'endOrderNumber': i + 1,
      });
    }

    final res = await _deliveryNetwork.reorderDeliveries(orders);

    if (res.statusCode == 200) {
      return;
    }

    switch (res.statusCode) {
      case 401:
      case 403:
      case 410:
        await removeToken();
        throw TokenException('다시 로그인 해주세요');

      default:
        throw UnexpectedResult('새로고침 후 다시 시도해주세요');
    }
  }
}
