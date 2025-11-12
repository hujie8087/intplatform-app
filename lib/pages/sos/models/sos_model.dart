import 'package:flutter/material.dart';
import 'package:logistics_app/http/model/user_info_model.dart';

class SosModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  UserInfoModel? userInfo;
  // 部门电话号码
  static const String DEPARTMENT_PHONE_NUMBER = '110';
  // 表单字段
  final reportLocationController = TextEditingController();
  final reportDescriptionController = TextEditingController();
  final reportByController = TextEditingController();
  final telController = TextEditingController();
}
