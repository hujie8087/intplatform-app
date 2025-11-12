import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/sos_utils.dart';
import 'package:logistics_app/http/model/chat_session_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/sos/chat_screen_page.dart';
import 'package:logistics_app/pages/sos/models/chart_model.dart';
import 'package:logistics_app/pages/sos/services/chat_service.dart';
import 'package:logistics_app/utils/location_manager.dart';
import 'package:logistics_app/utils/native_location_service.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatListModel with ChangeNotifier {
  UserInfoModel? userInfo;
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
  ChatService? _chatService;

  void initialize() async {
    await getUserInfo();
    await chartModel.initialize();
    await initWebSocket();
  }

  Future<void> getUserInfo() async {
    // 模拟异步数据获取
    var userInfoData = await SpUtils.getModel('userInfo');
    deviceId = await SpUtils.getString(Constants.SP_DEVICE_TOKEN) ?? '';
    isAlarmTriggered = await SpUtils.getBool('isAlarmTriggered') ?? false;
    if (userInfoData != null) {
      userInfo = UserInfoModel.fromJson(userInfoData);
    }
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
      chartModel.chatService.onConnected = () {
        isConnected = true;
        print('WebSocket连接成功');
      };

      chartModel.chatService.onDisconnected = () {
        isConnected = false;
        print('WebSocket连接断开');
      };

      chartModel.chatService.onError = (error) {
        print('WebSocket错误: $error');
      };

      // 根据用户登录状态决定使用工号还是设备ID连接WebSocket
      String connectId;
      if (userInfo != null) {
        // 用户已登录，使用工号连接WebSocket
        connectId = userInfo!.user!.userName ?? '';
        print('用户已登录，使用工号连接WebSocket: $connectId');
      } else {
        // 用户未登录，使用设备ID连接WebSocket
        connectId = deviceId ?? '';
        print('用户未登录，使用设备ID连接WebSocket: $connectId');
      }

      print('尝试连接WebSocket，使用ID: $connectId');

      if (connectId == 'unknown' || connectId.isEmpty) {
        print('警告: 使用的连接ID为空或unknown');
      }

      await chartModel.chatService.connect(connectId);
    } catch (e) {
      print('初始化WebSocket失败: $e');
    }
  }

  Future<void> loadChatSessions() async {
    isLoading = true;

    try {
      // 获取用户信息
      String userName;
      if (userInfo != null) {
        // 用户已登录，使用用户的工号
        userName = userInfo!.user!.userName ?? '';
        print('用户已登录，使用用户工号: $userName');
      } else {
        // 用户未登录，使用设备ID
        userName = deviceId ?? '';
        print('用户未登录，使用设备ID: $userName');
      }

      final params = {'userName': userName, 'userType': 'USER'};

      print('=== 请求会话列表 ===');
      print('请求参数: $params');
      print('设备ID: ${deviceId}');
      print('==================');

      // 调用API获取会话列表
      DataUtils.getPageList(
        '/customer/chat/sessions/user/list',
        params,
        success: (data) {
          chatSessions = data['data']['records'] as List<ChatSessionModel>;
        },
        fail: (code, error) {
          print('加载会话列表失败: $error');
          chatSessions = [];
        },
      );
    } catch (e) {
      print('加载会话列表失败: $e');
      chatSessions = [];
    } finally {
      isLoading = false;
    }
  }

  void enterChat(
    BuildContext context,
    String sessionId, [
    bool hasUnread = false,
  ]) async {
    // 如果有未读消息，标记为已读
    if (hasUnread) {
      await _markAsRead(sessionId);
    }

    // 获取用户信息
    String senderId;
    String senderName;
    String senderType;

    if (userInfo != null) {
      // 用户已登录，使用用户信息
      senderId = userInfo!.user!.userName ?? ''; // 使用工号作为senderId
      senderName =
          userInfo!.user!.nickName?.isNotEmpty ?? false
              ? userInfo!.user!.nickName ?? ''
              : userInfo!.user!.userName ?? '';
      senderType = 'USER';
    } else {
      // 用户未登录，使用设备ID
      senderId = deviceId ?? '';
      senderName = '设备用户_${deviceId}';
      senderType = 'DEVICE';
    }

    print('进入聊天: $sessionId, $senderId, $senderName, $senderType');
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ChatScreenPage(
              sessionId: sessionId,
              chatService: chartModel.chatService,
              senderId: senderId,
              senderName: senderName,
              senderType: senderType,
              chartModel: chartModel,
            ),
      ),
    );
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
      userName: userInfo?.user?.userName ?? '',
      nickName: userInfo?.user?.nickName ?? '',
      orderId: orderNo,
      orderNumber: orderNo,
      status: 'OPEN',
      createBy: userInfo?.user?.userName ?? '',
      updateBy: userInfo?.user?.userName ?? '',
      createTime: DateTime.now().toIso8601String(),
      updateTime: DateTime.now().toIso8601String(),
      unreadCount: 0,
      lastMessage: '',
      lastMessageTime: DateTime.now().toIso8601String(),
      avatar: userInfo?.user?.avatar ?? '',
      orderNo: orderNo,
      userType: 'USER',
    );
    chatSessions?.insert(0, session);
    notifyListeners();
  }

  // 触发紧急报警
  Future<void> triggerEmergencyAlarm(BuildContext context) async {
    ProgressHUD.showText('正在发起紧急报警...');

    try {
      // 获取最新位置
      await getLocationWithoutGooglePlay();
      ProgressHUD.showInfo(
        '当前位置: ${currentPosition?.latitude}, ${currentPosition?.longitude}',
      );

      // 准备报警数据（对齐后端字段命名）
      final String dateYmd = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());
      final alarmData = {
        'level': 0, // 级别
        'reportLocation':
            '经度: ${currentPosition?.longitude}, 纬度: ${currentPosition?.latitude}', // 报警地点
        'reportDescription': '紧急SOS报警', // 报警详情
        'reportBy':
            userInfo?.user?.nickName?.isNotEmpty ?? false
                ? userInfo?.user?.nickName ?? ''
                : userInfo?.user?.userName ?? '', // 报警人
        'tel': userInfo?.user?.phonenumber ?? '', // 联系电话（无表单时留空）
        'reportTime': dateYmd, // 报警时间 yyyy-MM-dd
        'reportImage': reportImage, // 报警图片
        'processingBy': '', // 处理人
        'processingResult': '', // 处理结果
        'processingTime': dateYmd, // 处理时间 yyyy-MM-dd
        'longitude': currentPosition?.longitude, // 经度
        'latitude': currentPosition?.latitude, // 纬度
        'deviceType': '', // 设备信息
        'delFlag': '0', // 删除标志（0代表存在 1代表删除）
        'orderNo': '', // 报警单号
        // 其他辅助信息
        'deviceId': deviceId,
        'userName': userInfo?.user?.userName,
        'userId': userInfo?.user?.userId,
        'jobId': userInfo?.user?.userName,
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
          ProgressHUD.showSuccess('报警成功');
          notifyListeners();
        },
        fail: (code, error) {
          print('报警失败: $error');
          isAlarmTriggered = false;
          SpUtils.saveBool('isAlarmTriggered', false);
          currentSessionId = null;
          ProgressHUD.showError('报警失败: $error');
          notifyListeners();
        },
      );
    } catch (e) {
      // 关闭加载对话框
      print('报警异常: $e');
      isAlarmTriggered = false;
      SpUtils.saveBool('isAlarmTriggered', false);
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
      ProgressHUD.showError('电话号码为空');
    }
  }

  // 开始紧急聊天（使用当前报警的sessionId）
  Future<void> startEmergencyChat(BuildContext context) async {
    if (currentSessionId?.isEmpty ?? true) {
      ProgressHUD.showError('未找到报警会话ID');
      isAlarmTriggered = false;
      SpUtils.saveBool('isAlarmTriggered', false);
      currentSessionId = null;
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
                  const Text('正在连接客服...'),
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

        // 使用ChatController中的ChatService实例
        _chatService = chartModel.chatService;

        enterChat(context, newSession.sessionId);

        // 跳转到聊天界面，不管连接状态如何
        // ChatScreen会处理连接状态
        // Get.to(() => ChatScreen(
        //       sessionId: newSession.sessionId,
        //       chatService: _chatService!,
        //       senderId: senderId,
        //       senderName: senderName,
        //       senderType: senderType,
        //       chatController: chatController, // 添加chatController参数
        //     ));

        //     enterChat(newSession.sessionId);
      } else {
        ProgressHUD.showError('无法创建聊天会话');
        Navigator.of(context).pop();
        notifyListeners();
      }
    } catch (e) {
      ProgressHUD.showError('连接客服时发生错误: $e');
      Navigator.of(context).pop();
      notifyListeners();
    }
  }
}
