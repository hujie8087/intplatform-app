import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:logistics_app/http/data/data_utils.dart';

class MealLocationServiceModel {
  StreamSubscription<Position>? _positionStream;
  final String foodName;
  late LocationSettings locationSettings;
  Timer? _fallbackTimer;
  bool _isLocationObtained = false;

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
          // ProgressHUD.showError('位置上传失败');
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

    // 检查定位服务是否开启
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❌ 定位服务未开启，请开启GPS");
      return;
    }

    // 优化后的定位配置
    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        // 降低精度要求，提高获取速度
        accuracy: LocationAccuracy.high,
        // 减少距离过滤器，更快响应
        distanceFilter: 10,
        // 使用系统默认的定位管理器
        // forceLocationManager: true,
        // 缩短更新间隔
        intervalDuration: const Duration(seconds: 30),
        // 启用后台定位和前台服务
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "正在获取位置信息",
          notificationTitle: "定位服务",
          notificationIcon: AndroidResource(
            name: 'ic_launcher',
            defType: 'mipmap',
          ),
        ),
        // 后台定位配置（通过前台服务实现）
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 10,
        // 允许后台定位
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
        // iOS超时设置
        timeLimit: const Duration(seconds: 120),
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    }

    print('🚀 开始获取位置，配置已优化');
    print('locationSettings: $locationSettings');

    // 先尝试获取一次当前位置（带超时）
    try {
      Position? currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          print("⚠️ 获取当前位置超时，使用流式定位");
          throw TimeoutException('获取位置超时', const Duration(seconds: 15));
        },
      );

      print(
        "📍 快速获取到当前位置: ${currentPosition.latitude}, ${currentPosition.longitude}",
      );
      _uploadLocation(currentPosition.latitude, currentPosition.longitude);
      _isLocationObtained = true;
    } catch (e) {
      print("⚠️ 获取当前位置失败: $e");
    }

    // 启动回退机制
    _startFallbackMechanism();

    // 监听位置变化
    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        print("📍 实时位置: ${position.latitude}, ${position.longitude}");
        _uploadLocation(position.latitude, position.longitude);
        _isLocationObtained = true;
      },
      onError: (error) {
        print("❌ 定位错误: $error");
        // 可以在这里添加错误处理逻辑
      },
    );
  }

  // 停止监听
  void stopTracking() {
    _positionStream?.cancel();
    _fallbackTimer?.cancel();
    print("停止上传位置");
    _positionStream = null;
    _fallbackTimer = null;
    _isLocationObtained = false;
  }

  // 回退机制：如果长时间无法获取位置，尝试降低精度要求
  void _startFallbackMechanism() {
    _fallbackTimer = Timer(const Duration(seconds: 60), () {
      if (!_isLocationObtained) {
        print("⚠️ 定位超时，尝试降低精度要求");
        _tryLowerAccuracyLocation();
      }
    });
  }

  // 尝试使用更低精度的定位
  Future<void> _tryLowerAccuracyLocation() async {
    try {
      // 使用低精度配置
      LocationSettings lowAccuracySettings;
      if (Platform.isAndroid) {
        lowAccuracySettings = AndroidSettings(
          accuracy: LocationAccuracy.medium,
          distanceFilter: 20,
          forceLocationManager: false,
          intervalDuration: const Duration(seconds: 10),
          timeLimit: const Duration(seconds: 20),
        );
      } else {
        lowAccuracySettings = LocationSettings(
          accuracy: LocationAccuracy.medium,
          distanceFilter: 20,
        );
      }

      Position? position = await Geolocator.getCurrentPosition(
        locationSettings: lowAccuracySettings,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print("❌ 低精度定位也超时");
          throw TimeoutException('低精度定位超时', const Duration(seconds: 10));
        },
      );

      print("📍 低精度定位成功: ${position.latitude}, ${position.longitude}");
      _uploadLocation(position.latitude, position.longitude);
      _isLocationObtained = true;
    } catch (e) {
      print("❌ 低精度定位失败: $e");
    }
  }

  // 检查定位权限和服务的便捷方法
  Future<bool> checkLocationAvailability() async {
    // 检查权限
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      print("❌ 定位权限被拒绝");
      return false;
    }

    // 检查服务
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❌ 定位服务未开启");
      return false;
    }

    return true;
  }
}
