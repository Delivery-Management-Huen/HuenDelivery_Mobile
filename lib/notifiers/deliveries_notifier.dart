import 'package:flutter/cupertino.dart';
import 'package:huen_delivery_mobile/models/Delivery.dart';

class DeliveriesNotifier with ChangeNotifier {
  List<Delivery> _deliveries = [];

  List<Delivery> getDeliveries() {
    return _deliveries;
  }

  void setDeliveries(List<Delivery> deliveries) {
    _deliveries = deliveries;
    notifyListeners();
  }

  void addDelivery(Delivery  delivery) {
    _deliveries.add(delivery);
    notifyListeners();
  }
}