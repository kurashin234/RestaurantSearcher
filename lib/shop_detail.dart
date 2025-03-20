import 'package:flutter/material.dart';
import 'package:restaurant_searcher/util/color.dart';
import 'package:restaurant_searcher/widgets/image_slider.dart';
import 'package:restaurant_searcher/widgets/text_and_widget.dart';

class ShopDetail extends StatelessWidget {
  const ShopDetail({super.key, required this.shopData});

  final Map shopData;

  @override
  Widget build(BuildContext context) {
    final List shopImages = [
      shopData['logo_image'], 
      shopData['photo']['mobile']['l'],
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(shopData['name']),
        backgroundColor: AppColor.appBarColor,
      ),
      backgroundColor: AppColor.backgroudColor,
      body: Center(
        child: ListView(
          children: [
            ImageSlider(images: shopImages),
            Center(
              child: Text(
                shopData['name'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(color: Colors.black),
            TextAndWidget(
              text: '住所:', 
              widget: Text(shopData['address']),
            ),
            Divider(color: Colors.black),
            TextAndWidget(
              text: "営業時間:", 
              widget: Expanded(child: Text(shopData['open'])),
              center: false,
            ),
            Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }
}