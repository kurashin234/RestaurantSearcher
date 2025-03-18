import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_searcher/api/call_api.dart';
import 'package:restaurant_searcher/shop_card.dart';

final shopDataProvider = FutureProvider<List<dynamic>>((ref) async{
  return await CallApi.getRestauranData();
});

class SearchResult extends ConsumerWidget {
  const SearchResult({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopDataAsync = ref.watch(shopDataProvider);

    return Scaffold(
      body:Center(
        child: shopDataAsync.when(
          data: ((data){
            return ListView(
              children: [
                ...data.map((shop){
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        context.push('/shop_detail');
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
            );
          }), 
          error: (err, stack) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('エラー: $err'),
              ElevatedButton(
                onPressed: () => ref.refresh(shopDataProvider),
                child: Text('再試行'),
              ),
            ],
          ), 
          loading: () => CircularProgressIndicator(),
        ),
      )
    );
  }
}