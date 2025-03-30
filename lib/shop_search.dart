import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:restaurant_searcher/util/color.dart';
import 'package:restaurant_searcher/util/location_permission_request.dart';
import 'package:restaurant_searcher/widgets/index_search_box.dart';
import 'package:restaurant_searcher/widgets/research_button.dart';
import 'package:restaurant_searcher/widgets/research_scope.dart';
import 'package:restaurant_searcher/widgets/search_button.dart';
import 'package:restaurant_searcher/widgets/text_and_widget.dart';

//位置情報を取得
final locationProvider = FutureProvider<LocationData>((ref){
  ref.watch(reloadProvider);
  return RequestLocationPermission.request();
});

//リロードされた際に再度位置情報を取得するためのプロバイダー
final reloadProvider = StateProvider((ref) => false);

final rangeProvider = StateProvider<dynamic>((ref){
  return null;
});

final controllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());  // dispose自動
  return controller;
});

final locationDataProvider = StateProvider((ref) => {});

class FirstBuild{
  bool value = true; // 初回ビルドかどうかを判定するフラグ
}

class ShopSearch extends ConsumerWidget {
  ShopSearch({super.key});

  //DropDownMenuに表示する値とid
  final ranges = [
    {"id": 1, "range": 300},
    {"id": 2, "range": 500},
    {"id": 3, "range": 1000},
    {"id": 4, "range": 2000},
    {"id": 5, "range": 3000},
  ];
 
  final FirstBuild isFirstBuild = FirstBuild();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationProvider); //位置情報を取得
    final range = ref.watch(rangeProvider);
    final controller = ref.watch(controllerProvider);
    final Size size = MediaQuery.of(context).size;
    double? lat;
    double? lng;
    bool gps = false;

    //遷移先から戻ってきた際に自動でフォーカスが当たるバグを回避
    if (isFirstBuild.value) {
      FocusScope.of(context).unfocus();
      isFirstBuild.value = false; // 2回目以降は実行しない
    }

    return GestureDetector(
      onTap: () {
        // 画面のどこかをタップするとフォーカス解除
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("近くの飲食店を検索", style: GoogleFonts.notoSansJp(),),
          backgroundColor: AppColor.appBarColor,
          centerTitle: true,
        ),
        backgroundColor: AppColor.backgroudColor,
        body: Center(
          //背景のboxを表示
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColor.shadowColor,
                  spreadRadius: 5,
                  blurRadius: 20,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            width: size.width * 0.8,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //位置情報の取得状況を表示
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: locationAsync.when(
                    data: ((location){
                      lat = location.latitude as double;
                      lng = location.longitude as double;
                      gps = true;
        
                      //位置情報の取得に成功
                      return TextAndWidget(
                        text: "位置情報取得に成功しました", 
                        widget: Icon(
                            const IconData(0xe15a, fontFamily: 'MaterialIcons'),
                            color: Colors.green,
                          )
                      );
                    }),
        
                    //位置情報取得中
                    loading: () { 
                      return TextAndWidget(
                        text: "位置情報を取得中", 
                        widget: SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColor.appBarColor,
                            )
                          )
                      );
                    },
        
                    //位置情報の取得失敗
                    error: (err, stack) {
                      return TextAndWidget(
                        text: "位置情報取得に失敗しました", 
                        textColor: AppColor.errorColor,
                        widget: SizedBox(
                          width: 95,
                          height: 35,
                          child: ResearchButton(
                            onPressed: (){
                              final reload = ref.watch(reloadProvider);
                              ref.read(reloadProvider.notifier).state = !reload;//リロードフラグを変更して再度位置情報を取得しなおす
                            }
                          )
                        )
                      );
                    } ,
                  ),
                ),
                
                //検索半径を指定するmenuの表示
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextAndWidget(
                    text: "検索半径 :", 
                    widget: ResearchScope(
                      ranges: ranges, 
                      function: (id){
                        ref.read(rangeProvider.notifier).state = id!;//選択されたmenuのidを取得
                      },
                    ),
                  ),
                ),
        
                //検索ボックスの表示
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: size.width * 0.65,
                    height: 50,
                    child: IndexSearchBox(
                      controller: controller, 
                    ),
                  ),
                ),
        
                //検索ボタンの表示
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 18),
                  child: SizedBox(
                    width: size.width * 0.6,
                    child: SearchButton(
                      onPressed: gps && range != null ? () {
                        //locationDataの値を更新
                        ref.read(locationDataProvider.notifier).state = {
                          "lat": lat,
                          "lng": lng,
                          "range": range,
                          "controller": controller
                        };
          
                        context.push("/search_result", extra: locationDataProvider); //遷移先にlocationDataProviderを渡す
                      } : null,
                      text: "検索"
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}