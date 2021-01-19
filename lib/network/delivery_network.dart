import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:huen_delivery_mobile/config/config.dart';
import 'package:huen_delivery_mobile/util/token.dart';

class DeliveryNetwork {
  Future<http.Response> getDeliveries() async {
    final res = await http.get('$END_POINT/delivery/my', headers: {
      'x-access-token': getToken(),
    });

    return res;
  }

  Future<http.Response> startDelivery(num idx, LatLng location) async {
    final res = await http.post('$END_POINT/delivery/start/$idx',
        headers: {
          'x-access-token': getToken(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'lat': location.latitude,
          'long': location.longitude,
        }));

    return res;
  }
}
