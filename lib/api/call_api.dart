import 'dart:convert';

import 'package:http/http.dart' as http;
import '../env/env.dart';

class CallApi {
  static Future<dynamic> getRestauranData() async {
    final url = Uri.parse('https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=${Env.key}&format=json&large_area=Z011');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)['results']['shop'];
    } else {
      return null;
    }
  }
}