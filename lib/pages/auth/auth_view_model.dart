import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/route/routes.dart';
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
      ProgressHUD.showError(S.current.inputMessage(S.current.userName));
      return false;
    }

    if (inputPassword?.trim().isEmpty == true) {
      ProgressHUD.showError(S.current.inputMessage(S.current.password));
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
            SpUtils.saveInt(Constants.SP_IS_LOGIN, userInfo.user?.isLogin ?? 0);
            getAddressData();
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

// 获取区域楼栋数据
  void getAddressData() async {
    int? buildingVersion = await SpUtils.getInt('buildingVersion');
    int newBuildingVersion = 0;
    Object? buildingData = await SpUtils.getModel('building');
    DataUtils.getBuildingVersion(
      success: (data) {
        newBuildingVersion = data['data']['version'];
        if (buildingVersion == null ||
            newBuildingVersion != buildingVersion ||
            buildingData == null) {
          SpUtils.saveInt('buildingVersion', newBuildingVersion);
          DataUtils.getBuildingTree(
            success: (data) {
              BaseModel rowsModel = BaseModel.fromJson(data);
              if (rowsModel.data != null) {
                SpUtils.saveModel('building', rowsModel.data);
              }
            },
          );
        }
      },
      fail: (code, msg) {
        ProgressHUD.showError(S.current.networkError);
      },
    );
  }

  Future<void> forgetPassword(
      BuildContext context, Map<String, dynamic> params) async {
    if (params['userName']?.trim().isEmpty == true) {
      ProgressHUD.showError(S.of(context).inputMessage(S.of(context).userName));
      return;
    }
    if (params['card']?.trim().isEmpty == true) {
      ProgressHUD.showError(S.of(context).inputIdCard);
      return;
    }
    if (params['newPassword']?.trim().isEmpty == true) {
      ProgressHUD.showError(S.of(context).inputNewPassword);
      return;
    }
    if (params['confirmPassword']?.trim().isEmpty == true) {
      ProgressHUD.showError(S.of(context).inputConfirmPassword);
      return;
    }
    if (params['confirmPassword']?.trim() != params['newPassword']?.trim()) {
      ProgressHUD.showError(S.of(context).inputDifferentPassword);
      return;
    }
    DataUtils.forgetPassword({
      'userName': params['userName'],
      'newPassword': params['newPassword'],
      'card': params['card']
    }, success: (res) {
      print(res.toString());
      RouteUtils.pushNamed(context, RoutePath.login);
    }, fail: (code, msg) {
      ProgressHUD.showError(msg);
      return;
    });
    return;
  }
}
