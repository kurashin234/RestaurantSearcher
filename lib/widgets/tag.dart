import 'package:flutter/material.dart';
import 'package:restaurant_searcher/util/color.dart';

class Tag extends StatelessWidget {
  const Tag({
    super.key, 
    required this.text,
    this.isSelected = false,
    this.fontSize = 14,
    this.width,
    this.height
  });

  final String text;
  final bool isSelected;
  final double fontSize;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: width == null || height == null ? null : Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppColor.activePagingColor : const Color.fromARGB(255, 238, 238, 238),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? const Color.fromARGB(255, 239, 239, 239) : Colors.black,
            fontSize: fontSize
          ),
        ),
      ),
    );
  }
}