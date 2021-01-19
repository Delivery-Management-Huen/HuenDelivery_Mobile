import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huen_delivery_mobile/models/user.dart';

class Delivery {
  num idx;
  String productName;
  double distance;
  String startAddress;
  String startTime;
  String endTime;
  User driver;
  User customer;
  LatLng addressPoint;

  Delivery({
    this.idx,
    this.productName,
    this.customer,
    this.driver,
    this.endTime,
    this.startTime,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
        idx: json['idx'],
        productName: json['productName'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        driver: User.fromJson(json['driver']),
        customer: User.fromJson(json['customer']));
  }
}
