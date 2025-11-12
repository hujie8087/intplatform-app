import 'package:flutter/services.dart';

class NativeLocationService {
  static const MethodChannel _channel = MethodChannel(
    'native_location_service',
  );

  static Future<bool> isLocationAvailable() async {
    try {
      return await _channel.invokeMethod('isLocationAvailable') ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<Map<String, double>?> getNativeLocation() async {
    try {
      final location = await _channel.invokeMethod('getLocation');
      if (location != null) {
        if (location is Map) {
          return {
            'latitude': (location['latitude'] as num).toDouble(),
            'longitude': (location['longitude'] as num).toDouble(),
            'accuracy': (location['accuracy'] as num).toDouble(),
            'altitude': (location['altitude'] as num).toDouble(),
            'speed': (location['speed'] as num).toDouble(),
            'heading': (location['heading'] as num).toDouble(),
          };
        }
      }
      return null;
    } on PlatformException catch (e) {
      print('原生定位错误: $e');
      return null;
    }
  }

  // 开始实时定位
  static Future<bool> startRealTimeLocation({int interval = 1000}) async {
    try {
      // 明确将参数转换为正确的类型
      final arguments = <String, dynamic>{
        'interval': interval, // Dart 的 int 在 Platform Channel 中会自动处理
      };
      return await _channel.invokeMethod('startRealTimeLocation', arguments) ??
          false;
    } on PlatformException catch (e) {
      print('开始实时定位失败: $e');
      return false;
    }
  }

  // 停止实时定位
  static Future<bool> stopRealTimeLocation() async {
    try {
      return await _channel.invokeMethod('stopRealTimeLocation') ?? false;
    } on PlatformException catch (e) {
      print('停止实时定位失败: $e');
      return false;
    }
  }

  // 检查是否正在实时定位
  static Future<bool> isRealTimeTracking() async {
    try {
      return await _channel.invokeMethod('isRealTimeTracking') ?? false;
    } on PlatformException catch (e) {
      print('检查实时定位状态失败: $e');
      return false;
    }
  }

  // 设置实时定位回调
  static void setRealTimeLocationCallback({
    Function(Map<String, dynamic> location)? onUpdate,
    Function(String provider)? onProviderEnabled,
    Function(String provider)? onProviderDisabled,
    Function(Map<String, dynamic> status)? onStatusChanged,
    Function()? onStopped,
  }) {
    // 位置更新回调
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onRealTimeLocationUpdate':
          final locationData = call.arguments as Map<dynamic, dynamic>;
          final location = {
            'latitude': (locationData['latitude'] as num).toDouble(),
            'longitude': (locationData['longitude'] as num).toDouble(),
            'accuracy': (locationData['accuracy'] as num).toDouble(),
            'altitude': (locationData['altitude'] as num).toDouble(),
            'speed': (locationData['speed'] as num).toDouble(),
            'heading': (locationData['heading'] as num).toDouble(),
            'timestamp': (locationData['timestamp'] as num).toInt(),
            'provider': locationData['provider'] as String,
          };
          onUpdate?.call(location);
          break;
        case 'onLocationProviderEnabled':
          onProviderEnabled?.call(call.arguments as String);
          break;
        case 'onLocationProviderDisabled':
          onProviderDisabled?.call(call.arguments as String);
          break;
        case 'onLocationStatusChanged':
          final statusData = call.arguments as Map<dynamic, dynamic>;
          final status = {
            'provider': statusData['provider'] as String,
            'status': statusData['status'] as String,
          };
          onStatusChanged?.call(status);
          break;
        case 'onRealTimeLocationStopped':
          onStopped?.call();
          break;
      }
    });
  }

  static Future<bool> requestLocationPermission() async {
    try {
      return await _channel.invokeMethod('requestLocationPermission') ?? false;
    } on PlatformException {
      return false;
    }
  }
}
