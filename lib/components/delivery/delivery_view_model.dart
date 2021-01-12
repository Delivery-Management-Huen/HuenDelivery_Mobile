import 'package:huen_delivery_mobile/models/Delivery.dart';

class DeliveryViewModel {
  Delivery _delivery;

  setDelivery(Delivery delivery) {
    _delivery = delivery;
  }

  Delivery get delivery => _delivery;
}
