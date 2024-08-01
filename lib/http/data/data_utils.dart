///  data_utils.dart
///
///  Created by iotjin on 2021/04/01.
///  description:  项目数据请求 管理类

import 'package:dio/dio.dart';

import '/http/apis.dart';
import '/http/http_utils.dart';

typedef Success<T> = Function(T data);
typedef Fail = Function(int code, String msg);

class DataUtils {
  /// 登录
  static void login<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.post(APIs.login, parameters, success: success, fail: fail);
  }

  static void logout<T>({
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.delete(APIs.logout, null, success: success, fail: fail);
  }

  // 获取用户信息
  static void getUserInfo<T>({
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(APIs.getUserInfo, null, success: success, fail: fail);
  }

  // 编辑用户信息
  static void editUserInfo(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put(APIs.editUser, parameters, success: success, fail: fail);
  }

  // 用户修改密码
  static void updateUserPwd<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put(APIs.updateUserPwd, parameters, success: success, fail: fail);
  }

  // 储存用户设置token
  static void setUserToken<T>(
    token, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put(APIs.addToken, {'mobilePhoneId': token},
        success: success, fail: fail);
  }

  /// 分页加载数据
  static void getPageList<T>(
    url,
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(url, parameters, success: success, fail: fail);
  }

  /// 分页加载分组数据
  static void getPageGroupList<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(APIs.getGroupPage, parameters, success: success, fail: fail);
  }

  // 获取生活区楼栋房间
  static void getBuildingTree<T>({Success? success, Fail? fail, s}) {
    HttpUtils.get('/commonality/food/building/app/tree', null,
        loadingText: '生活区数据加载中...', success: success, fail: fail);
  }

  // 上传文件
  static void uploadFile<T>(
    FormData formData, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.post('/file/upload', formData, success: success, fail: fail);
  }

  // 获取数据字典
  static void getDictDataList<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(APIs.getDictDataList + parameters, null,
        success: success, fail: fail);
  }

  // 获取公共便利数据
  static void getOtherDataList(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(APIs.getOtherDataList, parameters,
        success: success, fail: fail);
  }
}
