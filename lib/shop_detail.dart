import 'package:flutter/material.dart';
import 'package:restaurant_searcher/util/color.dart';
import 'package:restaurant_searcher/widgets/image_slider.dart';
import 'package:restaurant_searcher/widgets/shop_map.dart';
import 'package:restaurant_searcher/widgets/text_and_widget.dart';

class ShopDetail extends StatelessWidget {
  const ShopDetail({super.key, required this.shopData});

  final Map shopData;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
            Padding(
              padding: const EdgeInsets.fromLTRB(33, 5, 20, 5),
              child: TextAndWidget(
                text: '住所:', 
                widget: Expanded(child: Text(shopData['address'])),
                center: false,
                textInterval: 20,
              ),
            ),
            Divider(color: Colors.black),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
              child: TextAndWidget(
                text: "営業時間:", 
                widget: Expanded(child: Text(shopData['open'])),
                center: false,
                textInterval: 20,
              ),
            ),
            Divider(color: Colors.black),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: size.width * 0.7,
                child: ShopMap(shopLat: shopData['lat'], shopLng: shopData['lng'],)
              ),
            )
          ],
        ),
      ),
    );
  }
}