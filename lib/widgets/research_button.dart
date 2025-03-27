import 'package:flutter/material.dart';
import 'package:restaurant_searcher/util/color.dart';

class ResearchButton extends StatelessWidget {
  const ResearchButton({super.key, required this.onPressed});

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        animationDuration: Duration.zero,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        side: BorderSide(
          color: AppColor.researchColor,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        )
      ),
      onPressed: onPressed,
      child: Text(
        "再試行",
        style: TextStyle(
          color: AppColor.researchColor
        ),
      ),
    );
  }
}