import 'package:flutter/material.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({
    super.key, 
    required this.logoImage, 
    required this.access, 
    required this.shopName
  });

  final String logoImage;
  final String access;
  final String shopName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 3,
          color: Color.fromARGB(255, 239, 237, 230)
        )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            logoImage,
            width: 100,
            height: 100,
            fit: BoxFit.fill
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    shopName, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 10, 15),
                  child: Text(
                    access,
                    style: TextStyle(color: const Color.fromARGB(255, 77, 77, 77)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}