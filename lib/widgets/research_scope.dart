import 'package:flutter/material.dart';

class ResearchScope extends StatelessWidget {
  const ResearchScope({
    super.key, 
    this.hintText = '---', 
    required this.ranges,
    required this.function
  });

  final String hintText;
  final List ranges;
  final void Function(dynamic) function;
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      hintText: hintText,
      dropdownMenuEntries: ranges.map((range){
        return DropdownMenuEntry(
          value: range["id"], 
          label: "${range["range"].toString()}m"
        );
      }).toList(),
      inputDecorationTheme: const InputDecorationTheme(
        //border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
      ),
      textStyle: TextStyle(color: Colors.black),
      onSelected: function,
    );
  }
}