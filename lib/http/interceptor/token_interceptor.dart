import 'package:logistics_app/constants.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:dio/dio.dart';

///获取登录接口返回的token，并添加到请求头中去
class CookieInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var token = await SpUtils.getString(Constants.SP_TOKEN);
    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // var cookieHeader = response.requestOptions.headers[HttpHeaders.cookieHeader];
    // var setCookieHeader = response.requestOptions.headers[HttpHeaders.setCookieHeader];
    // log("CookieInterceptor onResponse cookieHeader=${cookieHeader.toString()}");
    // log("CookieInterceptor onResponse setCookieHeader=${setCookieHeader.toString()}");

    // log("获取返回头：${response.headers.toString()}");
    super.onResponse(response, handler);
  }
}
