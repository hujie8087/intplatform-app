import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
    this.labelName = '',
    this.unreadCount = 0,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;
  String labelName;
  int unreadCount;
  AnimationController? animationController;
}
