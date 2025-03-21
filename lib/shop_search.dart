import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:restaurant_searcher/api/call_api.dart';
import 'package:restaurant_searcher/util/color.dart';
import 'package:restaurant_searcher/util/location_permission_request.dart';
import 'package:restaurant_searcher/widgets/research_scope.dart';
import 'package:restaurant_searcher/widgets/search_button.dart';
import 'package:restaurant_searcher/widgets/text_and_widget.dart';

final locationProvider = FutureProvider<LocationData>((ref){
  return RequestLocationPermission.request();
});

final isLoadProvider = StateProvider((ref){
  return false;
});

final errorProvider = StateProvider((ref){
  return false;
});

final rangeProvider = StateProvider<dynamic>((ref){
  return null;
});

class ShopSearch extends ConsumerWidget {
  ShopSearch({super.key});
  
  final ranges = [
    {"id": 1, "range": 300},
    {"id": 2, "range": 500},
    {"id": 3, "range": 1000},
    {"id": 4, "range": 2000},
    {"id": 5, "range": 3000},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationProvider);
    final isLoad = ref.watch(isLoadProvider);
    final error = ref.watch(errorProvider);
    final range = ref.watch(rangeProvider);
    final Size size = MediaQuery.of(context).size;
    double? lat;
    double? lng;
    bool gps = false;

    return Scaffold(
      backgroundColor: AppColor.backgroudColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    "近くの飲食店を検索",
                    style: TextStyle(
                      fontSize: 25
                    ),
                  ),
                ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      locationAsync.when(
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

                        error: (err, stack) {
                          return TextAndWidget(
                            text: "位置情報取得に失敗しました", 
                            textColor: AppColor.errorColor,
                            widget: Icon(
                              Icons.error_outline,
                              color: AppColor.errorColor,
                            )
                          );
                        } ,

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
                        }
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextAndWidget(
                          text: "検索範囲 :", 
                          widget: ResearchScope(
                            ranges: ranges, 
                            function: (id){
                              ref.read(rangeProvider.notifier).state = id!;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: size.width * 0.6,
                          child: SearchButton(
                            onPressed: gps && range != null ? () async {
                              ref.read(isLoadProvider.notifier).state = true;
                              
                              try {
                                final data = await CallApi.getRestauranData(lat!, lng!, range!);
                                if (context.mounted) {
                                  context.push("/search_result", extra: data);
                                }
                              } catch (e) {
                                ref.read(errorProvider.notifier).state = true;
                              } finally {
                                ref.read(isLoadProvider.notifier).state = false;
                              }
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

          if(isLoad)
            Container(
              color: Colors.black.withAlpha(200),
              child: Center(
                child: CircularProgressIndicator(),
              )
            ),
          
          if(error)
            Text("errorが発生しました")
        ],
      )
    );
  }
}