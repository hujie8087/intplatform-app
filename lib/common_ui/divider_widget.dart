import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key, this.height});

  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 1,
      color: Colors.grey[200],
    );
  }
}
