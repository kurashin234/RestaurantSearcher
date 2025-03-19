import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:restaurant_searcher/api/call_api.dart';
import 'package:restaurant_searcher/util/location_permission_request.dart';

final locationProvider = FutureProvider<LocationData>((ref){
  return RequestLocationPermission.request();
});

final shopDataProider = FutureProvider.family<dynamic, Map>((ref, data){
  return CallApi.getRestauranData(data['lat'], data['lng'], data['range']);
});

final isLoadProvider = StateProvider((ref){
  return false;
});

final errorProvider = StateProvider((ref){
  return false;
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
    double? lat;
    double? lng;
    bool gps = false;
    int range = 3;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  locationAsync.when(
                    data: ((location){
                      lat = location.latitude as double;
                      lng = location.longitude as double;
                      gps = true;
                      return Text("位置情報取得に成功しました");
                    }),
                    error: (err, stack) => Text('位置情報取得に失敗しました'),
                    loading: () => Text('位置情報取得中')
                  ),
                  DropdownMenu(
                    label: Text('範囲'),
                    dropdownMenuEntries: ranges.map((range){
                      return DropdownMenuEntry(
                        value: range["id"], 
                        label: "${range["range"].toString()}m"
                      );
                    }).toList(),
                    inputDecorationTheme: const InputDecorationTheme(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                      
                    ),
                    // menuStyle: MenuStyle(
                    //   backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 217, 217, 217)),
                    // ),
                    // textStyle: const TextStyle(color: Colors.white),
                    onSelected: (id){
                      range = id!;
                    },
                  ),
                  TextButton(
                    onPressed: gps ? () async {
                      // ロード開始
                      ref.read(isLoadProvider.notifier).state = true;

                      try {
                        final data = await CallApi.getRestauranData(lat!, lng!, range);
                        if (context.mounted) {
                          context.push("/search_result", extra: data);
                        }
                      } catch (e) {
                        ref.read(errorProvider.notifier).state = true;
                      } finally {
                        ref.read(isLoadProvider.notifier).state = false;
                      }
                    } : null,
                    child: Text("検索")
                  )
                ],
              ),
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