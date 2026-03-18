import 'package:flutter/material.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/chat_session_model.dart';
import 'package:logistics_app/pages/sos/chat_view_page.dart';
import 'package:logistics_app/pages/sos/models/chart_model.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class ChatSessionsViewPage extends StatefulWidget {
  const ChatSessionsViewPage({Key? key}) : super(key: key);

  @override
  State<ChatSessionsViewPage> createState() => _ChatSessionsViewPageState();
}

class _ChatSessionsViewPageState extends State<ChatSessionsViewPage> {
  final ChartModel chartModel = ChartModel();

  @override
  void initState() {
    super.initState();
    // Get device info and load chat sessions when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getDeviceInfoAndLoadSessions();
    });
  }

  Future<void> _getDeviceInfoAndLoadSessions() async {
    try {
      // 获取设备信息
      final deviceId = await SpUtils.getString(Constants.SP_DEVICE_TOKEN) ?? '';
      ;

      print('=== 进入聊天会话列表 ===');
      print('设备ID: $deviceId');

      // 获取会话参数并打印
      final sessionParams = await chartModel.getSessionParams();
      print('接口参数: $sessionParams');
      print('=====================');
    } catch (e) {
      print('获取设备信息失败: $e');
    }

    // 加载聊天会话
    _loadChatSessions();
  }

  Future<void> _loadChatSessions() async {
    await chartModel.loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.chat_sessions),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text(S.current.chat_sessions),
              ListView.builder(
                itemCount: chartModel.sessions.length,
                itemBuilder: (context, index) {
                  return _buildSessionItem(chartModel.sessions[index]);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new chat session
          _createNewSession();
        },
        backgroundColor: const Color(0xFF2196F3),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSessionItem(ChatSessionModel session) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE3F2FD),
          child: Icon(
            session.userType == 'AGENT' ? Icons.support_agent : Icons.person,
            color: const Color(0xFF2196F3),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                session.nickName ?? session.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (session.unreadCount != null && session.unreadCount! > 0)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  session.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.lastMessage ?? S.current.no_message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(session.lastMessageTime ?? session.updateTime),
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          ],
        ),
        onTap: () async {
          // Open chat view for this session
          // await chartModel.currentSession = session;
          // Mark messages as read
          await chartModel.markAsRead(session);
        },
      ),
    );
  }

  String _formatTime(String timeString) {
    try {
      DateTime time = DateTime.parse(timeString);
      DateTime now = DateTime.now();

      if (time.day == now.day &&
          time.month == now.month &&
          time.year == now.year) {
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      } else if (time.day == now.day - 1 &&
          time.month == now.month &&
          time.year == now.year) {
        return S.current.yesterday;
      } else {
        return '${time.month}/${time.day}';
      }
    } catch (e) {
      return timeString;
    }
  }

  void _createNewSession() {
    // Create a new session with all fields but empty values for order info
    _createNewSessionWithEmptyOrderInfo();
  }

  void _createNewSessionWithEmptyOrderInfo() async {
    try {
      // Use existing getSessionParams method from ChatController
      Map<String, dynamic> sessionData = await chartModel.getSessionParams();

      // Create new session (WebSocket connection will be handled automatically)
      ChatSessionModel? newSession = await chartModel.createChatSession(
        sessionData,
      );
      if (newSession != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatViewPage()),
        );
      }
      // Get.to(() => ChatViewPage(session: newSession));
    } catch (e) {
      print('创建会话失败: $e');
    }
  }
}
