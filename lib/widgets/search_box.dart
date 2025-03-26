import 'package:flutter/material.dart';
import 'package:restaurant_searcher/util/color.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key, required this.controller, required this.focusNode});

  final controller;
  final focusNode;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: 'キーワード・店名',
        enabledBorder: outlineBorder(),
        focusedBorder: outlineBorder(),
        prefixIcon: Icon(Icons.search)
      ),
    );
  }

  OutlineInputBorder outlineBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: AppColor.borderColor,
        width: 5,
      ),
    );
  }
}