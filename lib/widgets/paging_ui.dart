import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_searcher/util/color.dart';

class PagingUi extends StatelessWidget {
  const PagingUi({
    super.key, 
    required this.str,
    required this.color,
    this.isSelected = false, 
    this.onPressed,
    this.isPagination = false,
    this.paginationFontColor = Colors.white
  });

  final bool isSelected; 
  final String str;
  final dynamic onPressed;
  final Color color;
  final bool isPagination; //ページ番号ではなく「前へ」や「次へ」等の文字を入力する場合はtrueにする
  final Color paginationFontColor;

  @override 
  Widget build(BuildContext context) {
    final double fontSize = 16;
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: isSelected ? color : AppColor.inactivePaginationColor,
        ),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor,
            spreadRadius: 0.4,
            blurRadius: 0.5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.white.withAlpha(0),
        ),
        onPressed: onPressed, 
        child: Text(
          str,
          style: isPagination 
          ? GoogleFonts.notoSansJp(color: paginationFontColor, fontSize: fontSize) 
          :GoogleFonts.notoSansJp(
            color: isSelected ? AppColor.activePagingFontColor : AppColor.inactivePagingFontColor,
            fontSize: fontSize
          ),
        )
      ),
    );
  }
}