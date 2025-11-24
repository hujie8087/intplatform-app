///  http_utils.dart
///
///  Created by iotjin on 2020/07/07.
///  description: 网络请求工具类（dio二次封装）

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/sp_utils.dart';

import 'apis.dart';
import 'dio_utils.dart';
import 'error_handle.dart';
import 'intercept.dart';
import 'log_utils.dart';

typedef Success<T> = Function(T data);
typedef Fail = Function(int code, String msg);

// 日志开关
const bool isOpenLog = true;
const bool isOpenAllLog = false;

class HttpUtils {
  /// dio main函数初始化
  static void initDio() {
    final List<Interceptor> interceptors = <Interceptor>[];

    /// 统一添加身份验证请求头
    interceptors.add(AuthInterceptor());

    // 添加公共请求头信息

    /// 打印Log(生产模式去除)
    if (!LogUtils.inProduction && isOpenAllLog) {
      interceptors.add(LoggingInterceptor()); // 调试打开
    }
    configDio(baseUrl: APIs.apiPrefix, interceptors: interceptors);
  }

  static setBaseUrl(String baseUrl) {
    DioUtils.instance.dio.options.baseUrl = baseUrl;
  }

  /// get 请求
  static void get<T>(
    String url,
    Map<String, dynamic>? params, {
    String? loadingText,
    Success? success,
    Fail? fail,
  }) {
    request(
      Method.get,
      url,
      params,
      loadingText: loadingText,
      success: success,
      fail: fail,
    );
  }

  /// post 请求
  static void post<T>(
    String url,
    params, {
    String? loadingText,
    Success? success,
    Fail? fail,
  }) {
    request(
      Method.post,
      url,
      params,
      loadingText: loadingText,
      success: success,
      fail: fail,
    );
  }

  /// put 请求
  static void put<T>(
    String url,
    params, {
    String? loadingText,
    Success? success,
    Fail? fail,
  }) {
    request(
      Method.put,
      url,
      params,
      loadingText: loadingText,
      success: success,
      fail: fail,
    );
  }

  /// patch 请求
  static void patch<T>(
    String url,
    params, {
    String? loadingText,
    Success? success,
    Fail? fail,
  }) {
    request(
      Method.patch,
      url,
      params,
      loadingText: loadingText,
      success: success,
      fail: fail,
    );
  }

  /// delete 请求

  static void delete<T>(
    String url,
    params, {
    String? loadingText,
    Success? success,
    Fail? fail,
  }) {
    request(
      Method.delete,
      url,
      params,
      loadingText: loadingText,
      success: success,
      fail: fail,
    );
  }

  // 上传图片
  static void uploadImage<T>(
    String url,
    FormData formData, {
    String? loadingText,
    Success? success,
    Fail? fail,
  }) {
    if (loadingText != null && loadingText.isNotEmpty) {
      ProgressHUD.showLoadingText(loadingText);
    }
    request(
      Method.post,
      url,
      formData,
      loadingText: loadingText,
      success: success,
      fail: fail,
    );
  }

  /// _request 请求
  static void request<T>(
    Method method,
    String url,
    params, {
    String? loadingText = '加载中...',
    Success? success,
    Fail? fail,
  }) {
    // 参数处理（如果需要加密等统一参数）
    if (!LogUtils.inProduction && isOpenLog) {
      print('---------- HttpUtils URL ----------');
      print(url);
      print('---------- HttpUtils params ----------');
      print(params);
    }

    Object? data;
    Map<String, dynamic>? queryParameters;
    if (method == Method.get) {
      queryParameters = params;
    }
    if (method == Method.post) {
      data = params;
    }
    if (method == Method.put) {
      data = params;
      // queryParameters = params;
    }
    if (loadingText != null && loadingText.isNotEmpty) {
      ProgressHUD.showLoadingText(loadingText);
    }

    DioUtils.instance.request(
      method,
      url,
      data: data,
      queryParameters: queryParameters,
      onSuccess: (result) async {
        if (!LogUtils.inProduction && isOpenLog) {
          print('---------- HttpUtils response ----------');
          print(result.toString() + url);
        }
        dynamic resultData = result;
        if (result is String) {
          resultData = jsonDecode(result);
        }
        if (resultData['code'] == ExceptionHandle.success ||
            resultData['code'].toString() == '1') {
          // ProgressHUD.hide();
          success?.call(result);
        }
        // 未授权或刷新token无效，重新登录
        else if ((resultData['code'] == ExceptionHandle.unauthorized ||
            resultData['code'] == ExceptionHandle.refresh_token_invalid)) {
          ProgressHUD.showText('请登录您的帐号');

          SpUtils.remove(Constants.SP_USER_DEPT);
          SpUtils.remove(Constants.SP_TOKEN);
          SpUtils.remove(Constants.SP_REFRESH_TOKEN);
          RouteUtils.navigateToLogin();
        }
        // token过期，刷新token
        else if (resultData['code'] == ExceptionHandle.token_expired) {
          // 防止多个接口同时 token 过期造成重复刷新
          String refreshToken =
              await SpUtils.getString(Constants.SP_REFRESH_TOKEN) ?? '';

          DataUtils.updateToken(
            {'refreshToken': refreshToken},
            success: (data) async {
              // 假设新 token 存在 data['token']
              final newToken = data['data']['accessToken'];
              final refreshToken = data['data']['refreshToken'];
              await SpUtils.saveString(Constants.SP_TOKEN, newToken);
              await SpUtils.saveString(
                Constants.SP_REFRESH_TOKEN,
                refreshToken,
              );
              // 刷新当前页面
              RouteUtils.refreshCurrentPage();
            },
            fail: (code, msg) {
              // 刷新失败 -> 跳转登录
              ProgressHUD.showText('登录已过期，请重新登录');
              SpUtils.remove(Constants.SP_TOKEN);
              SpUtils.remove(Constants.SP_REFRESH_TOKEN);
              RouteUtils.navigateToLogin();
            },
          );
        } else {
          // 其他状态，弹出错误提示信息
          ProgressHUD.showError(
            resultData['msg'] ?? resultData['message'] ?? '请求失败',
          );
          fail?.call(
            resultData['code'],
            resultData['msg'] ?? resultData['message'] ?? '请求失败',
          );
        }
      },
      onError: (code, msg) {
        if (loadingText != null && loadingText.isNotEmpty) {
          ProgressHUD.hide();
        }
        ProgressHUD.showError(msg);
        fail?.call(code, msg);
      },
    );
  }
}
