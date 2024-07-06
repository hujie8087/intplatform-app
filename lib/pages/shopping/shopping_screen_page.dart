import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';

class ShoppingScreenPage extends StatefulWidget {
  @override
  _ShoppingScreenPage createState() => _ShoppingScreenPage();
}

class _ShoppingScreenPage extends State<ShoppingScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Text(
          '功能开发中，敬请期待！',
          style: TextStyle(color: secondaryColor, fontSize: 28),
        ),
      ),
    );
  }
}
