import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_searcher/util/color.dart';
import 'package:restaurant_searcher/widgets/image_slider.dart';
import 'package:restaurant_searcher/widgets/open_google_maps.dart';
import 'package:restaurant_searcher/widgets/shop_map.dart';
import 'package:restaurant_searcher/widgets/text_and_widget.dart';

//操作可能mapを表示するか管理
final tapMapProvider = StateProvider((ref) => false);

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
      //遷移前の画面に戻った際表示されているmapを閉じる
      canPop: true,
      onPopInvokedWithResult: (didPop, result){
        ref.read(tapMapProvider.notifier).state = false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(shopData['name'], style: GoogleFonts.notoSansJp()),
          backgroundColor: AppColor.appBarColor,
        ),
        backgroundColor: AppColor.backgroudColor,
        body: Stack(
          children: [
            Center(
              child: ListView(
                children: [
                  //画像の表示
                  ImageSlider(images: shopImages),

                  //店舗名の表示
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      shopData['name'],
                      style: GoogleFonts.notoSansJp(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(color: Colors.black),

                  //キャッチコピーの表示
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
                    child: TextAndWidget(
                      text: "キャッチ:", 
                      widget: Expanded(child: Text(shopData['catch']))
                    ),
                  ),
                  Divider(color: Colors.black),

                  //住所の表示
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

                  //営業時間の表示
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
                    child: TextAndWidget(
                      text: "営業時間:", 
                      widget: Expanded(child: Text(shopData['open'], style: GoogleFonts.notoSansJp())),
                      center: false,
                      textInterval: 20,
                    ),
                  ),
                  Divider(color: Colors.black),

                  //mapの表示
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      height: size.width * 0.7,
                      child: ShopMap(
                        shopLat: shopData['lat'], 
                        shopLng: shopData['lng'],
                        function: (){
                          //mapがタップされた際、操作可能なmapを表示する
                          ref.read(tapMapProvider.notifier).state = true;
                        }
                      )
                    ),
                  )
                ],
              ),
            ),

            //mapがタップされた際、操作可能なmapを表示する
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

                  //操作可能なmapを閉じるためのアイコンを表示
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