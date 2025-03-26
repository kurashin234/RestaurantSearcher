import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../env/env.dart';

class CallApi {
  static Future<dynamic> getRestauranData(double lat, double lng, int range, String? keyword, Map isSelectedFilter) async {
  final queryParams = {
    'key': Env.key,
    'format': 'json',
    'lat': lat.toString(),
    'lng': lng.toString(),
    'range': range.toString(),
    'count': '100',
    'parking': isSelectedFilter['駐車場'] ? "1" : "0",
    'free_drink': isSelectedFilter['飲み放題'] ? "1" : "0",
    'free_food': isSelectedFilter['食べ放題'] ? "1" : "0",
    'non_smoking': isSelectedFilter['禁煙'] ? "1" : "0",
    'wifi': isSelectedFilter['Wi-Fi'] ? "1" : "0",
    if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,  
  };
  inspect(isSelectedFilter);

  // Uri.httpsでURLを構築
  final url = Uri.https(
    'webservice.recruit.co.jp',
    '/hotpepper/gourmet/v1/',
    queryParams,
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body)["results"]["shop"];
    return data;
  } else {
    return null;
  }
}
}