import 'package:flutter/material.dart';
import 'package:logistics_app/pages/auth/login_page.dart';
import 'package:logistics_app/pages/app_home_screen.dart'
    show currentAppHomeScreenState;

class RouteUtils {
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
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  // 自定义路由动态跳转
  static Future pushForPageRoute(BuildContext context, Route route) {
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
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  // 关闭当前页
  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  // 关闭当前页，包含返回值
  static void popWithResult<T extends Object?>(
    BuildContext context, {
    T? result,
  }) {
    Navigator.of(context).pop(result);
  }

  // 导航到登录页
  static void navigateToLogin() {
    push(context, LoginPage());
  }

  // 刷新当前页面
  static void refreshCurrentPage() {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    final currentContext = context;

    // 获取当前路由
    final route = ModalRoute.of(currentContext);
    print('route: ${route}');

    // 如果 route 为 null，说明可能是 tabbar 页面（不是通过 Navigator 管理的）
    if (route == null) {
      // 尝试通过全局 state 引用刷新当前 tab
      if (currentAppHomeScreenState != null) {
        currentAppHomeScreenState!.refreshCurrentTab();
        return;
      }

      // 如果找不到 AppHomeScreen，直接返回
      print('无法找到 AppHomeScreen，无法刷新 tabbar 页面');
      return;
    }

    // 如果路由有名称，使用 pushReplacementNamed 刷新
    if (route.settings.name != null && route.settings.name!.isNotEmpty) {
      navigator.pushReplacementNamed(
        route.settings.name!,
        arguments: route.settings.arguments,
      );
    } else {
      // 如果没有名称，尝试获取当前路由的 Widget 并重新构建
      // 通过 Navigator 的 canPop 判断，如果可以返回则先返回再重新 push
      // 但这种方法需要知道当前页面是什么
      // 更实用的方法：使用一个全局事件通知页面刷新
      // 或者简单地重新加载数据（通过状态管理）

      // 这里使用一个折中方案：如果当前路由是 MaterialPageRoute，
      // 尝试通过重新构建来实现刷新
      if (route is MaterialPageRoute) {
        // 获取当前路由的 Widget builder
        final builder = route.builder;
        // 使用 pushReplacement 替换当前路由
        navigator.pushReplacement(
          MaterialPageRoute(builder: builder, settings: route.settings),
        );
      }
    }
  }
}
