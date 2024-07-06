import 'package:dio/dio.dart';
import 'package:logistics_app/http/rows_model.dart';
import 'package:oktoast/oktoast.dart';
import '../base_model.dart';

///处理返回值拦截器
class RspInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    //修改未登录的错误码为-403，其他错误码为500，成功为200，建议对errorCode 判断当不为200的时候，均为错误。
    if (response.statusCode == 200) {
      var rsp = BaseModel.fromJson(response.data);
      if (rsp.code == 200) {
        if (rsp.data == null) {
          var rsp1 = RowsModel.fromJson(response.data);
          if (rsp1.rows == null) {
            handler.next(
                Response(requestOptions: response.requestOptions, data: true));
          } else {
            handler.next(Response(
                requestOptions: response.requestOptions, data: rsp1.rows));
          }
        } else {
          handler.next(Response(
              requestOptions: response.requestOptions, data: rsp.data));
        }
      } else if (rsp.code == 403) {
        showToast("请先登录");
        handler.reject(DioException(
            requestOptions: response.requestOptions, message: "未登录"));
      } else {
        handler.reject(DioException(requestOptions: response.requestOptions));
      }
    } else {
      handler.reject(DioException(
          requestOptions: response.requestOptions, message: "网络连接错误"));
    }
  }
}
