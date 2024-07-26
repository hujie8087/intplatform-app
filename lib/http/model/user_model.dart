import 'package:logistics_app/http/model/user_info_model.dart';

class UserModel<T> {
  List<String>? permissions;
  List<String>? roles;
  int? code;
  String? msg;
  UserInfoModel? user;
  UserModel.fromJson(dynamic json) {
    permissions = json['permissions'];
    roles = json['roles'];
    user = UserInfoModel.fromJson(json['user']);
    code = json['code'];
    msg = json['msg'];
  }
}
