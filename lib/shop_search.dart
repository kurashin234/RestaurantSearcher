import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:restaurant_searcher/util/color.dart';
import 'package:restaurant_searcher/util/location_permission_request.dart';
import 'package:restaurant_searcher/util/search_range.dart';
import 'package:restaurant_searcher/widgets/index_search_box.dart';
import 'package:restaurant_searcher/widgets/research_button.dart';
import 'package:restaurant_searcher/widgets/research_scope.dart';
import 'package:restaurant_searcher/widgets/search_button.dart';
import 'package:restaurant_searcher/widgets/text_and_widget.dart';

final locationProvider = FutureProvider.autoDispose<LocationData>((ref){
  ref.keepAlive();
  return RequestLocationPermission.request();
});

final rangeProvider = StateProvider<dynamic>((ref){
  return null;
});

final controllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());  // dispose自動
  return controller;
});

final focusNodeProvider = Provider.autoDispose<FocusNode>((ref) {
  final focusNode = FocusNode();
  ref.onDispose(() => focusNode.dispose());  
  return focusNode;
});

class ShopSearch extends ConsumerWidget {
  const ShopSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationProvider);
    final range = ref.watch(rangeProvider);
    final controller = ref.watch(controllerProvider);
    final focusNode = ref.watch(focusNodeProvider);
    final Size size = MediaQuery.of(context).size;
    double? lat;
    double? lng;
    bool gps = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(focusNodeProvider).requestFocus();
    });

    return GestureDetector(
      onTap: () {
        // 画面のどこかをタップするとフォーカス解除
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("近くの飲食店を検索"),
          backgroundColor: AppColor.appBarColor,
          centerTitle: true,
        ),
        backgroundColor: AppColor.backgroudColor,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: locationAsync.when(
                            data: ((location){
                              lat = location.latitude as double;
                              lng = location.longitude as double;
                              gps = true;
      
                              return TextAndWidget(
                                text: "位置情報取得に成功しました", 
                                widget: Icon(
                                    IconData(0xe15a, fontFamily: 'MaterialIcons'),
                                    color: Colors.green,
                                  )
                              );
                            }),
                          
                            loading: () { 
                              return TextAndWidget(
                                text: "位置情報を取得中", 
                                widget: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.green,
                                    )
                                  )
                              );
                            },

                            error: (err, stack) {
                              return TextAndWidget(
                                text: "位置情報取得に失敗しました", 
                                textColor: AppColor.errorColor,
                                widget: SizedBox(
                                  width: 95,
                                  height: 35,
                                  child: ResearchButton(
                                    onPressed: (){
                                      ref.invalidate(locationProvider);
                                      ref.read(locationProvider);
                                    }
                                  )
                                )
                              );
                            } ,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextAndWidget(
                            text: "検索範囲 :", 
                            widget: ResearchScope(
                              ranges: SearchRange.ranges, 
                              function: (id){
                                ref.read(rangeProvider.notifier).state = id!;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: SizedBox(
                            width: size.width * 0.65,
                            height: 50,
                            child: IndexSearchBox(
                              controller: controller, 
                              focusNode: focusNode,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 18),
                          child: SizedBox(
                            width: size.width * 0.6,
                            child: SearchButton(
                              onPressed: gps && range != null ? () {
                                final location = {"lat": lat, "lng": lng, "range": range, "controller": controller, "focusNode": focusNode};
                                context.push("/search_result", extra: location);
                              } : null,
                              text: "検索"
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}