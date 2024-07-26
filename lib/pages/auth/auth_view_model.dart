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
      SpUtils.saveString(Constants.SP_TOKEN, token ?? "");
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
}
