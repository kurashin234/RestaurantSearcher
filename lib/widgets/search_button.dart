import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_searcher/util/color.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key, 
    required this.text,
    required this.onPressed
  });

  final String text;
  final dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        animationDuration: Duration.zero,
        backgroundColor: AppColor.searchColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        )
      ),
      onPressed: onPressed,
      child: Text(text, style: GoogleFonts.notoSansJp(),),
    );
  }
}