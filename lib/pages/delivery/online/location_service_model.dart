import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:logistics_app/http/data/data_utils.dart';

class LocationServiceModel {
  StreamSubscription<Position>? _positionStream;
  final String deliveryNo;
  late LocationSettings locationSettings;

  LocationServiceModel({required this.deliveryNo});
  // 发送位置到服务器
  Future<void> _uploadLocation(double latitude, double longitude) async {
    try {
      DataUtils.uploadLocation(
        {
          'deliveryNo': deliveryNo,
          'latitude': latitude,
          'longitude': longitude,
        },
        success: (data) {
          print("位置上传成功");
        },
        fail: (code, msg) {
          print("位置上传失败: $code, $msg");
        },
      );
    } catch (e) {
      print("网络错误: $e");
    }
  }

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
    if (permission == LocationPermission.deniedForever) {
      print("❌ 用户永久拒绝了定位权限，无法继续");
      return;
    }
    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 30,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 30,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 30,
      );
    }
    print('123456');
    // 监听位置变化
    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      if (position != null) {
        print("实时位置: ${position.latitude}, ${position.longitude}");
        _uploadLocation(position.latitude, position.longitude);
      } else {
        print("无法获取位置");
      }
    });
  }

  // 停止监听
  void stopTracking() {
    _positionStream?.cancel();
    print("停止上传位置");
    _positionStream = null;
  }
}
