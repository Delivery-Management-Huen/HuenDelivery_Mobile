import 'package:flutter/cupertino.dart';
import 'package:huen_delivery_mobile/models/Delivery.dart';
import 'package:huen_delivery_mobile/network/DeliveryNetwork.dart';

class DeliveriesNotifier with ChangeNotifier {
  DeliveryNetwork _deliveryNetwork = new DeliveryNetwork();

  List<Delivery> _deliveries = [];

  void fetchDeliveries() {
    // this.setDeliveries(_deliveryNetwork.getDeliveries());
    _deliveries = [];
    _deliveries = _deliveryNetwork.getDeliveries();
    notifyListeners();
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
}
