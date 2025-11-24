import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/sos_utils.dart';
import 'package:logistics_app/http/model/chat_session_model.dart';
import 'package:logistics_app/http/model/contact_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/sos/chat_screen_page.dart';
import 'package:logistics_app/pages/sos/models/chart_model.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/location_manager.dart';
import 'package:logistics_app/utils/native_location_service.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatListModel with ChangeNotifier {
  UserInfoModel? userInfo;
  ThirdUserInfoModel? thirdUserInfo;
  bool isLoading = false;
  bool isConnected = false;
  List<ChatSessionModel>? chatSessions = [];
  Position? currentPosition;
  LocationSettings? locationSettings;
  bool isUploading = false;
  String? reportImage;
  String? orderNo;
  String? deviceId;
  bool isAlarmTriggered = false;
  String? currentSessionId;
  ChartModel chartModel = ChartModel();
  Timer? _sessionRefreshDebounce;
  List<ContactModel> contactList = [];

  void initialize() async {
    await loadContactList();
    await getUserInfo();
    await chartModel.initialize();
    await initWebSocket();
  }

  Future<void> getUserInfo() async {
    // 模拟异步数据获取
    var userInfoData = await SpUtils.getModel('userInfo');
    var thirdUserInfoData = await SpUtils.getModel('thirdUserInfo');
    var deviceIdData = await SpUtils.getString(Constants.SP_DEVICE_TOKEN) ?? '';
    var isAlarmTriggeredData =
        await SpUtils.getBool('isAlarmTriggered') ?? false;
    var currentSessionIdData =
        await SpUtils.getString('currentSessionId') ?? '';
    isAlarmTriggered = isAlarmTriggeredData;
    currentSessionId = currentSessionIdData;
    deviceId = deviceIdData;
    print('deviceId: $deviceId');
    if (userInfoData != null) {
      userInfo = UserInfoModel.fromJson(userInfoData);
    }
    if (thirdUserInfoData != null) {
      thirdUserInfo = ThirdUserInfoModel.fromJson(thirdUserInfoData);
    }
    notifyListeners();
  }

  Future<void> getLocationWithoutGooglePlay() async {
    try {
      // 检查原生定位是否可用
      bool isAvailable = await NativeLocationService.isLocationAvailable();

      if (!isAvailable) {
        print('设备定位服务不可用');
        return;
      }

      // 获取位置
      final location = await LocationManager.getLocation();
      print('location: $location');
      print('location: $location');
      if (location != null) {
        print('纬度: ${location['latitude']}');
        print('经度: ${location['longitude']}');
        print('精度: ${location['accuracy']}米');
        currentPosition = Position(
          latitude: location['latitude'] ?? 0.0,
          longitude: location['longitude'] ?? 0.0,
          altitude: location['altitude'] ?? 0.0,
          accuracy: location['accuracy'] ?? 0.0,
          timestamp: DateTime.now(),
          altitudeAccuracy: location['altitudeAccuracy'] ?? 0.0,
          heading: location['heading'] ?? 0.0,
          headingAccuracy: location['headingAccuracy'] ?? 0.0,
          speed: location['speed'] ?? 0.0,
          speedAccuracy: 0.0,
        );
      } else {
        print('无法获取位置信息');
      }
    } catch (e) {
      print('获取位置失败: $e');
    }
  }

  Future<void> initWebSocket() async {
    try {
      _bindChatServiceCallbacks();
      print('deviceId: ${deviceId?.isEmpty ?? true}');
      print(
        'thirdUserInfo?.account: ${thirdUserInfo?.account?.isEmpty ?? true}',
      );
      if ((deviceId?.isEmpty ?? true) &&
          (thirdUserInfo?.account?.isEmpty ?? true)) {
        ProgressHUD.showError('设备ID或用户工号为空');
        return;
      }

      await chartModel.chatService.connect(thirdUserInfo?.account ?? '');
    } catch (e) {
      print('初始化WebSocket失败: $e');
    }
  }

  void _bindChatServiceCallbacks() {
    final chatService = chartModel.chatService;

    final previousOnMessage = chatService.onMessageReceived;
    chatService.onMessageReceived = (message) {
      previousOnMessage?.call(message);
      _scheduleSessionsRefresh();
    };

    final previousOnConnected = chatService.onConnected;
    chatService.onConnected = () {
      previousOnConnected?.call();
      isConnected = true;
      print('WebSocket连接成功');
      notifyListeners();
    };

    final previousOnDisconnected = chatService.onDisconnected;
    chatService.onDisconnected = () {
      previousOnDisconnected?.call();
      isConnected = false;
      print('WebSocket连接断开');
      notifyListeners();
    };

    final previousOnError = chatService.onError;
    chatService.onError = (error) {
      previousOnError?.call(error);
      print('WebSocket错误: $error');
    };
  }

  void _scheduleSessionsRefresh() {
    _sessionRefreshDebounce?.cancel();
    _sessionRefreshDebounce = Timer(const Duration(milliseconds: 300), () {
      loadChatSessions();
    });
  }

  Future<void> loadContactList() async {
    DataUtils.getPageList(
      '/system/connect/list',
      {'pageNum': 1, 'pageSize': 100, 'sourceType': '0'},
      success: (data) {
        var contactListData = data['rows'] as List;
        contactList =
            contactListData.map((e) => ContactModel.fromJson(e)).toList();
      },
      fail: (code, msg) {
        print('loadContactList fail: $code, $msg');
      },
    );
  }

  Future<void> loadChatSessions() async {
    await getUserInfo();
    print('thirdUserInfo?.account: ${thirdUserInfo?.account}');
    isLoading = true;

    try {
      final params = {
        'userName': thirdUserInfo?.account ?? deviceId,
        'userType': 'USER',
      };
      print('=== 请求会话列表 ===');
      print('请求参数: $params');
      print('设备ID: ${deviceId}');
      print('==================');

      // 调用API获取会话列表
      DataUtils.getPageList(
        '/customer/chat/sessions/user/list',
        params,
        success: (data) {
          final records =
              (data['data']['records'] as List<dynamic>? ?? [])
                  .cast<Map<String, dynamic>>();
          chatSessions =
              records.map<ChatSessionModel>(ChatSessionModel.fromJson).toList();
          notifyListeners();
        },
        fail: (code, error) {
          print('加载会话列表失败: $error');
          chatSessions = [];
          notifyListeners();
        },
      );
    } catch (e) {
      print('加载会话列表失败: $e');
      chatSessions = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> enterChat(
    BuildContext context,
    String sessionId, [
    bool hasUnread = false,
  ]) async {
    // 如果有未读消息，标记为已读
    if (hasUnread) {
      await _markAsRead(sessionId);
    }

    // 从会话列表中找到对应的会话
    ChatSessionModel? session;
    if (chatSessions != null) {
      try {
        session = chatSessions!.firstWhere((s) => s.sessionId == sessionId);
      } catch (e) {
        print('未在本地找到会话: $sessionId');
      }
    }

    // 如果找到了会话，设置当前会话并加载消息
    if (session != null) {
      await chartModel.setCurrentSession(session);
      print('已设置当前会话: ${session.sessionId}, orderNo: ${session.orderNo}');
    } else {
      // 如果找不到会话，尝试通过API加载会话信息
      print('未在本地找到会话，尝试加载会话信息: $sessionId');
      // 可以在这里添加从API加载单个会话的逻辑
    }

    // 获取用户信息
    String senderId = thirdUserInfo?.account ?? '';
    String senderName = '';
    String senderType = 'USER';
    if (thirdUserInfo != null) {
      // 用户已登录，使用用户信息
      // senderId = userInfo!.user!.userName ?? ''; // 使用工号作为senderId
      senderName =
          thirdUserInfo!.name?.isNotEmpty ?? false
              ? thirdUserInfo!.name ?? ''
              : thirdUserInfo!.account ?? '';
      senderType = 'USER';
    }

    print(
      '进入聊天: $sessionId, $senderId, $senderName, $senderType, ${chartModel.currentSession},${chartModel.chatService.isConnected}',
    );

    await RouteUtils.push(
      context,
      ChatScreenPage(
        sessionId: sessionId,
        chatService: chartModel.chatService,
        senderId: senderId,
        senderName: senderName,
        senderType: senderType,
        chartModel: chartModel,
      ),
    );

    await loadChatSessions();
  }

  Future<void> _markAsRead(String sessionId) async {
    try {
      final data = {
        'currentTime': DateTime.now().toUtc().toIso8601String(),
        'senderType': 'USER',
        'sessionId': int.tryParse(sessionId) ?? 0,
        'userType': 'USER',
      };

      SosUtils.markMessagesAsRead(
        data,
        success: (data) {
          print('标记已读成功: $data');
        },
        fail: (code, error) {
          print('标记已读失败: $error');
        },
      );

      // 更新本地会话的未读数
      // final sessionIndex = chatSessions?.indexWhere(
      //   (s) => s.sessionId == sessionId,
      // );
      // if (sessionIndex != -1) {
      //   chatSessions![sessionIndex!].unreadCount = 0;
      //   notifyListeners();
      // }
    } catch (e) {
      print('标记已读失败: $e');
    }
  }

  void addSessionFromAlarm(String sessionId) {
    final session = ChatSessionModel(
      sessionId: sessionId,
      userName: thirdUserInfo?.account ?? '',
      nickName: thirdUserInfo?.name ?? '',
      orderId: orderNo,
      orderNumber: orderNo,
      status: 'OPEN',
      createBy: thirdUserInfo?.account ?? '',
      updateBy: thirdUserInfo?.account ?? '',
      createTime: DateTime.now().toIso8601String(),
      updateTime: DateTime.now().toIso8601String(),
      unreadCount: 0,
      lastMessage: '',
      lastMessageTime: DateTime.now().toIso8601String(),
      avatar: thirdUserInfo?.avatar ?? '',
      orderNo: orderNo,
      userType: 'USER',
    );
    chatSessions?.insert(0, session);
    notifyListeners();
  }

  // 触发紧急报警
  Future<void> triggerEmergencyAlarm(BuildContext context) async {
    ProgressHUD.showText(S.current.triggering_emergency_alarm);

    try {
      // 获取最新位置
      await getLocationWithoutGooglePlay();
      if (currentPosition == null) {
        ProgressHUD.showError(S.current.current_position_failed);
        notifyListeners();
        return;
      }
      ProgressHUD.showInfo(
        '${S.current.current_position}: ${currentPosition?.latitude}, ${currentPosition?.longitude}',
      );

      final alarmData = {
        'level': 0, // 级别
        'reportLocation':
            '经度: ${currentPosition?.longitude}, 纬度: ${currentPosition?.latitude}', // 报警地点
        'reportDescription': '紧急SOS报警', // 报警详情
        'reportBy':
            thirdUserInfo?.name?.isNotEmpty ?? false
                ? thirdUserInfo?.name ?? ''
                : thirdUserInfo?.account ?? '设备用户', // 报警人
        'tel': thirdUserInfo?.tel ?? '', // 联系电话（无表单时留空）
        'reportTime': DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(DateTime.now()), // 报警时间 yyyy-MM-dd HH:mm:ss
        'reportImage': reportImage, // 报警图片
        'processingBy': '', // 处理人
        'processingResult': '', // 处理结果
        'processingTime': '', // 处理时间 yyyy-MM-dd HH:mm:ss
        'longitude': currentPosition?.longitude, // 经度
        'latitude': currentPosition?.latitude, // 纬度
        'deviceType': deviceId, // 设备号（必传）
        'delFlag': '0', // 删除标志（0代表存在 1代表删除）
        'orderNo': '', // 报警单号
        'systemSource': '0', // 系统来源（0是后勤）
        // 报警人工号（登录传userName工号，未登录传空）
        'createBy': thirdUserInfo?.account ?? deviceId ?? '',
        // 其他辅助信息
        'deviceId': deviceId,
        'userName': thirdUserInfo?.account ?? deviceId ?? '',
        'userId': thirdUserInfo?.id?.toString() ?? '1',
        'reportType': 'EMERGENCY_SOS',
      };

      // 打印报警参数（严格按后端字段）
      print('=== SOS报警参数（后端字段） ===');
      print('级别 level: ${alarmData['level']}');
      print('报警地点 reportLocation: ${alarmData['reportLocation']}');
      print('报警详情 reportDescription: ${alarmData['reportDescription']}');
      print('报警人 reportBy: ${alarmData['reportBy']}');
      print('联系电话 tel: ${alarmData['tel']}');
      print('报警时间 reportTime: ${alarmData['reportTime']}');
      print('报警图片 reportImage: ${alarmData['reportImage']}');
      print('处理人 processingBy: ${alarmData['processingBy']}');
      print('处理结果 processingResult: ${alarmData['processingResult']}');
      print('处理时间 processingTime: ${alarmData['processingTime']}');
      print('经度 longitude: ${alarmData['longitude']}');
      print('纬度 latitude: ${alarmData['latitude']}');
      print('设备信息 deviceType: ${alarmData['deviceType']}');
      print('删除标志 delFlag: ${alarmData['delFlag']}');
      print('报警单号 orderNo: ${alarmData['orderNo']}');
      // 其他本地辅助信息
      print('设备ID deviceId: ${alarmData['deviceId']}');
      print('用户名 userName: ${alarmData['userName']}');
      print('用户ID userId: ${alarmData['userId']}');
      print('工号 jobId: ${alarmData['jobId']}');
      print('报警类型 reportType: ${alarmData['reportType']}');
      print('================================');

      SosUtils.addEmergencyReport(
        alarmData,
        success: (data) {
          orderNo = data['data']['orderNo'].toString();
          print('orderNo: $orderNo');
          isAlarmTriggered = true;
          SpUtils.saveBool('isAlarmTriggered', true);
          currentSessionId = 'sos_${DateTime.now().millisecondsSinceEpoch}';
          SpUtils.saveString('currentSessionId', currentSessionId ?? '');
          ProgressHUD.showSuccess(S.current.alarm_success);
          startEmergencyChat(context);
          notifyListeners();
        },
        fail: (code, error) {
          print('报警失败: $error');
          isAlarmTriggered = false;
          SpUtils.saveBool('isAlarmTriggered', false);
          SpUtils.remove('currentSessionId');
          currentSessionId = null;
          ProgressHUD.showError('${S.current.alarm_failed}: $error');
          notifyListeners();
        },
      );
    } catch (e) {
      // 关闭加载对话框
      print('报警异常: $e');
      isAlarmTriggered = false;
      SpUtils.saveBool('isAlarmTriggered', false);
      SpUtils.remove('currentSessionId');
      currentSessionId = null;
    } finally {
      isLoading = false;
    }
  }

  // 打电话
  void makePhoneCall(String? phoneNumber) {
    if (phoneNumber != null) {
      launchUrl(Uri.parse('tel:$phoneNumber'));
    } else {
      ProgressHUD.showError(S.current.phone_number_empty);
    }
  }

  // 开始紧急聊天（使用当前报警的sessionId）
  Future<void> startEmergencyChat(BuildContext context) async {
    if (currentSessionId?.isEmpty ?? true) {
      ProgressHUD.showError('未找到报警会话ID');
      isAlarmTriggered = false;
      SpUtils.saveBool('isAlarmTriggered', false);
      currentSessionId = null;
      SpUtils.remove('currentSessionId');
      notifyListeners();
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 20),
                  Text(S.current.connecting_customer_service),
                ],
              ),
            ),
          ),
      barrierDismissible: false,
    );

    try {
      // 创建聊天会话参数，包含orderNo
      final sessionData = await chartModel.getSessionParams(
        orderNo: orderNo ?? '',
      );
      print('sessionData: $sessionData');

      // 创建聊天会话
      final newSession = await chartModel.createChatSession(sessionData);
      print('newSession111: $newSession');

      if (newSession != null) {
        // 等待连接建立完成后再跳转
        // 使用一个延时确保连接状态稳定
        await Future.delayed(const Duration(milliseconds: 500));

        // 获取最新连接状态
        bool isActuallyConnected = chartModel.chatService.isConnected;
        print('SOSAlarmController: 检查最终连接状态 - $isActuallyConnected');

        currentSessionId = newSession.sessionId;
        SpUtils.saveString('currentSessionId', currentSessionId ?? '');
        Navigator.of(context).pop();
        notifyListeners();
      } else {
        ProgressHUD.showError(S.current.failed_to_create_chat_session);
        Navigator.of(context).pop();
        notifyListeners();
      }
    } catch (e) {
      ProgressHUD.showError(
        '${S.current.error_occurred_when_connecting_customer_service}: $e',
      );
      Navigator.of(context).pop();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sessionRefreshDebounce?.cancel();
    super.dispose();
  }
}
