import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShopSearch extends StatelessWidget {
  ShopSearch({super.key});
  
  final ranges = [
    {"id": 1, "range": 300},
    {"id": 2, "range": 500},
    {"id": 3, "range": 1000},
    {"id": 4, "range": 2000},
    {"id": 5, "range": 3000},
  ];

  @override
  Widget build(BuildContext context) {
    int range = 3;

    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownMenu(
              label: Text('範囲'),
              dropdownMenuEntries: ranges.map((range){
                return DropdownMenuEntry(
                  value: range["id"], 
                  label: "${range["range"].toString()}m"
                );
              }).toList(),
              inputDecorationTheme: const InputDecorationTheme(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                
              ),
              // menuStyle: MenuStyle(
              //   backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 217, 217, 217)),
              // ),
              // textStyle: const TextStyle(color: Colors.white),
              onSelected: (id){
                range = id!;
              },
            ),
            TextButton(
              onPressed: (){
                print(range);
                context.push("/search_result", extra: range);
              }, 
              child: Text("検索")
            )
          ],
        ),
      )
    );
  }
}