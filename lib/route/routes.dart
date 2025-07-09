import 'package:flutter/material.dart';
import 'package:logistics_app/route/route_annotation.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // 使用智能路由生成器，支持注解和手动配置
    return SmartRouteGenerator.generateRoute(settings);
  }
}
