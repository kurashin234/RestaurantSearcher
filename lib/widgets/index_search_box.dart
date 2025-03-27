import 'package:flutter/material.dart';
import 'package:restaurant_searcher/util/color.dart';

class IndexSearchBox extends StatelessWidget {
  const IndexSearchBox({super.key, required this.controller});

  final dynamic controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: controller,
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