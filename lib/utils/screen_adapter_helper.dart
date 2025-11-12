import 'package:flutter/material.dart';

// 扩展int以方便使用
extension IntFix on int {
  double get px => ScreenAdapterHelper.getPx(toDouble());
}

extension DoubleFix on double {
  double get px => ScreenAdapterHelper.getPx(this);
}

// 屏幕适配工具类
class ScreenAdapterHelper {
  // 写一个适应屏幕尺寸的方法
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double pixelRatio;
  static late double ratio;

  static void init(
    BuildContext context, {
    double designWidth = 375.0,
    double designHeight = 812.0,
    double maxWidth = 500.0,
  }) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    pixelRatio = _mediaQueryData.devicePixelRatio;
    // 限制最大宽度（比如 Web/PC 端）
    final limitedWidth = screenWidth > maxWidth ? maxWidth : screenWidth;
    ratio = limitedWidth / designWidth;
  }

  static double getPx(double size) {
    return size * ScreenAdapterHelper.ratio;
  }

  static int getPxInt(double size) {
    return (size * ScreenAdapterHelper.ratio).toInt();
  }
}
