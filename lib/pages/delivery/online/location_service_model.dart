import 'dart:async';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/utils/native_location_service.dart';

class LocationServiceModel {
  final String deliveryNo;

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
    if (await NativeLocationService.isLocationAvailable()) {
      if (await NativeLocationService.requestLocationPermission()) {
        bool success = await NativeLocationService.startRealTimeLocation();
        if (success) {
          print("位置监听启动成功");
          NativeLocationService.setRealTimeLocationCallback(
            onUpdate: (location) {
              print(
                "位置更新111: ${location['latitude']}, ${location['longitude']}",
              );
              _uploadLocation(location['latitude'], location['longitude']);
            },
            onProviderEnabled: (provider) {
              print("定位提供者启用: $provider");
            },
            onProviderDisabled: (provider) {
              print("定位提供者禁用: $provider");
            },
            onStatusChanged: (status) {
              print("定位状态变化: ${status['provider']} -> ${status['status']}");
            },
            onStopped: () {
              print("位置监听停止");
            },
          );
        } else {
          print("位置监听启动失败");
        }
      }
    }
  }

  // 停止监听
  void stopTracking() {
    NativeLocationService.stopRealTimeLocation();
  }
}
