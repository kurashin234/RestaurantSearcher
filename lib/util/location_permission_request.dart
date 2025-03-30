import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestLocationPermission {
  static Future<LocationData> request() async {
    final location = Location();
    
    // 位置情報の権限ステータスを取得
    var status = await Permission.location.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.location.request();
      if (!status.isGranted) {
        throw Exception();
      }
    }

    // GPSが有効かどうか確認
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception();
      }
    }

    return await location.getLocation();
  }
}