import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/app_check_update_model.dart';
import 'package:logistics_app/http/model/user_consume_model.dart';
import 'package:logistics_app/utils/device_utils.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

class MineViewModel with ChangeNotifier {
  String? userName;
  bool? shouldLogin;
  bool needUpdate = false;
  UpdateInfoData? updateModel;
  UserConsumeInfoData? userConsumeInfo;

  Future initData() async {
    String? name = await SpUtils.getString(Constants.SP_USER_NAME);
    if (name == null || name.isEmpty == true) {
      shouldLogin = true;
    } else {
      userName = name;
      shouldLogin = false;
    }

    notifyListeners();
  }

  ///退出登录
  Future logout() async {
    DataUtils.logout(
      success: (data) {
        // 跳转登录页
        print('success${data}');
        shouldLogin = true;
        //清除缓存
        SpUtils.remove(Constants.SP_USER_NICKNAME);
        SpUtils.remove(Constants.SP_USER_DEPT);
        SpUtils.remove(Constants.SP_TOKEN);
        notifyListeners();
      },
      fail: (code, msg) {
        showToast(S.current.networkError);
      },
    );
  }

  // 用户注销账号
  Future<(bool success, String? message)> cancelAccount() async {
  final completer = Completer<(bool, String?)>();

  DataUtils.cancelUser(
    success: (data) {
      shouldLogin = true;

      // 清除缓存
      SpUtils.remove(Constants.SP_USER_NICKNAME);
      SpUtils.remove(Constants.SP_USER_DEPT);
      SpUtils.remove(Constants.SP_TOKEN);
      SpUtils.remove(Constants.SP_REFRESH_TOKEN);

      notifyListeners();

      // 返回成功，无错误信息
      completer.complete((true, null));
    },
    fail: (code, msg) {
      notifyListeners();

      // 返回失败，并把 msg 传出去
      completer.complete((false, msg));
    },
  );

  return completer.future;
}

  ///检查更新
  Future checkUpdate() async {
    //获取当前app的版本code
    String versionCode = await DeviceUtils.version();
    String versionName = await DeviceUtils.version();
    DataUtils.getAppLastVersion(
      success: (data) {
        updateModel = UpdateInfoData.fromJson(data['data']);
        //线上版本的code
        Version oldVersion = Version.parse(versionName);
        Version newVersion = Version.parse(updateModel!.versionName ?? '');
        try {
          //如果当前版本小于线上版本，需要更新
          if (oldVersion == newVersion) {
            SpUtils.saveString(
              Constants.SP_NEW_APP_VERSION,
              updateModel?.versionName ?? '',
            );
          } else {
            SpUtils.saveString(Constants.SP_NEW_APP_VERSION, versionCode);
          }
          needUpdate = oldVersion < newVersion;
          notifyListeners();
        } catch (e) {
          SpUtils.saveString(Constants.SP_NEW_APP_VERSION, versionCode);
          notifyListeners();
        }
      },
    );
  }

  ///跳转到外部浏览器打开
  Future jumpToOutLink(String? url) async {
    final uri = Uri.parse(url ?? "");
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri);
    }
    return null;
  }
}
