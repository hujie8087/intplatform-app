
import 'package:flutter/material.dart';

class RouteUtils{
  RouteUtils._();
  static final navigatorKey = GlobalKey<NavigatorState>();

  // app 根节点Context
  static BuildContext get context => navigatorKey.currentState!.context;

  static NavigatorState get navigator => navigatorKey.currentState!;
  
  // 普通静态跳转
  static Future push(
    BuildContext context,
    Widget page, {
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        allowSnapshotting: allowSnapshotting,
        barrierDismissible: barrierDismissible,
      ),
    );
  }
  // 根据路由路径跳转
  static Future pushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(context,routeName, arguments: arguments);
  }
  
  // 自定义路由动态跳转
  static Future pushForPageRoute(
    BuildContext context,
    Route route,
  ) {
    return Navigator.push(context, route);
  }

  // 清空栈，只留目标页面
  static Future pushAndRemoveUntil(
    BuildContext context,
    Widget page, {
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
  }) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => page,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        allowSnapshotting: allowSnapshotting,
        barrierDismissible: barrierDismissible,
      ),
      (route) => false,
    );
  }

  // 用新的路由替换当前路由
  static Future pushReplacement(
    BuildContext context,
    Route rote, {
      Object? result,
  }) {
    return Navigator.pushReplacement(context, rote, result: result);
  }
  // 用新的路由替换当前路由
  static Future pushReplacementNamed(
    BuildContext context,
    String routeName, {
      Object? result,
      Object? arguments,
  }) {
    return Navigator.pushReplacementNamed(context, routeName, arguments: arguments,result: result);
  }

  // 关闭当前页
  static void pop(
    BuildContext context) {
    Navigator.pop(context);
  }

  // 关闭当前页，包含返回值
  static void popWithResult<T extends Object?>(
    BuildContext context, {
    T? result,
  }) {
    Navigator.of(context).pop(result);
  }
}