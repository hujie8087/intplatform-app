import 'dart:async';
import 'dart:convert'; // 添加这个导入
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  // Callbacks for handling messages
  Function(String message)? onMessageReceived;
  Function(String error)? onError;
  Function? onConnected;
  Function? onDisconnected;
  ThirdUserInfoModel? userInfo;

  // Get a unique identifier for the device or user
  static Future<String> getIdentifier() async {
    // 始终使用设备ID，不管是否登录
    return await SpUtils.getString(Constants.SP_DEVICE_TOKEN) ?? '';
  }

  // Get a unique identifier for the device
  static Future<String> getUniqueIdentifier() async {
    return await SpUtils.getString(Constants.SP_DEVICE_TOKEN) ?? '';
  }

  // Connect to WebSocket with device ID
  Future<bool> connect() async {
    try {
      String identifier = await getIdentifier();
      String url = '${APIs.websocketFix}$identifier';

      print('WebSocket连接URL: $url');

      _channel = WebSocketChannel.connect(Uri.parse(url));

      // Listen to incoming messages
      _subscription = _channel!.stream.listen(
        (message) {
          print('收到WebSocket消息: $message');
          if (onMessageReceived != null) {
            onMessageReceived!(message);
          }
        },
        onError: (error) {
          print('WebSocket错误: $error');
          if (onError != null) {
            onError!(error.toString());
          }
        },
        onDone: () {
          print('WebSocket连接断开');
          if (onDisconnected != null) {
            onDisconnected!();
          }
        },
      );

      // Wait a bit to ensure connection establishment
      await Future.delayed(const Duration(milliseconds: 500));

      if (onConnected != null) {
        onConnected!();
      }

      return true;
    } catch (e) {
      print('WebSocket连接异常: $e');
      if (onError != null) {
        onError!(e.toString());
      }
      return false;
    }
  }

  // Send a message through WebSocket with proper JSON structure
  void sendMessage(String content, {String? sessionId}) async {
    if (_channel != null) {
      try {
        // Get user info to determine senderId and senderName
        var userInfoData = await SpUtils.getModel('thirdUserInfo');
        if (userInfoData != null) {
          userInfo = ThirdUserInfoModel.fromJson(userInfoData);
        }

        String senderId;
        String senderName;

        if (userInfo != null && userInfo?.account != null) {
          // User is logged in
          senderName = userInfo?.name ?? '';
        }
        // User not logged in
        senderId = await getUniqueIdentifier();
        senderName = senderId;

        // Create the message JSON
        Map<String, dynamic> messageData = {
          'type': 'CHAT_MESSAGE',
          'senderId': senderId,
          'targetUserId': '1423092221',
          'content': content,
          'senderType': 'USER',
          'senderName': senderName,
          'contentType': 'TEXT',
        };

        // Add sessionId if provided
        if (sessionId != null && sessionId.isNotEmpty) {
          messageData['sessionId'] = sessionId;
        }

        // Convert to JSON string
        String messageJson = jsonEncode(messageData);

        print('=== 发送WebSocket消息 ===');
        print('消息内容: $messageJson');
        print('========================');
        _channel!.sink.add(messageJson);
      } catch (e) {
        print('发送消息时出错: $e');
      }
    } else {
      print('无法发送消息: WebSocket未连接');
    }
  }

  // Close the WebSocket connection
  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
  }

  // Check if currently connected
  bool get isConnected => _channel != null;

  // Get the current identifier used for this connection
  Future<String> getCurrentIdentifier() async {
    return await getIdentifier();
  }
}
