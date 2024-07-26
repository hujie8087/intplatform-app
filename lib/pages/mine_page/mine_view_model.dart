import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MineViewModel with ChangeNotifier {
  String? userName;
  bool? shouldLogin;
  bool needUpdate = false;

  Future initData() async {
    String? name = await SpUtils.getString(Constants.SP_USER_NAME);
    log("MineViewModel $name");
    if (name == null || name.isEmpty == true) {
      userName = "未登录";
      shouldLogin = true;
    } else {
      userName = name;
      shouldLogin = false;
    }

    //是否显示更新红点
    shouldShowUpdateDot();

    notifyListeners();
  }

  ///退出登录
  Future logout() async {
    DataUtils.logout(
      success: (data) {
        // 跳转登录页
        print('success${data}');
        userName = "未登录";
        shouldLogin = true;
        //清除缓存
        SpUtils.remove(Constants.SP_USER_NAME);
        SpUtils.remove(Constants.SP_USER_DEPT);
        SpUtils.remove(Constants.SP_TOKEN);
        notifyListeners();
      },
      fail: (code, msg) {
        showToast("网络异常");
      },
    );
  }

  Future shouldShowUpdateDot() async {
    var packInfo = await PackageInfo.fromPlatform();
    //获取当前app的版本code
    String versionCode = packInfo.buildNumber;
    //获取保存的新版本code
    // String newVerCode = await SpUtils.getString(Constants.SP_NEW_APP_VERSION);
    String newVerCode = "1";
    if ((int.tryParse(versionCode) ?? 0) >= (int.tryParse(newVerCode) ?? 0)) {
      //当前已是最新版本
      needUpdate = false;
    } else {
      //有新版本，显示红点
      needUpdate = true;
    }
  }

  ///检查更新
  Future<String?> checkUpdate() async {
    var packInfo = await PackageInfo.fromPlatform();
    //获取当前app的版本code
    String versionCode = packInfo.buildNumber;
    print(versionCode);
    return null;
    // AppCheckUpdateModel? model = await WanApi.instance().checkUpdate();
    // //线上版本的code
    // String onlineAppVerCode = model?.data?.buildVersionNo ?? "0";
    // try {
    //   //如果当前版本小于线上版本，需要更新
    //   if ((int.tryParse(versionCode) ?? 0) < ((int.tryParse(onlineAppVerCode) ?? 0))) {
    //     SpUtils.saveString(Constants.SP_NEW_APP_VERSION, onlineAppVerCode);
    //     return model?.data?.downloadURL;
    //   } else {
    //     SpUtils.saveString(Constants.SP_NEW_APP_VERSION, versionCode);
    //     return null;
    //   }
    // } catch (e) {
    //   log("checkUpdate error=$e");
    //   SpUtils.saveString(Constants.SP_NEW_APP_VERSION, versionCode);
    //   return null;
    // }
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
