import 'package:huen_delivery_mobile/models/delivery.dart';
import 'package:huen_delivery_mobile/network/delivery_network.dart';

class DeliveryViewModel {
  DeliveryNetwork _deliveryNetwork;

  DeliveryViewModel() {
    this._deliveryNetwork = new DeliveryNetwork();
  }

  Delivery _delivery;

  setDelivery(Delivery delivery) {
    _delivery = delivery;
  }

  Delivery get delivery => _delivery;

  endDeliver() {}
}
