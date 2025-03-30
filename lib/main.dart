import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_searcher/search_result.dart';
import 'package:restaurant_searcher/shop_detail.dart';
import 'package:restaurant_searcher/shop_search.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // ステータスバーの背景を透明
    statusBarIconBrightness: Brightness.dark, // 時間やバッテリ残量の色を黒に
  ));
  var app = MaterialApp(home: MyApp());
  var scope = ProviderScope(child:app);

  runApp(scope);
}

final goRouter = GoRouter(
  initialLocation: '/',
  routes:[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return MaterialPage(
          child: ShopSearch()
        );
      },
    ),
    GoRoute(
      path: '/search_result',
      pageBuilder: (context, state){
        final locationDataProvider = state.extra;
        return MaterialPage(
          child: SearchResult(locationDataProvider: locationDataProvider),
        );
      }
    ),
    GoRoute(
      path: '/shop_detail',
      pageBuilder: (context, state){
        final shopData = state.extra as Map;

        return MaterialPage(
          child: ShopDetail(shopData: shopData),
        );
      }
    )
  ]
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: goRouter.routerDelegate,
      routeInformationParser: goRouter.routeInformationParser,
      routeInformationProvider: goRouter.routeInformationProvider,
    );
  }
}         