import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restaurant_searcher/util/color.dart';
import 'package:restaurant_searcher/widgets/tag.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({
    super.key, 
    required this.shopData
  });

  final Map shopData;

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
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 2, 0, 0),
            child: Image.network(
              shopData['logo_image'],
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
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                  child: Text(
                    shopData['name'], 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: (){
                      List<Widget> tagName = [];
                      if(shopData['parking'].substring(0, 2) == 'あり') tagName.add(Tag(text: "駐車場あり",));
                      if(shopData['free_drink'].substring(0, 2) == 'あり') tagName.add(Tag(text: "飲み放題",));
                      if(shopData['free_food'].substring(0, 2) == 'あり') tagName.add(Tag(text: "食べ放題",));
                      if(shopData['non_smoking'] == '全面禁煙' || shopData['non_smoking'] == '一部禁煙') tagName.add(Tag(text: "禁煙",));
                      if(shopData['wifi'].substring(0, 2) == 'あり') tagName.add(Tag(text: "Wi-Fi",));

                      return tagName;
                    }(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(11, 0, 0, 3),
                  child: Text(
                    'アクセス:',
                    style: TextStyle(
                      color: AppColor.informationColor,
                      fontSize: 12
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 15),
                  child: Text(
                    shopData['access'],
                    style: TextStyle(color: AppColor.informationColor),
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