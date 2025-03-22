import 'package:flutter/material.dart';

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
  final bool center;
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
            style: TextStyle(
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