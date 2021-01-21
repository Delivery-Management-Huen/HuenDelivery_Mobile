import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huen_delivery_mobile/models/user.dart';

class Delivery {
  int idx;
  String productName;
  String image;
  int endOrderNumber;
  String createdAt;
  String endTime;
  User driver;
  User customer;
  LatLng addressPoint;

  Delivery({
    this.idx,
    this.productName,
    this.customer,
    this.driver,
    this.endOrderNumber,
    this.image,
    this.createdAt,
    this.endTime,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
        idx: json['idx'],
        productName: json['productName'],
        image: json['image'],
        endOrderNumber: json['endOrderNumber'],
        createdAt: json['createdAt'],
        endTime: json['endTime'],
        driver: User.fromJson(json['driver']),
        customer: User.fromJson(json['customer']));
  }
}
