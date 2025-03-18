import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_searcher/api/call_api.dart';

void main() async {
  var app = MaterialApp(home: MyApp());
  var scope = ProviderScope(child:app);

  runApp(scope);
}

final shopDataProvider = FutureProvider<List<dynamic>>((ref) async{
  return await CallApi.getRestauranData();
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopDataAsync = ref.watch(shopDataProvider);

    return Scaffold(
      body:Center(
        child: shopDataAsync.when(
          data: ((data){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...data.map((shop){
                  return Image.network(shop['logo_image']);
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


          