import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:huen_delivery_mobile/config/config.dart';

const GEO_CODE_URL = 'https://maps.googleapis.com/maps/api/geocode/json';

class GoogleThirdParty {
  Future<LatLng> convertAddress(String address) async {
    Map<String, String> query = {
      'key': GOOGLE_API_KEY,
      'address': address,
    };

    String url = '$GEO_CODE_URL?${Uri(queryParameters: query).query}';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      dynamic results = json.decode(response.body)['results'];
      if (results.length <= 0) {
        return null;
      }

      dynamic location = results[0]['geometry']['location'];

      return LatLng(location['lat'], location['lng']);
    } else {
      throw Exception('Failed to load post');
    }
  }
}
