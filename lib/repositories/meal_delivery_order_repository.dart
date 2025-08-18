import 'dart:async';

import 'package:logistics_app/http/data/meal_delivery_utils.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';

class MealDeliveryOrderRepository {
  MealDeliveryOrderRepository();

  int total = 0;

  Future<List<MealDeliveryOrderModel>> fetchMealDeliveryOrders(
    int pageNum,
    int pageSize,
    String keyword,
    DateTime? start,
    DateTime? end,
    List<String>? foodArrays,
    List<String>? strArrays,
    List<String>? statusArrays,
    List<String>? orderStatus,
    List<String>? packageType,
  ) async {
    Completer<List<MealDeliveryOrderModel>> completer =
        Completer<List<MealDeliveryOrderModel>>();
    // 定义 beginTime 和 endTime
    DateTime beginTime = DateTime.now();
    DateTime endTime = DateTime.now();

    // 获取当前时间
    final DateTime now = DateTime.now();

    // 定义当天的早上 6 点
    final DateTime today6AM = DateTime(now.year, now.month, now.day, 6);

    if (now.isAfter(today6AM)) {
      // 如果当前时间超过 6 点，设置为当天 6 点到明天 6 点
      beginTime = today6AM;
      endTime = today6AM.add(Duration(days: 1));
    } else {
      // 如果当前时间未超过 6 点，设置为昨天 6 点到今天 6 点
      beginTime = today6AM.subtract(Duration(days: 1));
      endTime = today6AM;
    }
    print('pageSize: $pageSize');
    MealDeliveryUtils.getOrderMealList(
      {
        'pageNum': pageNum,
        'pageSize': pageSize,
        "params": {
          "beginTime": start != null ? start.toString() : beginTime.toString(),
          "endTime": end != null ? end.toString() : endTime.toString(),
        },
        "keyword": keyword,
        "foodArrays": foodArrays,
        "strArrays": strArrays,
        "statusArrays": statusArrays,
        "orderStatus": orderStatus,
        "packageType": packageType,
      },
      success: (data) {
        final List<MealDeliveryOrderModel> orders =
            RowsModel<MealDeliveryOrderModel>.fromJson(
              data,
              (json) => MealDeliveryOrderModel.fromJson(json),
            ).rows ??
            [];

        total = data['total'];
        completer.complete(orders);
      },
    );

    return completer.future;
  }

  Future<MealDeliveryOrderModel> fetchMealDeliveryOrderDetail(
    String orderId,
  ) async {
    Completer<MealDeliveryOrderModel> completer =
        Completer<MealDeliveryOrderModel>();
    MealDeliveryUtils.getOrderMealDetail(
      orderId,
      success: (data) {
        final orderDetail = MealDeliveryOrderModel.fromJson(data['data']);
        completer.complete(orderDetail);
      },
    );

    return completer.future;
  }
}
