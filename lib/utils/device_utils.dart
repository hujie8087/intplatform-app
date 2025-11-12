///  jh_common_utils.dart
///
///  Created by iotjin on 2020/07/28.
///  description:  设备信息工具类

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:uuid/uuid.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceUtils {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static bool get isDesktop => !isWeb && (isWindows || isLinux || isMacOS);

  static bool get isMobile => isAndroid || isIOS;

  static bool get isMobile2 =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  /// Platform不能在web端使用
  static bool get isWeb => kIsWeb;

  static bool get isWindows => isWeb ? false : Platform.isWindows;

  static bool get isLinux => isWeb ? false : Platform.isLinux;

  static bool get isMacOS => isWeb ? false : Platform.isMacOS;

  static bool get isAndroid => isWeb ? false : Platform.isAndroid;

  static bool get isFuchsia => isWeb ? false : Platform.isFuchsia;

  static bool get isIOS => isWeb ? false : Platform.isIOS;

  static Future<PackageInfo> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  static Future<String> appName() async {
    PackageInfo packageInfo = await getPackageInfo();
    return packageInfo.appName;
  }

  static Future<String> packageName() async {
    PackageInfo packageInfo = await getPackageInfo();
    return packageInfo.packageName;
  }

  static Future<String> version() async {
    PackageInfo packageInfo = await getPackageInfo();
    return packageInfo.version;
  }

  static Future<String> buildNumber() async {
    PackageInfo packageInfo = await getPackageInfo();
    return packageInfo.buildNumber;
  }

  static Future<String> buildSignature() async {
    PackageInfo packageInfo = await getPackageInfo();
    return packageInfo.buildSignature;
  }

  static Future<String?> installerStore() async {
    PackageInfo packageInfo = await getPackageInfo();
    return packageInfo.installerStore;
  }

  /// 获取设备唯一ID（兼容 Web、Android、iOS）
  static Future<String> getUniqueId() async {
    // 如果缓存里已经有，就直接返回
    final cachedId = await SpUtils.getString('device_unique_id');
    if (cachedId != null && cachedId.isNotEmpty) {
      return cachedId;
    }

    String uniqueId = '';

    if (kIsWeb) {
      // Web 无法读取设备号，生成并持久化一个 UUID
      uniqueId = const Uuid().v4();
    } else if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      uniqueId = '${info.id}-${info.device}-${info.model}-${info.product}';
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      uniqueId = info.identifierForVendor ?? const Uuid().v4();
    } else {
      // 其他平台（如 Windows、macOS、Linux）
      uniqueId = const Uuid().v4();
    }

    // 缓存保存，确保下次一致
    await SpUtils.saveString('device_unique_id', uniqueId);
    return uniqueId;
  }

  /* 使用

  void _getPackageInfo() async {
    PackageInfo packageInfo = await DeviceUtils.getPackageInfo();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String buildSignature = packageInfo.buildSignature;
    String installerStore = packageInfo.installerStore ?? 'not available';
    print('packageInfo：');
    print('appName $appName');
    print('packageName $packageName');
    print('version $version');
    print('buildNumber $buildNumber');
    print('buildSignature $buildSignature');
    print('installerStore $installerStore');
  }

 void _getPackageInfo() async {
    String version = await DeviceUtils.version();
    print('app version = ：$version');
    setState(() {
      _currentVersion = version;
    });
  }

  void _getPackageInfo() {
    DeviceUtils.version().then((version) {
      print('app version = ：$version');
      setState(() {
        _currentVersion = version;
      });
    });
  }

*/
}
