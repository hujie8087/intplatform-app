import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/utils/native_location_service.dart';

class MealLocationServiceModel {
  final String foodName;
  late LocationSettings locationSettings;

  MealLocationServiceModel({required this.foodName});
  // 发送位置到服务器
  Future<void> _uploadLocation(double latitude, double longitude) async {
    try {
      // fcId, fcName, lng, lat, foodName
      DataUtils.uploadMealLocation(
        {'lng': longitude, 'lat': latitude, 'foodName': foodName},
        success: (data) {
          print("位置上传成功");
          // ProgressHUD.showSuccess('位置上传成功');
        },
        fail: (code, msg) {
          print("位置上传失败: $code, $msg");
          //ProgressHUD.showError('位置上传失败');
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
        if (!success) {
          // 如果启动失败，检查是否已经在运行中
          success = await NativeLocationService.isRealTimeTracking();
        }

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
    print("停止上传位置");
    NativeLocationService.stopRealTimeLocation();
  }
}
