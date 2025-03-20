import 'package:flutter/material.dart';

class TextAndWidget extends StatelessWidget {
  const TextAndWidget({
    super.key, 
    required this.text, 
    required this.widget, 
    this.textColor = Colors.black,
    this.fontSize = 14,
    this.center = true
  });

  final String text;
  final Widget widget;
  final Color textColor;
  final double fontSize;
  final bool center;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
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