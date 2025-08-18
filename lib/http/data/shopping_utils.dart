import 'package:logistics_app/http/apis.dart';

import '/http/http_utils.dart';

typedef Success<T> = Function(T data);
typedef Fail = Function(int code, String msg);

class ShoppingUtils {
  // 获取门店列表数据
  static void getRestaurantList<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      APIs.getRestaurantList,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取热门菜品
  static void getHotFoodList<T>({Success? success, Fail? fail}) {
    HttpUtils.get(APIs.getHotFoodList, null, success: success, fail: fail);
  }

  // 获取门店详情
  static void getRestaurantDetail<T>(id, {Success? success, Fail? fail}) {
    HttpUtils.get(
      APIs.getRestaurantDetail + '/' + id,
      null,
      success: success,
      fail: fail,
    );
  }

  // 获取门店菜单
  static void getRestaurantMenu<T>(id, {Success? success, Fail? fail}) {
    HttpUtils.get(
      APIs.getRestaurantDetail + '/' + id,
      null,
      success: success,
      fail: fail,
    );
  }

  // 获取门店配送时间
  static void getRestaurantDeliveryTime<T>(id, {Success? success, Fail? fail}) {
    HttpUtils.get(
      APIs.getRestaurantDeliveryTime + '/' + id.toString(),
      null,
      success: success,
      fail: fail,
    );
  }

  // 获取门店配送费用
  static void getRestaurantDeliveryFee<T>(id, {Success? success, Fail? fail}) {
    HttpUtils.get(
      APIs.getRestaurantDeliveryFee + '/' + id.toString(),
      null,
      success: success,
      fail: fail,
    );
  }

  // 获取餐厅所有配送方式
  static void getCanteenPickupType<T>(id, {Success? success, Fail? fail}) {
    HttpUtils.get(APIs.getAllPickupType, null, success: success, fail: fail);
  }

  // 获取卡信息
  static void getCardInfo<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(APIs.getCardInfo, parameters, success: success, fail: fail);
  }

  // 获取支付二维码
  static void getPayQrCode<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(APIs.getPayQrCode, parameters, success: success, fail: fail);
  }

  // 解析支付二维码
  static void parsePayQrCode<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      APIs.parsePayQrCode,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 处理支付二维码
  static void processPaymentQRCode<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.post(APIs.pay, parameters, success: success, fail: fail);
  }

  // 挂失消费卡
  static void disableCard<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(APIs.disableCard, parameters, success: success, fail: fail);
  }

  // 解挂消费卡
  static void enableCard<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(APIs.enableCard, parameters, success: success, fail: fail);
  }

  // 验证支付密码
  static void verifyPayPassword<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      APIs.verifyPayPassword,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 修改支付密码
  static void updatePayPassword<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      APIs.updatePayPassword,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 查询账单
  static void getBill<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(APIs.getBill, parameters, success: success, fail: fail);
  }

  // 修改支付密码
  static void modifyPaymentPassword(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.post(
      APIs.modifyPaymentPassword,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 提交订单
  static void submitOrder<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(APIs.submitOrder, parameters, success: success, fail: fail);
  }

  // 删除订单
  static void deleteOrder<T>(ids, {Success? success, Fail? fail}) {
    HttpUtils.delete(
      APIs.deleteOrder + '/' + ids,
      null,
      success: success,
      fail: fail,
    );
  }

  // 点赞
  static void addCount<T>(id, {Success? success, Fail? fail}) {
    HttpUtils.get(
      APIs.addCount + '/' + id.toString(),
      null,
      success: success,
      fail: fail,
    );
  }

  // 获取美食推荐
  static void getFoodRecommend<T>({Success? success, Fail? fail}) {
    HttpUtils.get(APIs.getFoodRecommend, null, success: success, fail: fail);
  }

  // 获取今日菜谱
  static void getTodayMenu<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(APIs.getTodayMenu, parameters, success: success, fail: fail);
  }
}
