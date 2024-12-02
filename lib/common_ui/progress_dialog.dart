import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

/// 加载中的弹框
class ProgressDialog extends Dialog {
  const ProgressDialog({
    Key? key,
    this.hintText = '',
  }) : super(key: key);

  final String hintText;

  @override
  Widget build(BuildContext context) {
    Widget progress = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Theme(
          data: ThemeData(
            cupertinoOverrideTheme: const CupertinoThemeData(
              brightness: Brightness.dark, // 局部指定夜间模式，加载圈颜色会设置为白色
            ),
          ),
          child: const CupertinoActivityIndicator(radius: 14.0),
        ),
        SizedBox(height: 8.px),
        Text(hintText, style: const TextStyle(color: Colors.white))
      ],
    );

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: 88.px,
          width: 120.px,
          decoration: ShapeDecoration(
            color: const Color(0xFF3A3A3A),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.px))),
          ),
          child: progress,
        ),
      ),
    );
  }
}
