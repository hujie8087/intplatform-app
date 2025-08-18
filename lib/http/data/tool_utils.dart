import 'package:logistics_app/http/apis.dart';

import '/http/http_utils.dart';

typedef Success<T> = Function(T data);
typedef Fail = Function(int code, String msg);

class ToolUtils {
  // 获取服务指南列表数据
  static void getGuideTypeList<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(APIs.guideTypeList, parameters, success: success, fail: fail);
  }

  // 获取服务指南详情
  static void getGuideTypeDetail<T>(
    id, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get('${APIs.guideTypeUrl}/${id}', null,
        success: success, fail: fail);
  }

  // 获取服务指南内容列表数据
  static void getGuideList<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(APIs.guideList, parameters, success: success, fail: fail);
  }

  // 获取App菜单数据
  static void getAppMenu<T>({
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get('/other/icon/type/iconAllList', null,
        success: success, fail: fail);
  }
}
