import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

//グーグルマップ遷移するためのクラス
class OpenGoogleMaps extends StatelessWidget {
  const OpenGoogleMaps({super.key, required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      //textにリンクを貼る
      child: Text.rich(
        TextSpan(
          text: address,
          style: GoogleFonts.notoSansJp(color: Colors.blue, decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()..onTap = _openGoogleMaps,
        ),
      ),
    );
  }
  
  Future<void> _openGoogleMaps() async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    
    //リンク先の情報が取得できなかったらエラーを返す
    if (!await launchUrl(url)) {
      throw Exception();
    }
  }
}
