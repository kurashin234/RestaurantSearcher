import 'dart:convert';

import 'package:http/http.dart' as http;
import '../env/env.dart';

class CallApi {
  static Future<dynamic> getRestauranData(double lat, double lng, int range) async {
    final url = Uri.parse('https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=${Env.key}&format=json&lat=$lat&lng=$lng&range=$range&count=100');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)["results"]["shop"];
      return data;
    } else {
      return null;
    }
  }
}