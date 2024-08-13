import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';

import '../../constants.dart';

class AuthViewModel with ChangeNotifier {
  String? inputUserName = "";
  String? inputPassword = "";
  String? confirmPassword = "";
  String? nickName = "";
  Future<bool> login() async {
    if (inputUserName?.trim().isEmpty == true) {
      showToast("请输入账号");
      return false;
    }

    if (inputPassword?.trim().isEmpty == true) {
      showToast("请输入密码");
      return false;
    }
    final Completer<bool> completer = Completer<bool>();

    // LoginInfoModel? loginInfo =
    //     await WanApi.instance().login(inputUserName, inputPassword);
    DataUtils.login({'username': inputUserName, 'password': inputPassword},
        success: (res) async {
      var token = res['data']['access_token'];
      await SpUtils.saveString(Constants.SP_TOKEN, token ?? "");
      if (token != '') {
        DataUtils.getUserInfo(
          success: (res) async {
            UserInfoModel userInfo = UserInfoModel.fromJson(res['data']);
            await SpUtils.saveModel('userInfo', userInfo);
            SpUtils.saveString(
                Constants.SP_USER_NAME, userInfo.user?.nickName ?? '');
            SpUtils.saveString(
                Constants.SP_USER_DEPT, userInfo.user?.dept?.deptName ?? '');
            completer.complete(true);
          },
          fail: (code, msg) {
            completer.complete(false);
          },
        );
      }
      return true;
    }, fail: (code, msg) {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });
    return completer.future;
  }

  Future<bool> register() async {
    if (nickName?.trim().isEmpty == true) {
      showToast("请输入您的姓名");
      return false;
    }

    if (inputUserName?.trim().isEmpty == true) {
      showToast("请输入账号");
      return false;
    }

    if (inputPassword?.trim().isEmpty == true) {
      showToast("请输入密码");
      return false;
    }

    if (confirmPassword?.trim().isEmpty == true) {
      showToast("请输入确认密码");
      return false;
    }

    if (confirmPassword?.trim() != inputPassword?.trim()) {
      showToast("输入的两次密码不同");
      return false;
    }
    final Completer<bool> completer = Completer<bool>();

    DataUtils.register({
      'userName': inputUserName,
      'password': inputPassword,
      'nickName': nickName
    }, success: (res) async {
      print(res);
      showToast("注册成功");
      completer.complete(true);
      return true;
    }, fail: (code, msg) {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });
    return completer.future;
  }
}
