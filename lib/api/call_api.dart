import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_searcher/util/location_permission_request.dart';
import '../env/env.dart';

class CallApi {
  static Future<dynamic> getRestauranData() async {
    final locationData = await RequestLocationPermission.request();
    final url = Uri.parse('https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=${Env.key}&format=json&lat=${locationData.latitude}&lng=${locationData.longitude}&range=3');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)["results"]["shop"];
      return data;
    } else {
      return null;
    }
  }
}