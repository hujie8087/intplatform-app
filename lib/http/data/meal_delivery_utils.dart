import '/http/http_utils.dart';

typedef Success<T> = Function(T data);
typedef Fail = Function(int code, String msg);

class MealDeliveryUtils {
  // 获取用餐人员列表数据
  static void getMealPersonList<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/system/mdc/employee/appList',
      parameters,
      success: success,
      fail: fail,
    );
  }

  //校验可点餐的时间
  static void getCanOrderTime(oId, {Success? success, Fail? fail}) {
    HttpUtils.put(
      '/system/mdc/time/checkTime/$oId',
      null,
      success: success,
      fail: fail,
    );
  }

  // 获取用餐地点
  static void getMealPlace<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/system/mdc/site/list',
      parameters,
      success: success,
      fail: fail,
    );
  }

  //生成订单
  static void createOrderMeal(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post('/order/orders', parameters, success: success, fail: fail);
  }

  //获取订单列表
  static void getOrderMealList(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/order/orders/list',
      parameters,
      success: success,
      fail: fail,
    );
  }

  //司机-接收订单
  static void updateOrderMealStatus(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put(
      '/order/orders/editStatus',
      parameters,
      success: success,
      fail: fail,
    );
  }

  //修改订单状态
  static void receiveOrder2(parameters, {Success? success, Fail? fail}) {
    HttpUtils.put(
      '/order/orders/receiveOrder2',
      parameters,
      success: success,
      fail: fail,
    );
  }

  //获取订单详情
  static void getOrderMealDetail(orderId, {Success? success, Fail? fail}) {
    HttpUtils.get('/order/orders/$orderId', null, success: success, fail: fail);
  }

  //根据订单编号获取订单详情
  static void getOrderMealDetailQuery(orderNo, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/order/orders/queryOrders?orderNo=$orderNo',
      null,
      success: success,
      fail: fail,
    );
  }

  //部门修改订单人员信息
  static void updateOrderMealDetail(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put(
      '/order/orders/edit',
      parameters,
      success: success,
      fail: fail,
    );
  }

  //退订订单
  static void cancelOrderMeal(orderId, {Success? success, Fail? fail}) {
    HttpUtils.put(
      '/order/orders/returnOrder/$orderId',
      null,
      success: success,
      fail: fail,
    );
  }

  //完成订单
  static void updateOrderMealStatusByOrderId(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put(
      '/order/orders/completeOrder',
      parameters,
      success: success,
      fail: fail,
    );
  }

  //完成订单，通过订单编号
  static void updateOrderMealStatusByOrderNo(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put(
      '/order/orders/completeOrder2',
      parameters,
      success: success,
      fail: fail,
    );
  }

  //新增用餐人员
  static void addMealPerson(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/order/orders/appendFood',
      parameters,
      success: success,
      fail: fail,
    );
  }

  //获取送餐车队信息
  static void getMealCar(fdId, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/system/carInfo/queryCarListByMainId/$fdId',
      null,
      success: success,
      fail: fail,
    );
  }

  //班组提交订单
  static void submitOrderMeal(orderId, {Success? success, Fail? fail}) {
    HttpUtils.put(
      '/order/orders/teamSubmit/$orderId',
      null,
      success: success,
      fail: fail,
    );
  }

  //部门提交订单
  static void submitOrderMealByDept(orderId, {Success? success, Fail? fail}) {
    HttpUtils.put(
      '/order/orders/deptSubmit/$orderId',
      null,
      success: success,
      fail: fail,
    );
  }

  //班组人员修改订单
  static void updateOrderMealByTeam(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put(
      '/order/orders/updateOrder',
      parameters,
      success: success,
      fail: fail,
    );
  }

  //部门驳回
  static void returnOrderMealByDept(orderId, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/order/orders/deptreject?orderId= $orderId',
      null,
      success: success,
      fail: fail,
    );
  }

  //司机-接收订单
  static void receiveOrderMeal(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/order/orders/receiveOrder2',
      parameters,
      success: success,
      fail: fail,
    );
  }

  //APP 司机 查询未接收订单 返回当前路线(车号)剩余未接收订单 (当前周期)
  static void queryUnreceivedOrders(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.post(
      '/order/orders/queryUnreceivedOrders',
      parameters,
      success: success,
      fail: fail,
    );
  }

  //获取可点餐的时间
  static void getCanOrderTimeList({Success? success, Fail? fail}) {
    HttpUtils.get('/system/mdc/time/list', null, success: success, fail: fail);
  }

  // 获取是否斋月
  static void getIsRamadan({Success? success, Fail? fail}) {
    HttpUtils.get('/system/mdc/setting', null, success: success, fail: fail);
  }
}
