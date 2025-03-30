import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//TextとWidgetを横並びに配置するためのwidget
class TextAndWidget extends StatelessWidget {
  const TextAndWidget({
    super.key, 
    required this.text, 
    required this.widget, 
    this.textColor = Colors.black,
    this.fontSize = 14,
    this.center = true,
    this.textInterval = 10
  });

  final String text;
  final Widget widget;
  final Color textColor;
  final double fontSize;
  final bool center; //中心に配置するか判定するflag
  final double textInterval;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, textInterval, 0),
          child: Text(
            text,
            style: GoogleFonts.notoSansJp( //日本語のフォントを指定
              color: textColor,
              fontSize: fontSize
            ),
          ),
        ),
        widget,
      ],
    );
  }
}