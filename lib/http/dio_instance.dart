import 'package:logistics_app/http/interceptor/rsp_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:logistics_app/http/interceptor/print_log_interceptor.dart';
import 'package:oktoast/oktoast.dart';

import 'http_method.dart';
import 'interceptor/token_interceptor.dart';

class DioInstance {
  static DioInstance? _instance;

  DioInstance._internal();

  static DioInstance instance() {
    return _instance ??= DioInstance._internal();
  }

  Dio _dio = Dio();
  final _defaultTimeout = const Duration(seconds: 5);
  var _inited = false;

  void initDio({
    required String baseUrl,
    String? method = HttpMethod.GET,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType = ResponseType.json,
    String? contentType,
  }) async {
    _dio.options = buildBaseOptions(
        method: method,
        baseUrl: baseUrl,
        connectTimeout: connectTimeout ?? _defaultTimeout,
        receiveTimeout: receiveTimeout ?? _defaultTimeout,
        sendTimeout: sendTimeout ?? _defaultTimeout,
        responseType: responseType,
        contentType: contentType);
    _dio.interceptors.add(CookieInterceptor());
    // final cookieJar = CookieJar();
    // _dio.interceptors.add(CookieManager(cookieJar));
    // 拦截日志
    _dio.interceptors.add(PrintLogInterceptor());
    // 添加统一的返回值拦截器
    _dio.interceptors.add(RspInterceptor());

    _inited = true;
  }

  ///get请求方式
  Future<Response> get({
    required String path,
    Map<String, dynamic>? param,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (!_inited) {
      throw Exception("you should call initDio() first!");
    }
    return await _dio.get(path,
        queryParameters: param,
        options: options ??
            Options(
              method: HttpMethod.GET,
              receiveTimeout: _defaultTimeout,
              sendTimeout: _defaultTimeout,
            ),
        cancelToken: cancelToken);
  }

  ///post请求方式
  Future<Response> post(
      {required String path,
      Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) async {
    if (!_inited) {
      throw Exception("you should call initDio() first!");
    }
    var res = await _dio.post(path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options ??
            Options(
              method: HttpMethod.POST,
              receiveTimeout: _defaultTimeout,
              sendTimeout: _defaultTimeout,
            ));
    return res;
  }

  // delete请求方式
  Future<Response> delete(
      {required String path,
      Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) async {
    if (!_inited) {
      throw Exception("you should call initDio() first!");
    }
    var res = await _dio
        .delete(path,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options ??
                Options(
                  method: HttpMethod.DELETE,
                  receiveTimeout: _defaultTimeout,
                  sendTimeout: _defaultTimeout,
                ))
        .then((value) => value);
    print('res:${res.data}');
    return res;
  }

  BaseOptions buildBaseOptions({
    required String baseUrl,
    String? method = HttpMethod.GET,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType = ResponseType.json,
    String? contentType,
  }) {
    return BaseOptions(
        method: method,
        baseUrl: baseUrl,
        connectTimeout: connectTimeout ?? _defaultTimeout,
        receiveTimeout: receiveTimeout ?? _defaultTimeout,
        sendTimeout: sendTimeout ?? _defaultTimeout,
        responseType: responseType,
        contentType: contentType);
  }

  void changeBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }
}
