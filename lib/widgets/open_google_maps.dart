import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenGoogleMaps extends StatelessWidget {
  const OpenGoogleMaps({super.key, required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text.rich(
        TextSpan(
          text: address,
          style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()..onTap = _openGoogleMaps,
        ),
      ),
    );
  }
  
  Future<void> _openGoogleMaps() async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
