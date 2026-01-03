import '/http/http_utils.dart';

typedef Success<T> = Function(T data);
typedef Fail = Function(int code, String msg);

class SosUtils {
  // 创建聊天会话
  static void createChatSession<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/customer/chat/sessions/create',
      parameters,
      success: success,
      fail: fail,
    );
  }

  static void getUserChatSessions<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(
      '/customer/chat/sessions/user/list',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取聊天历史记录
  static void getChatHistory(
    String sessionId, {
    Map<String, dynamic>? params,
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(
      '/customer/chat/messages/history/$sessionId',
      params,
      success: success,
      fail: fail,
    );
  }

  // 标记消息为已读
  static void markMessagesAsRead<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.post(
      '/customer/chat/messages/read',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 关闭聊天会话
  static void closeChatSession<T>(
    String sessionId, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.post(
      '/customer/chat/sessions/close',
      {'sessionId': sessionId},
      success: success,
      fail: fail,
    );
  }

  // 获取所有未读消息数量
  static void getAllUnreadMessageCount<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(
      '/customer/chat/sessions/unread/count',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 添加行程等待申请
  static void addTripWaiting<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/customer/chat/sessions/add/trip/waiting',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取行程等待详情
  static void getTripWaitingDetail<T>(
    String tweId, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(
      '/customer/chat/sessions/trip/waiting/detail/$tweId',
      null,
      success: success,
      fail: fail,
    );
  }

  // 获取订单详情
  static void getOrderDetail<T>(
    String orderId, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(
      '/customer/chat/sessions/order/detail/$orderId',
      null,
      success: success,
      fail: fail,
    );
  }

  // 文件上传
  static void uploadFileGeneral<T>(parameters, {Success? success, Fail? fail}) {
    HttpUtils.post(
      '/customer/chat/sessions/upload/file',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 报警接口
  static void addEmergencyReport<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.post(
      // 'https://test.iwipwedabay.com/security-stage-api/adt/report/add',
      // 'https://api.iwipwedabay.com/security-stage-api/adt/report/add',
      'https://api.iwipwedabay.com/api/security/mis/adt/report/add',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 结束报警接口
  static void endEmergencyReport<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.put(
      '/maintenance/report',
      parameters,
      success: success,
      fail: fail,
    );
  }

  // 获取当前用户的报警记录
  static void getUserEmergencyReports<T>(
    parameters, {
    Success? success,
    Fail? fail,
  }) {
    HttpUtils.get(
      '/maintenance/report/list',
      parameters,
      success: success,
      fail: fail,
    );
  }
}
