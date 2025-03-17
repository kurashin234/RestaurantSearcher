import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_searcher/api/call_api.dart';


List<dynamic> data = [];

void main() async {
  data = await CallApi.getRestauranData();
  var app = MaterialApp(home: MyApp());
  var scope = ProviderScope(child:app);

  runApp(scope);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body:Center(
        child:ListView(
          children: [
            ...data.map((shop) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(shop['logo_image']),
              );
            }),  // mapの結果をtoList()でリストに変換
          ],
        )
      )
    );
  }
}