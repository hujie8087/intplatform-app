import '/http/http_utils.dart';

typedef Success<T> = Function(T data);
typedef Fail = Function(int code, String msg);

class RepairUtils {
  /// 提交报修单
  static void repairPost<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.post('/maintenance/repair', parameters,
        success: success, fail: fail);
  }

  // 获取生活区楼栋房间
  static void getBuildingTree<T>({
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get('/maintenance/food/building/app/tree', null,
        success: success, fail: fail);
  }

  // 获取我的报修列表数据
  static void getMyRepairList<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get('/maintenance/repair/byName', parameters,
        success: success, fail: fail);
  }

  // 获取报修单详情
  static void getRepairDetail<T>(
    id, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get('/maintenance/repair/${id}', null,
        success: success, fail: fail);
  }

  // 修改报修单
  static void editRepairDetail(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put('/maintenance/repair', parameters,
        success: success, fail: fail);
  }
}
