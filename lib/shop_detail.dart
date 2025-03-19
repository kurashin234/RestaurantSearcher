import 'package:flutter/material.dart';
import 'package:restaurant_searcher/util/color.dart';

class ShopDetail extends StatelessWidget {
  const ShopDetail({super.key, required this.shopData});

  final Map shopData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroudColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              shopData['logo_image'],
              width: 200,
              height: 200,
              fit: BoxFit.cover
            ),
            Text(shopData['name']),
            Text(shopData['address']),
            Text(shopData['open'])
          ],
        ),
      ),
    );
  }
}