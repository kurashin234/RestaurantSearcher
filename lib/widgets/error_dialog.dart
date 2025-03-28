import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('位置情報が取得できませんでした', style: GoogleFonts.notoSansJp()),
      content: Text('位置情報の設定をご確認ください', style: GoogleFonts.notoSansJp()),
      actions: <Widget>[
        GestureDetector(
          child: Text('OK'),
          onTap: (){
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}