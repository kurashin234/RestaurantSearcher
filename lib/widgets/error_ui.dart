import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_searcher/util/color.dart';
import 'package:restaurant_searcher/widgets/research_button.dart';

class ErrorUi extends StatelessWidget {
  const ErrorUi({super.key, required this.onPressed});

  final dynamic onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            Icons.warning_amber,
            size: 50,
            color: AppColor.informationColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            '情報の取得に失敗しました。',
            style: GoogleFonts.notoSansJp(
              color: AppColor.informationColor
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            'ネットワークを確認して再度お試しください。',
            style: GoogleFonts.notoSansJp(
              color: AppColor.informationColor
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ResearchButton(onPressed: onPressed),
        )
      ],
    );
  }
}