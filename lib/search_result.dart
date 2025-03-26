import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_searcher/api/call_api.dart';
import 'package:restaurant_searcher/util/color.dart';
import 'package:restaurant_searcher/widgets/error_ui.dart';
import 'package:restaurant_searcher/widgets/paging_ui.dart';
import 'package:restaurant_searcher/widgets/search_box.dart';
import 'package:restaurant_searcher/widgets/shop_card.dart';
import 'package:restaurant_searcher/widgets/tag.dart';

final shopDataProvider = FutureProvider.family<dynamic, Map>((ref, location) {
  final selectedFilters = ref.watch(isSelectedFilterProvider);
  return CallApi.getRestauranData(location['lat'], location['lng'], location['range'], location['controller'].text, selectedFilters);
});

final isSelectedFilterProvider = StateProvider((ref) {
  return {
    "駐車場": false,
    "飲み放題": false,
    "食べ放題": false,
    "禁煙": false,
    "Wi-Fi": false,
  };
});
final currentPageProvider = StateProvider<int>((ref) => 1);

class SearchResult extends ConsumerWidget {
  SearchResult({super.key, required this.location});

  final Map location;

  final filterName = [
      "駐車場",
      "飲み放題",
      "食べ放題",
      "禁煙",
      "Wi-Fi",
    ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopData = ref.watch(shopDataProvider(location));
    final currentPage = ref.watch(currentPageProvider);
    final itemsPerPage = 10;
    final pagingWidth = 40.0;
    final pagingHeight = 42.0;
    final scrollController = ScrollController();
    final controller = location['controller'];
    final focusNode = location['focusNode'];

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result){
        ref.read(currentPageProvider.notifier).state = 1;
      },
      child: GestureDetector(
        onTap: () {
          // 画面のどこかをタップするとフォーカス解除
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
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
                  child: SearchBox(
                    controller: controller,
                    focusNode: focusNode,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filterName.map((name) {
                      final isSelectedMap = ref.watch(isSelectedFilterProvider);
                      final isSelected = isSelectedMap[name] ?? false; // デフォルトは false

                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero, // タップ範囲を `Tag` のサイズに合わせる
                            padding: EdgeInsets.zero, // 余白をなくす
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 余分なタップ領域を排除
                          ),
                          onPressed: () {
                            ref.read(isSelectedFilterProvider.notifier).update((state) {
                              return {
                                ...state,
                                name: !(state[name] ?? false) // 押したタグのみ切り替える
                              };
                            });
                            ref.invalidate(shopDataProvider(location));
                            ref.read(currentPageProvider.notifier).state = 1;
                          },
                          child: Tag(
                            width: 75,
                            height: 33,
                            fontSize: 15,
                            text: name, 
                            isSelected: isSelected
                          ),
                        ),
                      );
                    }).toList(),
                  )
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                            child: Text(
                              '${data.length}件',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),
                            ),
                          ),
                          ...pagedData.map<Widget>((shop) {
                            return TextButton(
                              onPressed: () {
                                context.push('/shop_detail', extra: shop);
                              },
                              style: TextButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                overlayColor: Colors.white.withAlpha(0),
                              ),
                              child: ShopCard(
                                shopData: shop,
                              ),
                            );
                          }).toList(),
                      
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 5,
                                  children: () {
                                    int startPage = currentPage - 2;
                                    int endPage = currentPage + 2;
                                                      
                                    // 範囲補正
                                    if (startPage < 1) {
                                      endPage += (1 - startPage);
                                      startPage = 1;
                                    }
                                    if (endPage > totalPages) {
                                      startPage -= (endPage - totalPages).toInt();
                                      endPage = totalPages;
                                    }
                                    if (startPage < 1) startPage = 1;
                                                      
                                    List<Widget> pageButtons = [];
                                
                                    pageButtons.add(
                                      SizedBox(
                                        height: pagingHeight,
                                        child: PagingUi(
                                          str: "前へ",
                                          isPagination: true,
                                          paginationFontColor: currentPage <= 1 ? AppColor.inactivePaginationFontColor : AppColor.inactivePagingFontColor,
                                          color: currentPage <= 1 ? AppColor.inactivePaginationColor : AppColor.backgroudColor,
                                          onPressed: (){
                                            if (currentPage > 1){
                                              ref.read(currentPageProvider.notifier).state = currentPage - 1;
                                              scrollController.jumpTo(0);
                                            }
                                          },
                                        ),
                                      )
                                    );
                                
                                    for (int pageNum = startPage; pageNum <= endPage; pageNum++) {
                                      final isSelected = currentPage == pageNum;
                                                      
                                      pageButtons.add(
                                        SizedBox(
                                          width: pagingWidth,
                                          height: pagingHeight,
                                          child: PagingUi(
                                            color: isSelected ? AppColor.activePagingColor : AppColor.backgroudColor,
                                            isSelected: isSelected, 
                                            str: pageNum.toString(),
                                            onPressed: (){
                                              ref.read(currentPageProvider.notifier).state = pageNum;
                                              scrollController.jumpTo(0);
                                            },
                                          )
                                        ),
                                      );
                                    }
                                
                                    pageButtons.add(
                                      SizedBox(
                                        height: pagingHeight,
                                        child: PagingUi(
                                          str: "次へ",
                                          isPagination: true,
                                          paginationFontColor: currentPage >= totalPages ? AppColor.inactivePaginationFontColor : AppColor.inactivePagingFontColor,
                                          color: currentPage >= totalPages ? AppColor.inactivePaginationColor : AppColor.backgroudColor,
                                          onPressed: (){
                                            if (currentPage < totalPages){
                                              ref.read(currentPageProvider.notifier).state = currentPage + 1;
                                              scrollController.jumpTo(0);
                                            }
                                          },
                                        ),
                                      )
                                    );
                                    return pageButtons;
                                  }(),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "$currentPage/$totalPagesページ",
                                style: TextStyle(
                                  color: AppColor.informationColor
                                ),
                              ),
                            )
                          )
                        ]
                      );
                    },
        
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ),
        
                    error: (error, stack) => ErrorUi(
                      onPressed:(){
                        final _ = ref.invalidate(shopDataProvider(location));
                      }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
