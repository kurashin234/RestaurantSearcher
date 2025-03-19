import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_searcher/api/call_api.dart';
import 'package:restaurant_searcher/widget/search_box.dart';
import 'package:restaurant_searcher/widget/shop_card.dart';

final shopDataProvider = FutureProvider.family<List<dynamic>, int>((ref, range) async{
  return await CallApi.getRestauranData(range);
});

class SearchResult extends ConsumerWidget {
  const SearchResult({super.key, required this.range});

  final int range;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopDataAsync = ref.watch(shopDataProvider(range));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 248, 245),
      body:Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
              child: SearchBox(),
            ),
            shopDataAsync.when(
              data: ((data){
                return Expanded(
                  child: ListView(
                    children: [
                      ...data.map((shop){
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
                  ),
                );
              }), 
              error: (err, stack) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('エラー: $err'),
                  ElevatedButton(
                    onPressed: () => ref.refresh(shopDataProvider(range)),
                    child: Text('再試行'),
                  ),
                ],
              ), 
              loading: () => CircularProgressIndicator(),
            ),
          ],
        ),
      )
    );
  }
}