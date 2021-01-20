import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:huen_delivery_mobile/network/base_network.dart';
import 'package:huen_delivery_mobile/util/token.dart';

class DeliveryNetwork {
  Future<http.Response> getDeliveries() async {
    final res = await getNetwork('/delivery/my', token: await getToken());

    return res;
  }

  Future<http.Response> endDelivery(int deliveryIdx, String image) async {
    final res = await postNetwork(
        '/delivery/end/$deliveryIdx',
        {
          'image': image,
        },
        token: await getToken());

    return res;
  }

  Future<http.Response> getCompletedDeliveries() async {
    final res =
        await getNetwork('/delivery/my/completed', token: await getToken());

    return res;
  }

  Future<http.Response> reorderDeliveries(List<dynamic> orders) async {
    final res = await postNetwork(
        '/delivery/order',
        {
          'orders': orders,
        },
        token: await getToken());

    print(res.statusCode);
    print(res.body);
    return res;
  }
}
