import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_searcher/util/color.dart';

final carouselCurrentIndexProvider = StateProvider<int>((ref) => 0);

class ImageSlider extends ConsumerWidget {
  const ImageSlider({super.key, required this.images});

  final List images;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carouselCurrentIndex = ref.watch(carouselCurrentIndexProvider);
    final Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 350.0,
            onPageChanged: (index, reason) {
              ref.read(carouselCurrentIndexProvider.notifier).state = index;
            },
          ),
          items: images.map((image) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Image.network(
                    image,
                    fit: BoxFit.contain,
                  ),
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: 7,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.map((path) {
              final int getIndex = images.indexOf(path);
              return Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0, 
                  horizontal: 5.0
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: carouselCurrentIndex == getIndex
                    ? AppColor.activeIndicatorColor
                    : AppColor.inactiveIndicatorColor
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}