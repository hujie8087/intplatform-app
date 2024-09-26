import 'package:logistics_app/http/apis.dart';

import '/http/http_utils.dart';

typedef Success<T> = Function(T data);
typedef Fail = Function(int code, String msg);

class ShoppingUtils {
  // 获取门店列表数据
  static void getRestaurantList<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(APIs.getRestaurantList, parameters,
        success: success, fail: fail);
  }

  // 获取门店详情
  static void getRestaurantDetail<T>(
    id, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(APIs.getRestaurantDetail + '/' + id, null,
        success: success, fail: fail);
  }

  // 获取门店菜单
  static void getRestaurantMenu<T>(
    id, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(APIs.getRestaurantDetail + '/' + id, null,
        success: success, fail: fail);
  }
}
