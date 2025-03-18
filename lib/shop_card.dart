import 'package:flutter/material.dart';

class ShopCard extends StatelessWidget {
  ShopCard({
    super.key, 
    required this.logoImage, 
    required this.access, 
    required this.shopName
  });

  String logoImage;
  String access;
  String shopName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(logoImage),
        Text(shopName),
        Text(access),
      ],
    );
  }
}