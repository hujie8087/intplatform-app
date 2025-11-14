import 'dart:async';
import 'dart:convert';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/model/chat_message_model.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  // Singleton pattern to ensure single instance across the app
  static ChatService? _instance;
  static ChatService get instance {
    _instance ??= ChatService._internal();
    return _instance!;
  }

  ChatService._internal(); // Private constructor for singleton

  // Factory constructor for creating new instances when needed
  factory ChatService() {
    return ChatService._internal();
  }
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _heartbeatTimer;

  // Callbacks for handling messages
  Function(ChatMessageModel message)? onMessageReceived;
  Function(String error)? onError;
  Function? onConnected;
  Function? onDisconnected;

  bool _isConnected = false;

  // Get a unique identifier for the device or user
  static Future<String> getIdentifier() async {
    return await SpUtils.getString(Constants.SP_DEVICE_TOKEN) ?? '';
  }

  // Get a unique identifier for the device
  static Future<String> getUniqueIdentifier() async {
    return await SpUtils.getString(Constants.SP_DEVICE_TOKEN) ?? '';
  }

  // Connect to WebSocket with userId or deviceId
  Future<bool> connect(String userId) async {
    try {
      // 清理和验证userId
      String cleanUserId = userId.trim();
      if (cleanUserId.isEmpty || cleanUserId == 'null') {
        cleanUserId = await getUniqueIdentifier();
      }

      String url = '${APIs.websocketFix}$cleanUserId';

      print('WebSocket连接URL: $url');
      print('使用的userId: $cleanUserId');

      _channel = WebSocketChannel.connect(Uri.parse(url));

      // Listen to incoming messages
      _subscription = _channel!.stream.listen(
        (message) {
          print('=== 收到WebSocket消息 ===');
          print('消息内容: $message');
          print('========================');
          _handleWebSocketMessage(message);

          // Connection is definitely established if we're receiving messages
          if (!_isConnected) {
            _isConnected = true;
            if (onConnected != null) {
              onConnected!();
            }
          }
        },
        onError: (error) {
          print('WebSocket错误: $error');
          _isConnected = false;
          if (onError != null) {
            onError!(error.toString());
          }
        },
        onDone: () {
          print('WebSocket连接断开');
          _isConnected = false;
          if (onDisconnected != null) {
            onDisconnected!();
          }
        },
      );

      // Wait briefly for connection to initialize
      await Future.delayed(const Duration(milliseconds: 100));

      // Initially set connected status if channel exists
      // The actual connection status will be confirmed when first message is received
      if (_channel != null) {
        // We'll set the connection status to true here, but the first message will confirm it
        _isConnected = true;

        if (onConnected != null) {
          onConnected!();
        }
      } else {
        _isConnected = false;
      }

      // Start heartbeat
      _startHeartbeat();

      if (onConnected != null) {
        onConnected!();
      }

      return true;
    } catch (e) {
      print('WebSocket连接异常: $e');
      _isConnected = false;
      if (onError != null) {
        onError!(e.toString());
      }
      return false;
    }
  }

  // Handle incoming WebSocket messages
  void _handleWebSocketMessage(dynamic message) {
    try {
      if (message is String) {
        // Parse the JSON message
        Map<String, dynamic> jsonData = json.decode(message);

        // Filter out ACK messages and other non-chat messages
        String messageType = jsonData['type']?.toString() ?? '';
        if (messageType == 'ACK_MESSAGE') {
          print('过滤掉ACK确认消息: $message');
          return; // Ignore ACK messages
        }

        // Filter out messages without content
        String content = jsonData['content']?.toString() ?? '';
        if (content.isEmpty && messageType != 'SYSTEM_MESSAGE') {
          print('过滤掉无内容消息: $message');
          return; // Ignore messages without content (except system messages)
        }

        // Create ChatMessage object
        ChatMessageModel chatMessage = ChatMessageModel(
          id: jsonData['id']?.toString(),
          messageId: jsonData['messageId']?.toString(),
          sessionId: jsonData['sessionId']?.toString() ?? '',
          senderType: jsonData['senderType']?.toString() ?? 'USER',
          senderId: jsonData['senderId']?.toString() ?? '',
          senderName: jsonData['senderName']?.toString() ?? '客服',
          type: jsonData['type']?.toString() ?? 'NEW_MESSAGE',
          userId: jsonData['userId']?.toString() ?? '',
          nickName: jsonData['nickName']?.toString() ?? '',
          userName: jsonData['userName']?.toString() ?? '',
          contentType: jsonData['contentType']?.toString() ?? 'TEXT',
          content: content,
          timestamp:
              jsonData['timestamp']?.toString() ??
              DateTime.now().toIso8601String(),
          isRead: jsonData['isRead'] as bool? ?? false,
          status: jsonData['status']?.toString(),
          userType: jsonData['userType']?.toString() ?? 'USER',
          createTime: jsonData['createTime']?.toString(),
          updateTime: jsonData['updateTime']?.toString(),
          createBy: jsonData['createBy']?.toString(),
          updateBy: jsonData['updateBy']?.toString(),
          avatar: jsonData['avatar']?.toString(),
          duration: jsonData['duration'] as int?,
          extra: jsonData['extra'],
        );

        // Notify listeners
        if (onMessageReceived != null) {
          onMessageReceived!(chatMessage);
        }
      }
    } catch (e) {
      print('解析WebSocket消息时出错: $e');
      if (onError != null) {
        onError!('解析消息时出错: $e');
      }
    }
  }

  // Send a chat message with new format
  Future<void> sendChatMessage(Map<String, dynamic> messageData) async {
    print('=== sendChatMessage 调用 ===');
    print('_channel 是否为 null: ${_channel == null}');
    print('_isConnected: $_isConnected');
    print('消息数据: $messageData');

    // Verify connection status before sending
    bool actualConnectionStatus = await verifyConnection();
    print('实际连接状态验证: $actualConnectionStatus');

    if (_channel != null && actualConnectionStatus) {
      try {
        String messageJson = jsonEncode(messageData);

        print('=== 发送WebSocket消息 ===');
        print('消息内容: $messageJson');
        print('========================');
        _channel!.sink.add(messageJson);
        print('消息已发送到WebSocket');
      } catch (e) {
        print('发送消息时出错: $e');
        _isConnected = false; // Mark as disconnected if there's an error
        if (onError != null) {
          onError!('发送消息时出错: $e');
        }
      }
    } else {
      print('无法发送消息: WebSocket未连接');
      print('_channel: $_channel');
      print('_isConnected: $_isConnected');
      if (onError != null) {
        onError!('WebSocket未连接');
      }
    }
  }

  // Send a message through WebSocket with proper JSON structure
  Future<void> sendMessage(String content, {String? sessionId}) async {
    // Use the new sendChatMessage method which has better connection checking
    // Get user info to determine senderId and senderName
    String senderId = await SpUtils.getString(Constants.SP_DEVICE_TOKEN) ?? '';
    String senderName = await SpUtils.getString(Constants.SP_DEVICE_TOKEN);

    // Create the message JSON
    Map<String, dynamic> messageData = {
      'type': 'CHAT_MESSAGE',
      'senderId': senderId,
      'targetUserId': 'AGENT',
      'content': content,
      'senderType': 'USER',
      'senderName': senderName,
      'contentType': 'TEXT',
    };

    // Add sessionId if provided
    if (sessionId != null && sessionId.isNotEmpty) {
      messageData['sessionId'] = sessionId;
    }

    await sendChatMessage(messageData);
  }

  // Start heartbeat timer
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected && _channel != null) {
        _sendHeartbeat();
      } else {
        timer.cancel();
      }
    });
  }

  // Send heartbeat message
  void _sendHeartbeat() {
    if (_channel != null && _isConnected) {
      try {
        Map<String, dynamic> heartbeatData = {
          'type': 'HEARTBEAT',
          'timestamp': DateTime.now().toIso8601String(),
        };

        String heartbeatJson = jsonEncode(heartbeatData);
        print('=== 发送心跳消息 ===');
        print('心跳内容: $heartbeatJson');
        print('===================');
        _channel!.sink.add(heartbeatJson);
      } catch (e) {
        print('发送心跳失败: $e');
      }
    }
  }

  // Close the WebSocket connection
  void disconnect() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
  }

  // Check if currently connected
  bool get isConnected => _isConnected && _channel != null;

  // Verify actual connection by attempting to send a test message (optional)
  Future<bool> verifyConnection() async {
    if (!isConnected) {
      return false;
    }

    try {
      // We could send a simple ping to verify connection, but for now we'll trust the connection state
      // In the future, we might want to implement a more sophisticated verification
      return isConnected;
    } catch (e) {
      print('连接验证失败: $e');
      _isConnected = false;
      return false;
    }
  }

  // Get the current identifier used for this connection
  Future<String> getCurrentIdentifier() async {
    return await getIdentifier();
  }
}
