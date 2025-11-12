///  data_utils.dart
///
///  Created by iotjin on 2021/04/01.
///  description:  项目数据请求 管理类

import 'package:dio/dio.dart';
import 'package:logistics_app/generated/l10n.dart';

import '/http/apis.dart';
import '/http/http_utils.dart';

typedef Success<T> = Function(T data);
typedef Fail = Function(int code, String msg);

class DataUtils {
  /// 注册
  static void register<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(APIs.register, parameters, success: success, fail: fail);
  }

  /// 登录
  static void login<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(APIs.login, parameters, success: success, fail: fail);
  }

  /// 忘记密码
  static void forgetPassword<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.put(
      APIs.forgetPassword,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 刷新token
  static void updateToken<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.put(
      APIs.updateToken + '?refreshToken=${parameters['refreshToken']}',
      parameters,
      success: success,
      fail: fail,
    );
  }

  static void logout<T>({Success? success, Fail? fail}) {
    HttpUtils.delete(APIs.logout, null, success: success, fail: fail);
  }

  // 获取用户信息
  static void getUserInfo<T>({Success? success, Fail? fail}) {
    HttpUtils.get(APIs.getUserInfo, null, success: success, fail: fail);
  }

  // 获取第三方用户信息
  static void getThirdUserInfo<T>({Success? success, Fail? fail}) {
    HttpUtils.get(APIs.getThirdUserInfo, null, success: success, fail: fail);
  }

  // 登录成功回调
  static void putLoginUser<T>(parameters, {Success? success, Fail? fail}) {
    return HttpUtils.post(
      APIs.putLoginUser,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取用户消费信息
  static void getUserConsumeInfo<T>(userId, {Success? success, Fail? fail}) {
    HttpUtils.get(
      APIs.getUserConsumeInfo + userId,
      null,
      success: success,
      fail: fail,
    );
  }

  // 编辑用户信息
  static void editUserInfo(parameters, {Success? success, Fail? fail}) {
    HttpUtils.put(APIs.editUser, parameters, success: success, fail: fail);
  }

  // 用户修改密码
  static void updateUserPwd<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.put(APIs.updateUserPwd, parameters, success: success, fail: fail);
  }

  // 用户第一次修改密码
  static void updateUserFirstPwd<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put(
      APIs.updateUserFirstPwd,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 储存用户设置token
  static void setUserToken<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.put(APIs.addToken, parameters, success: success, fail: fail);
  }

  /// 分页加载数据
  static void getPageList<T>(url, parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(url, parameters, success: success, fail: fail);
  }

  // 删除数据
  static void deleteData<T>(url, parameters, {Success? success, Fail? fail}) {
    HttpUtils.delete(url, parameters, success: success, fail: fail);
  }

  // 编辑数据
  static void editData<T>(url, parameters, {Success? success, Fail? fail}) {
    HttpUtils.put(url, parameters, success: success, fail: fail);
  }

  // 获取数据
  static void getData<T>(url, parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(url, parameters, success: success, fail: fail);
  }

  /// 分页加载分组数据
  static void getPageGroupList<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(APIs.getGroupPage, parameters, success: success, fail: fail);
  }

  // 获取生活区楼栋房间
  static void getBuildingTree<T>({Success? success, Fail? fail, s}) {
    HttpUtils.get(
      '/maintenance/building/app/tree',
      null,
      loadingText: S.current.livingAreaDataLoading,
      success: success,
      fail: fail,
    );
  }

  // 上传文件
  static void uploadFile<T>(FormData formData, {Success? success, Fail? fail}) {
    HttpUtils.post('/file/upload', formData, success: success, fail: fail);
  }

  // 报餐送餐上传文件
  static void uploadMealDeliveryFile<T>(
    FormData formData, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.post('/file/mdc/upload', formData, success: success, fail: fail);
  }

  // 上传文件
  static void uploadByfName<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/file/uploadByfName',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 上传证件图片
  static void uploadFacePhoto<T>(
    FormData formData, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.post(
      '/file/uploadFacePhoto',
      formData,
      success: success,
      fail: fail,
    );
  }

  // 获取数据字典
  static void getDictDataList<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      APIs.getDictDataList + parameters,
      null,
      success: success,
      fail: fail,
    );
  }

  // 获取公共便利数据
  static void getOtherDataList(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      APIs.getOtherDataList,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 根据id获取数据详情
  static void getDetailById(url, {Success? success, Fail? fail}) {
    HttpUtils.get(url, null, success: success, fail: fail);
  }

  // 获取最新的APP版本号
  static void getAppLastVersion({Success? success, Fail? fail}) {
    HttpUtils.get(APIs.getAppLastVersion, null, success: success, fail: fail);
  }

  /// 新增我的地址
  static void addMyAddress<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(APIs.addMyAddress, parameters, success: success, fail: fail);
  }

  // 删除我的地址
  static void deleteAddress<T>(ids, {Success? success, Fail? fail}) {
    HttpUtils.delete(
      APIs.addMyAddress + '/' + ids,
      null,
      success: success,
      fail: fail,
    );
  }

  /// 获取我的地址详情
  static void getMyAddressDetail<T>(id, {Success? success, Fail? fail}) {
    HttpUtils.get(
      APIs.getMyAddressDetail + '/' + id,
      null,
      success: success,
      fail: fail,
    );
  }

  /// 编辑我的地址
  static void editMyAddress<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.put(
      APIs.getMyAddressDetail,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取最新的区域楼栋版本号
  static void getBuildingVersion({Success? success, Fail? fail}) {
    HttpUtils.get(APIs.getBuildingVersion, null, success: success, fail: fail);
  }

  // 提交留言
  static void submitMessage<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      APIs.submitMessage,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取住宿流程
  static void getAccommodationProcessList(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(
      APIs.getAccommodationProcessList,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取申请列表
  static void getApplyList(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/other/applyOnline',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取申请链接
  static void getApplyUrl(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/other/applyOnline/getOaFormUrl/' + parameters['id'].toString(),
      null,
      success: success,
      fail: fail,
    );
  }

  // 获取在线接单列表
  static void getOnlineOrderList(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      APIs.getOnlineOrderList,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取我的订单列表
  static void getMyOrderList(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/delivery/order/selectStaffList',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 接单
  static void acceptOrder(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/delivery/acceptOrder',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 打包
  static void packOrder(id, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/delivery/acceptOrder/pack/' + id,
      null,
      success: success,
      fail: fail,
    );
  }

  // 取消订单
  static void cancelOrder(id, {Success? success, Fail? fail}) {
    HttpUtils.patch(
      '/delivery/acceptOrder/' + id,
      null,
      success: success,
      fail: fail,
    );
  }

  // 送达
  static void deliverOrder(parameters, {Success? success, Fail? fail}) {
    HttpUtils.put(
      '/delivery/acceptOrder',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 上传位置
  static void uploadLocation(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/delivery/location/addLocation',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 报餐送餐上传位置
  static void uploadMealLocation(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/system/mdc/carInfo/saveLocation',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取配送站点列表
  static void getDeliveryStationList({Success? success, Fail? fail}) {
    HttpUtils.get('/delivery/sourceMsg', null, success: success, fail: fail);
  }

  // 根据编码获取站点详情
  static void getDeliveryStationByCode(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(
      '/delivery/sourceMsg/station',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 确认收货
  static void confirmDelivery(id, {Success? success, Fail? fail}) {
    HttpUtils.put(
      '/delivery/order/' + id.toString(),
      null,
      success: success,
      fail: fail,
    );
  }

  // 收货异常
  static void errorDelivery(parameters, {Success? success, Fail? fail}) {
    HttpUtils.put('/delivery/order', parameters, success: success, fail: fail);
  }

  // 发送消息通知
  static void sendOneMessage(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      APIs.sendOneMessage,
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 根据用户名获取用户id
  static void getUserInfoByUsername(username, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/system/user/getSenderId/${username}',
      null,
      success: success,
      fail: fail,
    );
  }

  //根据来源编号查询配送订单详情
  static void getDeliveryOrderDetail(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(
      '/delivery/order/ByNo',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取站点信息
  static void getDeliveryStationInfo(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(
      '/delivery/sourceMsg/list',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 提交失物招领
  static void submitLostFound(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post('/other/found', parameters, success: success, fail: fail);
  }

  // 修改失物招领
  static void updateLostFound(parameters, {Success? success, Fail? fail}) {
    HttpUtils.put('/other/found', parameters, success: success, fail: fail);
  }

  // 获取夫妻房房间列表
  static void getCoupleRoomList(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/coupleRoom/room/chamber/appList',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取夫妻房订单列表
  static void getCoupleOrderList(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/coupleRoom/room/order/appList',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取夫妻房订单详情
  static void getCoupleOrderDetail(id, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/coupleRoom/room/order/' + id,
      null,
      success: success,
      fail: fail,
    );
  }

  // 预约夫妻房
  static void bookCoupleRoom(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/coupleRoom/room/order',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 取消预约
  static void cancelBookCoupleRoom(parameters, {Success? success, Fail? fail}) {
    HttpUtils.put(
      '/coupleRoom/room/order/cancel',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 确认订单
  static void confirmCoupleOrder(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/coupleRoom/room/order/appAudit',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取夫妻房工作人员列表
  static void getCoupleStaffList(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/coupleRoom/room/staff/list',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取夫妻房工作人员列表
  static void submitCoupleFeedback(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/coupleRoom/room/feedback',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取保洁类型列表
  static void getCleaningTypeList(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/maintenance/clean/project/list',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取保洁订单列表
  static void getCleaningOrderList(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/maintenance/clean/order/appList',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 提交保洁订单
  static void submitCleaningOrder(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/maintenance/clean/order',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 订单评价
  static void evaluateCleaningOrder(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put(
      '/maintenance/clean/order',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 修改保洁订单
  static void editCleaningOrder(parameters, {Success? success, Fail? fail}) {
    HttpUtils.put(
      '/maintenance/clean/order',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 提交隐患报告
  static void submitHazardReport(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/maintenance/hidden/danger',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 绑定报餐送餐帐号
  static void bindMealDeliveryAccount(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put(
      '/system/user/userAuthorizeWithMeal',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 解绑报餐送餐帐号
  static void revokeMealDeliveryAccount(
    username, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put(
      '/system/user/revokeUserAuthorizeWithMeal?username=$username',
      null,
      success: success,
      fail: fail,
    );
  }

  // 获取图书列表
  static void getBookList(parameters, {Success? success, Fail? fail}) {
    HttpUtils.get(
      '/other/books/list',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取图书详情
  static void getBookDetail(id, {Success? success, Fail? fail}) {
    HttpUtils.get('/other/books/$id', null, success: success, fail: fail);
  }

  // 点赞好人好事
  static void likeGoodDeed(id, {Success? success, Fail? fail}) {
    HttpUtils.get('/other/deeds/like/$id', null, success: success, fail: fail);
  }
}
