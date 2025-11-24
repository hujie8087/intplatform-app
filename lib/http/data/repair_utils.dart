import '/http/http_utils.dart';

typedef Success<T> = Function(T data);
typedef Fail = Function(int code, String msg);

class RepairUtils {
  /// 提交报修单
  static void repairPost<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/maintenance/repair',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取生活区楼栋房间
  static void getBuildingTree<T>({Success? success, Fail? fail}) {
    HttpUtils.get(
      '/maintenance/food/building/app/tree',
      null,
      success: success,
      fail: fail,
    );
  }

  // 获取我的报修列表数据
  static void getMyRepairList<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/maintenance/repair/byName',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取我的报修未读数量
  static void getMyRepairUnreadCount<T>({Success? success, Fail? fail}) {
    HttpUtils.get(
      '/maintenance/repair/selectNoRepairNum',
      null,
      success: success,
      fail: fail,
    );
  }

  // 获取报修单详情
  static void getRepairDetail<T>(id, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/maintenance/repair/${id}',
      null,
      success: success,
      fail: fail,
    );
  }

  // 修改报修单
  static void editRepairDetail(parameters, {Success? success, Fail? fail}) {
    HttpUtils.put(
      '/maintenance/repair',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取维修订单未完成数量
  static void getRepairUnfinishedCount<T>({Success? success, Fail? fail}) {
    HttpUtils.get(
      '/maintenance/repair/unfinishedCountApp',
      null,
      success: success,
      fail: fail,
    );
  }

  // 获取维修订单列表
  static void getRepairList<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/maintenance/repair/listApp',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取维修类型
  static void getRepairType<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/maintenance/repairType/list',
      parameters,
      success: success,
      fail: fail,
    );
  }
}
