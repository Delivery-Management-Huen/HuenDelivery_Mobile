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

  endDeliver() {}
}
