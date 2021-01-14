import 'package:huen_delivery_mobile/models/delivery.dart';

class DeliveryViewModel {
  Delivery _delivery;

  setDelivery(Delivery delivery) {
    _delivery = delivery;
  }

  Delivery get delivery => _delivery;
}
