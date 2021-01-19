import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huen_delivery_mobile/exception/TokenException.dart';
import 'package:huen_delivery_mobile/exception/UnexpectedResult.dart';
import 'package:huen_delivery_mobile/models/delivery.dart';
import 'package:huen_delivery_mobile/network/delivery_network.dart';
import 'package:huen_delivery_mobile/notifiers/deliveries_notifier.dart';
import 'package:huen_delivery_mobile/util/token.dart';

class DeliveryViewModel {
  DeliveryNetwork _deliveryNetwork;
  DeliveriesNotifier _deliveriesNotifier;

  DeliveryViewModel() {
    this._deliveryNetwork = new DeliveryNetwork();
    this._deliveriesNotifier = new DeliveriesNotifier();
  }

  Delivery _delivery;

  setDelivery(Delivery delivery) {
    _delivery = delivery;
  }

  Delivery get delivery => _delivery;

  Future<Delivery> startDelivery() async {
    Position position = await getCurrentPosition();

    LatLng location = LatLng(position.latitude, position.longitude);
    final res = await _deliveryNetwork.startDelivery(_delivery.idx, location);

    switch (res.statusCode) {
      case 200:
        delivery.startTime = DateTime.now().toString();
        return delivery;

      case 400:
        throw UnexpectedResult('이미 출발한 배송입니다');

      case 401:
      case 403:
      case 410:
        removeToken();
        throw TokenException('다시 로그인 해주세요');

      default:
        throw UnexpectedResult('서버 오류가 발생했습니다');
    }
  }

  endDeliver() {}
}
