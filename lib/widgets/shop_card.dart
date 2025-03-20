import 'package:flutter/material.dart';
import 'package:restaurant_searcher/util/color.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 3,
          color: AppColor.borderColor
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor,
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 2, 0, 0),
            child: Image.network(
              logoImage,
              width: 100,
              height: 100,
              fit: BoxFit.fill
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    shopName, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 10, 15),
                  child: Text(
                    access,
                    style: TextStyle(color: const Color.fromARGB(255, 77, 77, 77)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}