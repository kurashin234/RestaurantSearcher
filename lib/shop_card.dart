import 'package:flutter/material.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({
    super.key, 
    required this.logoImage, 
    required this.access, 
    required this.shopName
  });

  final String logoImage;
  final String access;
  final String shopName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(
          logoImage,
          width: 100,
          height: 100,
          fit: BoxFit.fill
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shopName, 
                style: TextStyle(color: Colors.black),
              ),
              Text(
                access,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}