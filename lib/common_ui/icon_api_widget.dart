import 'package:flutter/material.dart';

// 定义一个字符串到 IconData 的映射表
final Map<String, IconData> iconMap = {
  'home': Icons.home,
  'favorite': Icons.favorite,
  'settings': Icons.settings,
  'account': Icons.account_circle,
  'local_airport': Icons.local_airport,
  'person_add': Icons.person_add,
  'book': Icons.book,
  'emoji_food_beverage': Icons.emoji_food_beverage,
  'shopping_cart': Icons.shopping_cart,
  'local_hospital': Icons.local_hospital,
  'info_outline': Icons.info_outline,
  'sticky_note_2': Icons.sticky_note_2,
  'local_library': Icons.local_library,
  'announcement': Icons.announcement
  // 添加更多你需要的图标映射
};

class IconApiWidget extends StatelessWidget {
  final String iconName;

  IconApiWidget({required this.iconName});

  @override
  Widget build(BuildContext context) {
    // 根据图标名称获取 IconData，如果找不到，则返回一个默认的图标
    IconData iconData = iconMap[iconName] ?? Icons.help_outline;
    return Icon(iconData);
  }
}
