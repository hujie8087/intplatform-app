import 'package:flutter/cupertino.dart';
import 'package:logistics_app/repository/api/wan_api.dart';
import 'package:logistics_app/repository/model/login_info_model.dart';
import 'package:logistics_app/repository/model/user_info_model.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';

import '../../constants.dart';

class AuthViewModel with ChangeNotifier {
  String? inputUserName = "admin";
  String? inputPassword = "admin123";

  Future<bool> login() async {
    if (inputUserName?.trim().isEmpty == true) {
      showToast("请输入账号");
      return false;
    }

    if (inputPassword?.trim().isEmpty == true) {
      showToast("请输入密码");
      return false;
    }

    LoginInfoModel? loginInfo =
        await WanApi.instance().login(inputUserName, inputPassword);
    print(loginInfo);
    if (loginInfo?.access_token != null) {
      SpUtils.saveString(Constants.SP_TOKEN, loginInfo?.access_token ?? "");
      UserInfoModel userInfo = await WanApi.instance().getUserInfo();
      SpUtils.saveString(Constants.SP_USER_NAME, userInfo.user?.userName ?? '');
      SpUtils.saveString(
          Constants.SP_USER_DEPT, userInfo.user?.dept?.deptName ?? '');
      return true;
    } else {
      showToast("登录异常");
      return false;
    }
  }
}
