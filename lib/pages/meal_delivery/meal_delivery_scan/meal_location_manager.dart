import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_scan/meal_location_service_model.dart';
import 'package:logistics_app/utils/sp_utils.dart';

/// 全局定位服务管理器
/// 用于在多个页面间共享定位状态
class MealLocationManager {
  static final MealLocationManager _instance = MealLocationManager._internal();
  factory MealLocationManager() => _instance;
  MealLocationManager._internal();

  MealLocationServiceModel? _locationService;
  bool _isTracking = false;
  String _currentFoodName = '';

  // 监听器列表，用于通知UI更新
  final List<VoidCallback> _listeners = [];

  // Getters
  bool get isTracking => _isTracking;
  String get currentFoodName => _currentFoodName;
  MealLocationServiceModel? get locationService => _locationService;

  /// 初始化管理器，从本地存储恢复状态
  Future<void> initialize() async {
    _isTracking = await SpUtils.getBool('isTracking') ?? false;
    _currentFoodName = await SpUtils.getString('currentFoodName') ?? '';

    // 如果之前有追踪状态，恢复服务
    if (_isTracking && _currentFoodName.isNotEmpty) {
      _locationService = MealLocationServiceModel(foodName: _currentFoodName);
      _locationService?.startTracking();
    }

    print(
      "📍 MealLocationManager 初始化完成 - 追踪状态: $_isTracking, 餐次: $_currentFoodName",
    );
  }

  /// 开始定位追踪
  Future<bool> startTracking(String foodName) async {
    if (_isTracking) {
      print("⚠️ 定位追踪已在运行中");
      return false;
    }

    if (foodName.isEmpty) {
      print("❌ 餐次名称不能为空");
      return false;
    }

    try {
      _currentFoodName = foodName;
      _locationService = MealLocationServiceModel(foodName: foodName);
      _locationService?.startTracking();

      _isTracking = true;

      // 保存状态到本地存储
      await SpUtils.saveBool('isTracking', true);
      await SpUtils.saveString('currentFoodName', foodName);

      // 通知所有监听器
      _notifyListeners();

      print("✅ 定位追踪已启动 - 餐次: $foodName");
      return true;
    } catch (e) {
      print("❌ 启动定位追踪失败: $e");
      _isTracking = false;
      _currentFoodName = '';
      _locationService = null;
      return false;
    }
  }

  /// 停止定位追踪
  Future<void> stopTracking() async {
    if (!_isTracking) {
      print("⚠️ 定位追踪未在运行");
      return;
    }

    try {
      _locationService?.stopTracking();
      _locationService = null;

      _isTracking = false;
      _currentFoodName = '';

      // 清除本地存储状态
      await SpUtils.saveBool('isTracking', false);
      await SpUtils.saveString('currentFoodName', '');

      // 通知所有监听器
      _notifyListeners();

      print("✅ 定位追踪已停止");
    } catch (e) {
      print("❌ 停止定位追踪失败: $e");
    }
  }

  /// 切换定位追踪状态
  Future<bool> toggleTracking(String foodName) async {
    if (_isTracking) {
      await stopTracking();
      return false;
    } else {
      return await startTracking(foodName);
    }
  }

  /// 添加状态变化监听器
  void addListener(VoidCallback listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// 移除状态变化监听器
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// 通知所有监听器状态已变化
  void _notifyListeners() {
    for (var listener in _listeners) {
      try {
        listener();
      } catch (e) {
        print("❌ 通知监听器时出错: $e");
      }
    }
  }

  /// 获取当前状态信息
  Map<String, dynamic> getStatus() {
    return {
      'isTracking': _isTracking,
      'currentFoodName': _currentFoodName,
      'hasLocationService': _locationService != null,
    };
  }

  /// 清理资源
  void dispose() {
    _locationService?.stopTracking();
    _locationService = null;
    _listeners.clear();
    _isTracking = false;
    _currentFoodName = '';
  }
}
