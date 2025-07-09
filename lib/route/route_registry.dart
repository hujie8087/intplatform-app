import 'package:logistics_app/route/route_annotation.dart';

/// 路由注册管理器
/// 用于统一管理所有使用 @AppRoute 注解的页面路由
class RouteRegistry {
  /// 注册所有注解路由
  static void registerAllAnnotatedRoutes() {
    // 购物相关页面
    _registerShoppingRoutes();

    // 可以添加更多模块的路由注册
    // _registerNewsRoutes();
    // _registerRepairRoutes();
    // 等等...
  }

  /// 注册购物相关路由
  static void _registerShoppingRoutes() {
    // 可以添加更多购物相关页面
    // RouteRegistrar.registerRoute(
    //   'food_suggestion_page',
    //   RouteConfig(
    //     builder: (context) => FoodSuggestionPage(),
    //     name: '我要吃',
    //   ),
    // );
  }

  /// 检查特定路由是否已注册
  static bool isRouteRegistered(String path) {
    return RouteRegistrar.hasRoute(path);
  }

  /// 获取路由配置
  static RouteConfig? getRouteConfig(String path) {
    return RouteRegistrar.getRoute(path);
  }

  /// 清除所有注解路由
  static void clearAllAnnotatedRoutes() {
    RouteRegistrar.clear();
  }
}
