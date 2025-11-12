import 'package:logistics_app/utils/native_location_service.dart';

class LocationManager {
  static Future<Map<String, double>?> getLocation() async {
    try {
      // 检查定位服务是否可用
      bool isAvailable = await NativeLocationService.isLocationAvailable();
      print('isAvailable: $isAvailable');
      if (!isAvailable) {
        print('定位服务不可用');
        return null;
      }

      // 请求定位权限
      bool hasPermission =
          await NativeLocationService.requestLocationPermission();
      print('hasPermission: $hasPermission');
      if (!hasPermission) {
        print('定位权限被拒绝');
        return null;
      }

      // 获取位置信息
      final location = await NativeLocationService.getNativeLocation();
      print('location: $location');
      return location;
    } catch (e) {
      print('获取位置失败: $e');
      return null;
    }
  }

  static Future<void> startTracking() async {
    try {
      print('开始启动实时定位...');

      // 检查定位服务是否可用
      bool isAvailable = await NativeLocationService.isLocationAvailable();
      print('定位服务可用: $isAvailable');
      if (!isAvailable) {
        print('❌ 定位服务不可用，请开启GPS');
        return;
      }

      // 请求定位权限
      bool hasPermission =
          await NativeLocationService.requestLocationPermission();
      print('定位权限: $hasPermission');
      if (!hasPermission) {
        print('❌ 定位权限被拒绝');
        return;
      }

      // 设置回调
      NativeLocationService.setRealTimeLocationCallback(
        onUpdate: (location) {
          print('📍 实时位置: ${location['latitude']}, ${location['longitude']}');
          print('精度: ${location['accuracy']}米');
          print('速度: ${location['speed']} m/s');
          print('提供者: ${location['provider']}');
          print('时间戳: ${location['timestamp']}');
        },
        onProviderEnabled: (provider) {
          print('✅ 定位提供者启用: $provider');
        },
        onProviderDisabled: (provider) {
          print('❌ 定位提供者禁用: $provider');
        },
        onStatusChanged: (status) {
          print('🔄 定位状态变化: ${status['provider']} -> ${status['status']}');
        },
        onStopped: () {
          print('⏹️ 实时定位已停止');
        },
      );

      // 开始实时定位
      bool success = await NativeLocationService.startRealTimeLocation(
        interval: 2000,
      );
      print('启动实时定位结果: $success');

      if (success) {
        print('✅ 实时定位已启动，每2秒更新一次');
      } else {
        print('❌ 启动实时定位失败');
      }
    } catch (e) {
      print('❌ 启动实时定位异常: $e');
    }
  }

  static Future<void> stopTracking() async {
    try {
      bool success = await NativeLocationService.stopRealTimeLocation();
      print('停止实时定位结果: $success');
    } catch (e) {
      print('❌ 停止实时定位异常: $e');
    }
  }
}
