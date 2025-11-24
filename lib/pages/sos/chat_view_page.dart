import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/chat_message_model.dart';
import 'package:logistics_app/pages/sos/models/chart_model.dart';
import 'package:logistics_app/route/auto_route_generator.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/utils.dart';

class ChatViewPage extends StatefulWidget {
  const ChatViewPage({Key? key}) : super(key: key);

  @override
  State<ChatViewPage> createState() => _ChatViewPageState();
}

class _ChatViewPageState extends State<ChatViewPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChartModel chartModel = ChartModel();
  bool _showRelativeTime = true; // 控制时间显示模式的状态变量

  @override
  void initState() {
    super.initState();
    chartModel.initialize();
    // Connect to chat when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectToChat();
    });
  }

  Future<void> _connectToChat() async {
    try {
      // Only connect if not already connected
      if (!chartModel.isConnected) {
        String? sessionId = chartModel.currentSession?.sessionId;

        // Try to connect without blocking UI
        chartModel.connect(sessionId: sessionId);
      }
    } catch (e) {
      print('连接异常: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          chartModel.currentSession?.nickName ??
              chartModel.currentSession?.userName ??
              S.current.online_customer_service,
          style: TextStyle(fontSize: 16.px),
        ),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.px),
          onPressed: () {
            chartModel.disconnect();
            RouteUtils.pushNamed(context, RoutePath.SosIndexPage);
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(16.px),
            child: Container(
              width: 12.px,
              height: 12.px,
              decoration: BoxDecoration(
                color: chartModel.isConnected ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 16.px),
        ],
      ),
      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: Builder(
              builder: (context) {
                if (chartModel.isLoading) {
                  return Center(
                    child: ProgressHUD.showLoadingText(S.current.loading),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    if (chartModel.currentSession != null) {
                      await chartModel.loadMessagesForSession(
                        chartModel.currentSession!.sessionId,
                      );
                    }
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: chartModel.messages.length,
                    itemBuilder: (context, index) {
                      ChatMessageModel message = chartModel.messages[index];
                      bool isOwnMessage =
                          message.senderType == 'USER' ||
                          message.senderName == S.current.myself;
                      bool isSystemMessage =
                          message.senderType == 'SYSTEM' ||
                          message.senderName == S.current.system;

                      // 判断是否需要显示时间
                      bool showTime = _shouldShowTime(index);

                      if (isSystemMessage) {
                        return _buildSystemMessage(message);
                      } else {
                        return _buildChatMessage(
                          message,
                          isOwnMessage,
                          showTime: showTime,
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: S.current.inputMessage(S.current.message),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (value) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMessage(ChatMessageModel message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message.content,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessage(
    ChatMessageModel message,
    bool isOwnMessage, {
    bool showTime = false,
  }) {
    List<Widget> contentWidgets = [];

    // 只有当需要显示时间时才添加时间组件
    if (showTime) {
      contentWidgets.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: GestureDetector(
              onTap: _toggleTimeFormat,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatMessageTime(message.createTime ?? message.timestamp),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      );
    }

    contentWidgets.add(
      Row(
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isOwnMessage)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFFE3F2FD),
                child: Icon(
                  message.senderType == 'AGENT'
                      ? Icons.support_agent
                      : Icons.person,
                  size: 18,
                  color: const Color(0xFF2196F3),
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isOwnMessage ? const Color(0xFF2196F3) : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft:
                      isOwnMessage
                          ? const Radius.circular(18)
                          : Radius.circular(4),
                  bottomRight:
                      isOwnMessage
                          ? Radius.circular(4)
                          : const Radius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.senderName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color:
                          isOwnMessage ? Colors.white : const Color(0xFF2196F3),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isOwnMessage ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isOwnMessage)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.person, size: 18, color: Color(0xFF2196F3)),
              ),
            ),
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: contentWidgets),
    );
  }

  void _sendMessage() async {
    String text = _messageController.text.trim();
    print('=== 尝试发送消息 ===');
    print('消息内容: $text');
    print('消息是否为空: ${text.isEmpty}');
    print('ChatService连接状态: ${chartModel.isConnected}');
    print('本地连接状态: ${chartModel.isConnected}');
    print('==================');

    // 检查消息内容
    if (text.isEmpty) {
      print('消息为空，无法发送');
      ProgressHUD.showError(S.current.inputMessage(S.current.message));
      return;
    }

    // 检查连接状态 - if not connected, try to connect first
    if (!chartModel.isConnected) {
      print('ChatService未连接，尝试重新连接...');
      await chartModel.connect();

      // After reconnection attempt, check status again
      if (!chartModel.isConnected) {
        print('重连后仍然未连接，无法发送消息');
        ProgressHUD.showError(S.current.networkError);
        return;
      }
    }

    try {
      // 使用ChatController统一发送文本消息
      await chartModel.sendTextMessage(text);

      _messageController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      print('消息发送成功');
    } catch (e) {
      print('消息发送失败: $e');
      ProgressHUD.showError(S.current.sendMessageError(e.toString()));
    }
  }

  String _formatMessageTime(String? timeString) {
    if (_showRelativeTime) {
      return Utils.formatRelativeTime(timeString ?? '');
    } else {
      return Utils.formatRelativeTime(timeString ?? '');
    }
  }

  void _toggleTimeFormat() {
    setState(() {
      _showRelativeTime = !_showRelativeTime;
    });
  }

  bool _shouldShowTime(int index) {
    if (index == 0) return true; // 第一条消息总是显示时间

    final currentMessage = chartModel.messages[index];
    final previousMessage = chartModel.messages[index - 1];

    // 获取当前消息和前一条消息的时间
    final currentTimeStr =
        currentMessage.createTime ?? currentMessage.timestamp;
    final previousTimeStr =
        previousMessage.createTime ?? previousMessage.timestamp;

    try {
      DateTime currentTime, previousTime;

      // 解析时间字符串
      if (currentTimeStr.contains('T')) {
        currentTime = DateTime.parse(currentTimeStr);
      } else if (currentTimeStr.contains('-') && currentTimeStr.contains(':')) {
        currentTime = DateTime.parse(currentTimeStr);
      } else {
        return true; // 如果无法解析时间，默认显示时间
      }

      if (previousTimeStr.contains('T')) {
        previousTime = DateTime.parse(previousTimeStr);
      } else if (previousTimeStr.contains('-') &&
          previousTimeStr.contains(':')) {
        previousTime = DateTime.parse(previousTimeStr);
      } else {
        return true; // 如果无法解析时间，默认显示时间
      }

      // 计算时间差（分钟）
      final difference = currentTime.difference(previousTime);

      // 如果时间差超过2分钟，则显示时间
      return difference.inMinutes >= 2;
    } catch (e) {
      return true; // 如果解析出错，默认显示时间
    }
  }

  @override
  void dispose() {
    // Disconnect WebSocket when leaving chat view
    chartModel.disconnect();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
