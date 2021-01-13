import 'package:flutter/cupertino.dart';
import 'package:huen_delivery_mobile/models/Delivery.dart';
import 'package:huen_delivery_mobile/network/DeliveryNetwork.dart';
import 'package:huen_delivery_mobile/third_party/google_third_party.dart';

class DeliveriesNotifier with ChangeNotifier {
  DeliveryNetwork _deliveryNetwork = new DeliveryNetwork();
  GoogleThirdParty _googleThirdParty = new GoogleThirdParty();

  List<Delivery> _deliveries = [];

  void fetchDeliveries() {
    _deliveries = [];
    _deliveryNetwork.getDeliveries()
    .then((deliveries) => {
      _deliveries = deliveries,
      notifyListeners(),

      for (final delivery in _deliveries) {
        _googleThirdParty.convertAddress(delivery.address)
        .then((addressPoint) => {
          delivery.addressPoint = addressPoint,
          notifyListeners(),
        })
      }
    });

    // _deliveries
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
