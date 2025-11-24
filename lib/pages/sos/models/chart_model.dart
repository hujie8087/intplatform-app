import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/http/data/sos_utils.dart';
import 'package:logistics_app/http/model/chat_message_model.dart';
import 'package:logistics_app/http/model/chat_session_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/sos/services/chat_service.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class ChartModel with ChangeNotifier {
  bool isConnected = false;
  List<ChatMessageModel> messages = <ChatMessageModel>[];
  List<ChatSessionModel> sessions = <ChatSessionModel>[];
  bool isLoading = false;
  ChatSessionModel? currentSession;
  ChatService chatService = ChatService();
  ThirdUserInfoModel? thirdUserInfo;
  String? deviceId;

  Future<void> initialize() async {
    await getUserInfo();
    _initializeChat();
  }

  Future<void> getUserInfo() async {
    // 模拟异步数据获取
    var thirdUserInfoData = await SpUtils.getModel('thirdUserInfo');
    deviceId = await SpUtils.getString(Constants.SP_DEVICE_TOKEN) ?? '';
    if (thirdUserInfoData != null) {
      thirdUserInfo = ThirdUserInfoModel.fromJson(thirdUserInfoData);
    }
  }

  void _initializeChat() {
    // Set up callbacks for Chat events
    chatService.onMessageReceived = (message) {
      // Filter out messages without content (except system messages)
      if ((message.content.isEmpty) && message.type != 'SYSTEM_MESSAGE') {
        print('ChatController: 过滤掉无内容消息: ${message.toJson()}');
        return;
      }

      // Filter out ACK messages
      if (message.type == 'ACK_MESSAGE') {
        print('ChatController: 过滤掉ACK确认消息: ${message.toJson()}');
        return;
      }

      messages.add(message);
    };

    chatService.onError = (error) {
      print('聊天错误: $error');
      isConnected = false;
    };

    chatService.onConnected = () {
      isConnected = true;
      // Add system message
      ChatMessageModel systemMessage = ChatMessageModel(
        sessionId: 'system',
        senderType: 'SYSTEM',
        senderId: 'system',
        senderName: '系统',
        type: 'SYSTEM_MESSAGE',
        userId: 'system',
        nickName: '系统',
        userName: '系统',
        contentType: 'TEXT',
        content: '已连接到客服',
        timestamp: DateTime.now().toIso8601String(),
        userType: 'SYSTEM',
      );
      messages.add(systemMessage);
    };

    chatService.onDisconnected = () {
      isConnected = false;
      // Add system message
      ChatMessageModel systemMessage = ChatMessageModel(
        sessionId: 'system',
        senderType: 'SYSTEM',
        senderId: 'system',
        senderName: '系统',
        type: 'SYSTEM_MESSAGE',
        userId: 'system',
        nickName: '系统',
        userName: '系统',
        contentType: 'TEXT',
        content: '已断开连接',
        timestamp: DateTime.now().toIso8601String(),
        userType: 'SYSTEM',
      );
      messages.add(systemMessage);
    };
  }

  Future<bool> connect({String? sessionId}) async {
    _initializeChat();

    String connectId = thirdUserInfo?.account ?? '';

    bool connected = await chatService.connect(connectId);
    isConnected = connected;
    return connected;
  }

  // 统一发送消息的方法（支持文本、图片、视频等）
  Future<void> sendUnifiedMessage({
    required String content,
    required String contentType, // TEXT, IMAGE, VIDEO
    String? sessionId,
  }) async {
    // 检查连接状态，如果未连接则尝试重新连接
    if (!chatService.isConnected) {
      print('ChatController: 发送消息前检测到未连接，尝试重新连接...');
      String connectId = thirdUserInfo?.account ?? '';
      bool connected = await chatService.connect(connectId);

      if (!connected) {
        print('无法发送，未连接到客服，重新连接失败');
        return;
      }
    }

    // 获取用户信息
    String senderId =
        thirdUserInfo != null ? thirdUserInfo?.account ?? '' : deviceId ?? '';
    String senderName =
        thirdUserInfo != null
            ? (thirdUserInfo?.name?.isNotEmpty ?? false
                ? thirdUserInfo?.name ?? ''
                : thirdUserInfo?.account ?? '')
            : '设备用户_${deviceId ?? ''}';

    // 构造消息数据
    Map<String, dynamic> messageData = {
      'type': 'CHAT_MESSAGE',
      'senderId': senderId,
      'targetUserId': '1423092221',
      'content': content,
      'senderType': 'USER',
      'senderName': senderName,
      'contentType': contentType,
    };

    // 添加sessionId（如果提供）
    if (sessionId != null && sessionId.isNotEmpty) {
      messageData['sessionId'] = sessionId;
    } else if (currentSession?.sessionId != null) {
      messageData['sessionId'] = currentSession!.sessionId;
    }

    // 通过WebSocket发送消息
    try {
      await chatService.sendChatMessage(messageData);
      print('ChatController: 消息发送完成');

      // 添加到本地消息列表（仅用于UI显示，实际消息由服务器推送）
      ChatMessageModel localMessage = ChatMessageModel(
        sessionId: sessionId ?? currentSession?.sessionId ?? 'local',
        senderType: 'USER',
        senderId: senderId,
        senderName: senderName,
        type: 'CHAT_MESSAGE',
        userId: thirdUserInfo?.id?.toString() ?? '',
        nickName: senderName,
        userName: thirdUserInfo?.account ?? '',
        contentType: contentType,
        content: content,
        timestamp: DateTime.now().toIso8601String(),
        userType: 'USER',
      );
      messages.add(localMessage);
      notifyListeners();
    } catch (e) {
      print('ChatController: 发送消息时出错: $e');
      print('发送失败，发送消息时出错: $e');
      notifyListeners();
    }
  }

  // 发送文本消息的便捷方法
  Future<void> sendTextMessage(String content, {String? sessionId}) async {
    await sendUnifiedMessage(
      content: content,
      contentType: 'TEXT',
      sessionId: sessionId,
    );
  }

  // 发送媒体消息的便捷方法（图片/视频）
  Future<void> sendMediaMessage(
    String fileUrl,
    String contentType,
    String? sessionId,
  ) async {
    await sendUnifiedMessage(
      content: fileUrl,
      contentType: contentType,
      sessionId: sessionId,
    );
  }

  // 兼容旧的sendMessage方法
  Future<void> sendMessage(String content) async {
    await sendTextMessage(content);
  }

  void disconnect() {
    chatService.disconnect();
    isConnected = false;
  }

  // Load chat sessions from API
  Future<void> loadSessions() async {
    isLoading = true;
    try {
      // 获取参数
      Map<String, dynamic> params = await getSessionParams();

      // 调用接口
      SosUtils.getUserChatSessions(
        params,
        success: (data) {
          sessions = data['data'] as List<ChatSessionModel>;
          notifyListeners();
        },
        fail: (code, error) {
          print('加载会话列表失败: $error');
          sessions = [];
          notifyListeners();
        },
      );
    } catch (e) {
      print('加载会话列表失败: $e');
      notifyListeners();
    }
  }

  // Helper method to get session parameters for API calls
  Future<Map<String, dynamic>> getSessionParams({String? orderNo}) async {
    try {
      print('=== 获取会话参数 ===');

      Map<String, dynamic> params = {
        'equipmentId': deviceId,
        'userType': 'USER',
      };

      // 添加orderNumber和orderId（如果有的话）
      if (orderNo != null && orderNo.isNotEmpty) {
        params['orderNumber'] = orderNo;
        params['orderId'] = orderNo;
        print('添加订单信息 - orderNumber: $orderNo, orderId: $orderNo');
      }
      // 用户未登录，使用设备ID
      params['userName'] = thirdUserInfo?.account ?? deviceId ?? '';
      params['nickName'] = thirdUserInfo?.name ?? '设备用户';
      params['userId'] = thirdUserInfo?.id?.toString() ?? '1';
      params['senderType'] = 'USER';

      print('会话参数: $params');
      return params;
    } catch (e) {
      // 如果发生错误，使用设备ID作为备用
      print('发生错误，使用设备ID: $deviceId, 错误: $e');
      Map<String, dynamic> params = {
        'equipmentId': deviceId,
        'userName': thirdUserInfo?.account ?? deviceId ?? '',
        'nickName': thirdUserInfo?.name ?? '设备用户',
        'userId': thirdUserInfo?.id?.toString() ?? '1',
        'userType': 'USER',
        'senderType': 'USER',
      };

      // 添加orderNumber和orderId（如果有的话）
      if (orderNo != null && orderNo.isNotEmpty) {
        params['orderNumber'] = orderNo;
        params['orderId'] = orderNo;
      }

      return params;
    }
  }

  // Set current session and load messages
  Future<void> setCurrentSession(ChatSessionModel session) async {
    currentSession = session;
    messages.clear();
    await loadMessagesForSession(session.sessionId);
  }

  // Load messages for a specific session from API (public method)
  Future<void> loadMessagesForSession(String sessionId) async {
    isLoading = true;
    try {
      SosUtils.getChatHistory(
        sessionId,
        params: {'page': 1, 'size': 100, 'isAsc': 'desc'},
        success: (data) {
          List<dynamic> messageData = data['data']?['records'] ?? [];
          messages.clear();
          for (var messageJson in messageData) {
            messages.add(ChatMessageModel.fromJson(messageJson));
          }
          notifyListeners();
        },
        fail: (code, error) {
          print('加载消息失败: $error');
          notifyListeners();
        },
      );
    } catch (e) {
      print('加载消息失败: $e');
      notifyListeners();
    }
  }

  // Create a new chat session with minimal user data
  Future<ChatSessionModel?> createChatSession(
    Map<String, dynamic> sessionData,
  ) async {
    final completer = Completer<ChatSessionModel?>();
    try {
      SosUtils.createChatSession(
        sessionData,
        success: (data) async {
          try {
            final newSession = ChatSessionModel.fromJson(data['data']);
            currentSession = newSession;
            print('newSession: $newSession');
            if (!sessions.any((s) => s.sessionId == newSession.sessionId)) {
              sessions.insert(0, newSession);
            }

            await loadMessagesForSession(newSession.sessionId);

            bool connectionSuccess = await connect(
              sessionId: newSession.sessionId,
            );

            if (!connectionSuccess) {
              print('WebSocket连接失败，但继续创建会话');
            }

            completer.complete(newSession);
          } catch (e) {
            completer.completeError(e);
          }
        },
        fail: (code, error) {
          print('创建会话失败: $error');
          completer.complete(null);
        },
      );
    } catch (e) {
      print('创建会话失败: $e');
      completer.completeError(e);
    }

    return completer.future;
  }

  // Mark messages as read
  Future<void> markAsRead(ChatSessionModel session) async {
    try {
      SosUtils.markMessagesAsRead(
        {'sessionId': session.sessionId, 'senderType': session.userType},
        success: (data) {
          print('标记已读成功: $data');
        },
        fail: (code, error) {
          print('标记已读失败: $error');
        },
      );

      // Update session unread count
      final index = sessions.indexWhere(
        (s) => s.sessionId == session.sessionId,
      );
      if (index != -1) {
        // Create a new session with updated unread count
        ChatSessionModel updatedSession = ChatSessionModel(
          sessionId: session.sessionId,
          userId: session.userId,
          userType: session.userType,
          userName: session.userName,
          nickName: session.nickName,
          orderId: session.orderId,
          orderNumber: session.orderNumber,
          status: session.status,
          createBy: session.createBy,
          updateBy: session.updateBy,
          createTime: session.createTime,
          updateTime: session.updateTime,
          unreadCount: 0, // Mark as read
          lastMessage: session.lastMessage,
          lastMessageTime: session.lastMessageTime,
          avatar: session.avatar,
          orderNo: session.orderNo,
        );

        sessions[index] = updatedSession;
        if (currentSession != null &&
            currentSession!.sessionId == session.sessionId) {
          currentSession = updatedSession;
        }
        notifyListeners();
      }
    } catch (e) {
      print('标记已读失败: $e');
      notifyListeners();
    }
  }

  @override
  void onClose() {
    // Check if this controller is being closed but ChatService is still needed
    // For now, we'll disconnect, but we need to handle this more elegantly
    // A better solution would be to manage the ChatService lifecycle separately
    disconnect();
  }
}
