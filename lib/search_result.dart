import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_searcher/api/call_api.dart';
import 'package:restaurant_searcher/util/color.dart';
import 'package:restaurant_searcher/widgets/search_box.dart';
import 'package:restaurant_searcher/widgets/shop_card.dart';

final shopDataProvider = FutureProvider.family<dynamic, Map>((ref, location) {
  return CallApi.getRestauranData(location['lat'], location['lng'], location['range']);
});

// ページ番号の状態管理
final currentPageProvider = StateProvider<int>((ref) => 1);

class SearchResult extends ConsumerWidget {
  const SearchResult({super.key, required this.location});

  final Map location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopData = ref.watch(shopDataProvider(location));
    final currentPage = ref.watch(currentPageProvider);
    const itemsPerPage = 10;
    final scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text("検索結果"),
        backgroundColor: AppColor.appBarColor,
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 250, 248, 245),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SearchBox(),
            ),
            Expanded(
              child: shopData.when(
                data: (data) {
                  final totalPages = (data.length / itemsPerPage).ceil();
                  final startIndex = (currentPage - 1) * itemsPerPage;
                  final endIndex = (startIndex + itemsPerPage) > data.length ? data.length : startIndex + itemsPerPage;
                  final pagedData = data.sublist(startIndex, endIndex);

                  return ListView(
                    controller: scrollController,
                    children: [
                      ...pagedData.map<Widget>((shop) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              context.push('/shop_detail', extra: shop);
                            },
                            style: TextButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              overlayColor: Colors.white.withAlpha(0),
                            ),
                            child: ShopCard(
                              logoImage: shop['logo_image'],
                              access: shop['access'],
                              shopName: shop['name'],
                            ),
                          ),
                        );
                      }).toList(),
                  
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Wrap(
                            children: List.generate(totalPages, (index) {
                              final pageNum = index + 1;
                              final isSelected = currentPage == pageNum;
                        
                              return SizedBox(
                                width: 30,
                                child: TextButton(
                                  onPressed: () {
                                    ref.read(currentPageProvider.notifier).state = pageNum;
                                    scrollController.jumpTo(-20);
                                  },
                                  child: Text(
                                    '$pageNum',
                                    style: TextStyle(
                                      color: isSelected ? Colors.blue : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ]
                  );
                },

                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),

                error: (error, stack) => Center(child: Text('error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
