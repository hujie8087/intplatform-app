import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';
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
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor ?? primaryColor,
          borderRadius: BorderRadius.circular(10)
        ),
        margin: EdgeInsets.all(50),
        child: Row(
          children: [
            icon,
            SizedBox(width: 10,),
            Text(title,style: TextStyle(color: color),)
          ],
        ),
      ),
      position:ToastPosition()
    );
  }

  static void dismissAll() {
    dismissAllToast();
  }
}
