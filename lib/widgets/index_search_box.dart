import 'package:flutter/material.dart';
import 'package:restaurant_searcher/util/color.dart';

class IndexSearchBox extends StatelessWidget {
  const IndexSearchBox({super.key, required this.controller, required this.focusNode});

  final dynamic controller;
  final dynamic focusNode;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: 'キーワード・店名',
        filled: true,
        fillColor: AppColor.indexSerchBoxcolor,
        enabledBorder: outlineBorder(),
        focusedBorder: outlineBorder(),
        prefixIcon: Icon(Icons.search)
      ),
    );
  }

  OutlineInputBorder outlineBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 5,
      ),
    );
  }
}