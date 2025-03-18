import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestLocationPermission {
  static Future<LocationData> request() async {
    final location = Location();
    // パーミッション確認
    var status = await Permission.location.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.location.request();
      if (!status.isGranted) {
        throw Exception('位置情報の許可が必要です');
      }
    }

    // GPSサービスが有効か確認
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('GPSを有効にしてください');
      }
    }

    // 位置情報取得
    return await location.getLocation();
  }
}