///  intercept.dart
///
///  Created by iotjin on 2020/07/08.
///  description:  拦截器

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/utils/device_utils.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'apis.dart';
import 'error_handle.dart';
import 'log_utils.dart';

// default token
const String defaultToken = '';

Future<String> getToken() async {
  var token = await SpUtils.getString(Constants.SP_TOKEN) ?? defaultToken;
  return token;
}

Future<String> getRefreshToken() async {
  var refreshToken =
      await SpUtils.getString(Constants.SP_REFRESH_TOKEN) ?? defaultToken;
  return refreshToken;
}

void setToken(accessToken) {
  SpUtils.saveString(Constants.SP_TOKEN, accessToken);
}

void setRefreshToken(refreshToken) {
  SpUtils.saveString(Constants.SP_REFRESH_TOKEN, refreshToken);
}

/// 统一添加身份验证请求头（根据项目自行处理）
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path != APIs.login) {
      String token = await getToken();
      String refreshToken = await getRefreshToken();
      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        options.headers['access_token'] = token;
        options.headers['refresh_token'] = refreshToken;
      }
    }

    options.headers['product_code'] = 'intplatform';
    options.headers['platform'] = 'app';
    options.headers['version_name'] = '2.0.1';
    options.headers['version_code'] = 201;
    options.headers['os'] =
        DeviceUtils.isAndroid
            ? 'android'
            : DeviceUtils.isIOS
            ? 'ios'
            : 'web';
    super.onRequest(options, handler);
  }
}

/// 打印日志
class LoggingInterceptor extends Interceptor {
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTime = DateTime.now();
    LogUtils.d('-------------------- Start --------------------');
    if (options.queryParameters.isEmpty) {
      LogUtils.d('RequestUrl: ${options.baseUrl}${options.path}');
    } else {
      LogUtils.d(
        'RequestUrl: ${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}',
      );
    }
    LogUtils.d('RequestMethod: ${options.method}');
    LogUtils.d('RequestHeaders:${options.headers}');
    LogUtils.d('RequestContentType: ${options.contentType}');
    LogUtils.d('RequestData: ${options.data.toString()}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _endTime = DateTime.now();
    final int duration = _endTime.difference(_startTime).inMilliseconds;
    if (response.statusCode == ExceptionHandle.success) {
      LogUtils.d('ResponseCode: ${response.statusCode}');
    } else {
      LogUtils.e('ResponseCode: ${response.statusCode}');
    }
    // 输出结果
    LogUtils.d('返回数据：${response.data}');
    LogUtils.d('-------------------- End: $duration 毫秒 --------------------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LogUtils.d('-------------------- Error --------------------');
    super.onError(err, handler);
  }
}
