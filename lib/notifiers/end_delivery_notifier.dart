import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:huen_delivery_mobile/models/delivery.dart';
import 'package:huen_delivery_mobile/network/delivery_network.dart';
import 'package:huen_delivery_mobile/network/upload_network.dart';

class EndDeliveryNotifier with ChangeNotifier {
  DeliveryNetwork _deliveryNetwork = new DeliveryNetwork();
  UploadNetwork _uploadNetwork = new UploadNetwork();

  Delivery _delivery;
  File _image;

 setDelivery(Delivery delivery) {
   _delivery = delivery;
   notifyListeners();
 }

 Delivery getDelivery() {
   return _delivery;
 }

 setImage(File image) {
   this._image = image;
 }

  Future<void> endDelivery() async {
   _uploadNetwork.upload(_image);
    // _deliveryNetwork.
  }
}
