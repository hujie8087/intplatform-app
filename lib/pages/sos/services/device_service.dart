import 'package:shared_preferences/shared_preferences.dart';
// 添加MethodChannel导入
import 'package:flutter/services.dart';

/// 统一设备服务，用于获取设备ID
class DeviceService {
  static const String _PREFS_KEY = 'websocket_unique_id';
  // 定义MethodChannel
  static const MethodChannel _channel = MethodChannel('com.iwip.security/device_info');
  
  /// 获取标识符（始终返回设备ID，不管是否登录）
  static Future<String> getIdentifier() async {
    // 始终返回设备ID，不管用户是否登录
    return await getDeviceId();
  }

  /// 获取设备唯一标识符（通过原生方法获取）
  /// 优先从SharedPreferences获取，如果不存在则通过原生方法获取
  static Future<String> getDeviceId() async {
    try {
      // 优先从SharedPreferences获取已缓存的设备ID
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedDeviceId = prefs.getString(_PREFS_KEY);
      
      if (cachedDeviceId != null && cachedDeviceId.isNotEmpty) {
        return cachedDeviceId;
      } else {
        // 通过原生方法获取设备ID
        String deviceId = await _getNativeDeviceId();
        // 缓存设备ID
        await prefs.setString(_PREFS_KEY, deviceId);
        return deviceId;
      }
    } catch (e) {
      // 如果无法获取或存储ID，返回默认设备ID
      print('获取原生设备ID失败: $e');
      return 'default_device_id';
    }
  }

  /// 通过原生方法获取设备ID
  static Future<String> _getNativeDeviceId() async {
    try {
      // 调用原生方法获取设备唯一ID
      final String deviceId = await _channel.invokeMethod('getUniqueId');
      return deviceId;
    } catch (e) {
      print('调用原生设备ID方法失败: $e');
      rethrow;
    }
  }


  /// 清除设备ID缓存
  /// 在用户退出登录时调用，确保下次生成新的设备ID
  static Future<void> clearDeviceId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_PREFS_KEY);
    } catch (e) {
      print('清除设备ID失败: $e');
    }
  }
}