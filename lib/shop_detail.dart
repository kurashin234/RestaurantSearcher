import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_searcher/util/color.dart';
import 'package:restaurant_searcher/widgets/image_slider.dart';
import 'package:restaurant_searcher/widgets/open_google_maps.dart';
import 'package:restaurant_searcher/widgets/shop_map.dart';
import 'package:restaurant_searcher/widgets/text_and_widget.dart';
import 'package:url_launcher/url_launcher.dart';


final tapMapProvider = StateProvider((ref){
  return false;
});

class ShopDetail extends ConsumerWidget {
  const ShopDetail({super.key, required this.shopData});

  final Map shopData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tapMap = ref.watch(tapMapProvider);
    final Size size = MediaQuery.of(context).size;

    final List shopImages = [
      shopData['logo_image'], 
      shopData['photo']['mobile']['l'],
    ];
    
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result){
        ref.read(tapMapProvider.notifier).state = false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(shopData['name']),
          backgroundColor: AppColor.appBarColor,
        ),
        backgroundColor: AppColor.backgroudColor,
        body: Stack(
          children: [
            Center(
              child: ListView(
                children: [
                  ImageSlider(images: shopImages),
                  Align(
                    alignment: Alignment.center,
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
                    padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
                    child: TextAndWidget(
                      text: "キャッチ:", 
                      widget: Expanded(child: Text(shopData['catch']))
                    ),
                  ),
                  Divider(color: Colors.black),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(33, 5, 20, 5),
                    child: TextAndWidget(
                      text: '住所:', 
                      widget: OpenGoogleMaps(address: shopData['address']),
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
                      child: ShopMap(
                        shopLat: shopData['lat'], 
                        shopLng: shopData['lng'],
                        function: (){
                          ref.read(tapMapProvider.notifier).state = true;
                        }
                      )
                    ),
                  )
                ],
              ),
            ),
      
            if(tapMap)
              Stack(
                children: [
                  Container(
                    color: Colors.black.withAlpha(180),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: size.height * 0.83,
                          child: ShopMap(
                            shopLat: shopData['lat'], 
                            shopLng: shopData['lng'], 
                            move: true,
                          )
                        ),
                      ),
                    )
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: Colors.white.withAlpha(0),
                      ),
                      onPressed: (){
                        ref.read(tapMapProvider.notifier).state = false;
                      }, 
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 35
                      )
                    ),
                  )
                ],
              )
          ]
        ),
      ),
    );
  }
}