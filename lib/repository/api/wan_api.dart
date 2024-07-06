import 'dart:math';

import 'package:dio/dio.dart';
import 'package:logistics_app/http/dio_instance.dart';
import 'package:logistics_app/repository/model/login_info_model.dart';
import 'package:logistics_app/repository/model/notice_list_model.dart';
import 'package:logistics_app/repository/model/user_info_model.dart';

import '../model/app_check_update_model.dart';

class WanApi {
  static WanApi? _instance;

  WanApi._internal();

  static WanApi instance() {
    return _instance ??= WanApi._internal();
  }

  ///登录
  Future<LoginInfoModel?> login(String? name, String? pwd) async {
    Response response = await DioInstance.instance()
        .post(path: "/auth/login", data: {"username": name, "password": pwd});
    print(response.data);
    return LoginInfoModel.fromJson(response.data);
  }

// 获取用户信息
  Future<UserInfoModel> getUserInfo() async {
    Response response =
        await DioInstance.instance().get(path: "/system/user/getInfo");
    return UserInfoModel.fromJson(response.data);
  }

  // 退出登录
  Future<bool> logout() async {
    Response response =
        await DioInstance.instance().delete(path: "/auth/logout");
    return response.data == true;
  }

  ///检查app新版本
  Future<AppCheckUpdateModel?> checkUpdate() async {
    DioInstance.instance().changeBaseUrl("https://www.pgyer.com/");
    Response response = await DioInstance.instance()
        .post(path: "apiv2/app/check", queryParameters: {
      "_api_key": "57c543d258a34f8565748561de50b6e6",
      "appKey": "2639f784ce9ee850532074b7b0534e62"
    });

    DioInstance.instance().changeBaseUrl("https://www.wanandroid.com/");

    return AppCheckUpdateModel.fromJson(response.data);
  }

  ///通知公共列表
  Future<List<NoticeModel?>?> noticeList() async {
    Response response =
        await DioInstance.instance().get(path: '/system/notice/list');
    var model = NoticeListModel.fromJson(response.data);
    return model.data;
  }
}
