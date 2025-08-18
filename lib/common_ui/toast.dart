import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:oktoast/oktoast.dart';

class Toast {
  Toast._();

  static Future showToast({
    required Color color,
    required Icon icon,
    required String title,
    Color? backgroundColor,
    Duration? duration,
  }) async {
    showToastWidget(
        Container(
          padding: EdgeInsets.all(16.px),
          decoration: BoxDecoration(
              color: backgroundColor ?? primaryColor,
              borderRadius: BorderRadius.circular(8.px)),
          margin: EdgeInsets.all(40.px),
          child: Row(
            children: [
              icon,
              SizedBox(
                width: 10.px,
              ),
              Text(
                title,
                style: TextStyle(color: color),
              )
            ],
          ),
        ),
        position: ToastPosition());
  }

  static void dismissAll() {
    dismissAllToast();
  }
}
