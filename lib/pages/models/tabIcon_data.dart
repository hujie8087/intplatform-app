import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
    this.labelName = '',
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;
  String labelName;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/images/tab_1.png',
      selectedImagePath: 'assets/images/tab_1s1.png',
      index: 0,
      isSelected: true,
      animationController: null,
      labelName: '首页',
    ),
    TabIconData(
      imagePath: 'assets/images/tab_tool1.png',
      selectedImagePath: 'assets/images/tab_tool21.png',
      index: 1,
      isSelected: false,
      animationController: null,
      labelName: '工具箱',
    ),
    // TabIconData(
    //   imagePath: 'assets/images/tab_2.png',
    //   selectedImagePath: 'assets/images/tab_2s.png',
    //   index: 1,
    //   isSelected: false,
    //   animationController: null,
    //   labelName: '购物',
    // ),
    // TabIconData(
    //   imagePath: 'assets/images/tab_3.png',
    //   selectedImagePath: 'assets/images/tab_3s.png',
    //   index: 2,
    //   isSelected: false,
    //   animationController: null,
    //   labelName: '影视',
    // ),
    TabIconData(
      imagePath: 'assets/images/tab_4.png',
      selectedImagePath: 'assets/images/tab_4s1.png',
      index: 2,
      isSelected: false,
      animationController: null,
      labelName: '我的',
    ),
  ];
}
