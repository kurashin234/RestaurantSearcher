import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:restaurant_searcher/util/color.dart';
import 'package:restaurant_searcher/util/location_permission_request.dart';

final locationProvider = FutureProvider<LocationData>((ref){
  return RequestLocationPermission.request();
});

class ShopMap extends ConsumerWidget {
  const ShopMap({
    super.key,
    required this.shopLat,
    required this.shopLng,
    this.move = false,
    this.function
  });

  final double shopLat;
  final double shopLng;
  final bool move; //タップやドラッグ操作等の有効化と無効化
  final dynamic function;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationProvider);

    return locationAsync.when(
      data: (location){
        //現在地とお店との中心座標をとる
        final centerLat = (shopLat + location.latitude!.toDouble()) / 2;
        final centerLng = (shopLng + location.longitude!.toDouble()) / 2;

        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(centerLat, centerLng), 
            initialZoom: 13,
            interactionOptions: InteractionOptions(
              flags: move ? InteractiveFlag.all : InteractiveFlag.none, // すべての操作を有効化・無効化
            ),
            onTap:(tapPosition, point) => function != null ? function() : null,
          ),
          children: [
            TileLayer( // Bring your own tiles
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
              userAgentPackageName: "com.example.restaurant_searcher"
              // And many more recommended properties!
            ),
            MarkerLayer(
              markers: [
                //お店の位置をマーク
                Marker(
                  point: LatLng(shopLat, shopLng),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                ),
                //現在位置をマーク
                Marker(
                  point: LatLng(location.latitude as double, location.longitude as double),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.my_location, color: Colors.blueAccent)
                )
              ],
            ),
            RichAttributionWidget( // Include a stylish prebuilt attribution widget that meets all requirments
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => (), // (external)
                ),
                // Also add images...
              ],
            ),
          ],
        );
      }, 
    
      error:(error, stackTrace) => Center(
        child: Text(
          '位置情報取得に失敗しました',
          style: GoogleFonts.notoSansJp(
            fontSize: 18,
            color: AppColor.errorColor
          ),
        )
      ), 
    
      loading: () { 
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColor.appBarColor,
          ),
        );
      }
    );
  }
}