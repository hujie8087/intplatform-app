import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:logistics_app/http/data/data_utils.dart';

class LocationServiceModel {
  StreamSubscription<Position>? _positionStream;
  final String deliveryNo;

  LocationServiceModel({required this.deliveryNo});

  // 启动位置监听
  void startTracking() async {
    // 检查并请求权限
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print("用户永久拒绝定位权限");
        return;
      }
    }

    // 监听位置变化
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 只有移动超过 10 米才会触发更新
      ),
    ).listen((Position position) {
      print("实时位置: ${position.latitude}, ${position.longitude}");
      _uploadLocation(position.latitude, position.longitude);
    });
  }

  // 发送位置到服务器
  Future<void> _uploadLocation(double latitude, double longitude) async {
    try {
      DataUtils.uploadLocation({
        'deliveryNo': deliveryNo,
        'latitude': latitude,
        'longitude': longitude,
      }, success: (data) {
        print("位置上传成功");
      }, fail: (code, msg) {
        print("位置上传失败: $code, $msg");
      });
    } catch (e) {
      print("网络错误: $e");
    }
  }

  // 停止监听
  void stopTracking() {
    _positionStream?.cancel();
    print("停止上传位置");
    _positionStream = null;
  }
}
