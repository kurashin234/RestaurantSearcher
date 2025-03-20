import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_searcher/widgets/search_box.dart';
import 'package:restaurant_searcher/widgets/shop_card.dart';

class SearchResult extends ConsumerWidget {
  const SearchResult({super.key, required this.shopData});

  final List shopData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 248, 245),
      body:Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: SearchBox(),
            ),
            Expanded(
              child: ListView(
                children: [
                  ...shopData.map((shop){
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          context.push('/shop_detail', extra: shop);
                        },
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: Colors.white.withAlpha(0)
                        ),
                        child: ShopCard(
                          logoImage: shop['logo_image'], 
                          access: shop['access'], 
                          shopName: shop['name']
                        ),
                      ),
                    );
                  })
                ],
              )
            )
          ],
        ),
      )
    );
  }
}