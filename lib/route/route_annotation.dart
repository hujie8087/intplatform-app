import 'package:flutter/material.dart';
import 'package:logistics_app/route/auto_route_generator.dart';
import 'package:logistics_app/pages/auth/login_page.dart';

/// 路由注解
/// 用于标记页面类，自动生成路由配置
class AppRoute {
  final String path;
  final String? name;
  final Map<String, dynamic>? defaultArguments;

  const AppRoute({required this.path, this.name, this.defaultArguments});
}

/// 路由注册器
/// 用于自动注册带有 @AppRoute 注解的页面
class RouteRegistrar {
  static final Map<String, RouteConfig> _routes = {};

  /// 注册路由
  static void registerRoute(String path, RouteConfig config) {
    _routes[path] = config;
  }

  /// 获取所有路由
  static Map<String, RouteConfig> getRoutes() {
    return _routes;
  }

  /// 检查路由是否存在
  static bool hasRoute(String path) {
    return _routes.containsKey(path);
  }

  /// 获取路由配置
  static RouteConfig? getRoute(String path) {
    return _routes[path];
  }

  /// 清除所有路由
  static void clear() {
    _routes.clear();
  }
}

/// 路由配置类
class RouteConfig {
  final WidgetBuilder builder;
  final String name;
  final Map<String, dynamic>? defaultArguments;

  RouteConfig({
    required this.builder,
    required this.name,
    this.defaultArguments,
  });
}

/// 路由生成器
class SmartRouteGenerator {
  /// 生成路由
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // 首先尝试从自动注册器获取
    final autoConfig = RouteRegistrar.getRoute(settings.name ?? '');
    if (autoConfig != null) {
      return MaterialPageRoute(builder: autoConfig.builder, settings: settings);
    }

    // 如果自动注册器中没有，则从手动配置中获取
    final manualConfig = AutoRouteGenerator.getRouteConfig(settings.name ?? '');
    if (manualConfig != null) {
      return MaterialPageRoute(
        builder: manualConfig.builder,
        settings: settings,
      );
    }

    // 默认返回登录页
    return MaterialPageRoute(
      builder: (context) => LoginPage(),
      settings: settings,
    );
  }

  /// 获取所有路由名称
  static List<String> getAllRouteNames() {
    final autoRoutes = RouteRegistrar.getRoutes().keys.toList();
    final manualRoutes = AutoRouteGenerator.getAllRouteNames();
    return [...autoRoutes, ...manualRoutes];
  }

  /// 检查路由是否存在
  static bool hasRoute(String routeName) {
    return RouteRegistrar.hasRoute(routeName) ||
        AutoRouteGenerator.hasRoute(routeName);
  }
}
