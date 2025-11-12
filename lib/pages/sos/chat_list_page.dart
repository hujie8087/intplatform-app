import 'package:flutter/material.dart';
import 'package:logistics_app/http/model/chat_session_model.dart';
import 'package:logistics_app/pages/sos/models/chat_list_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPage createState() => _ChatListPage();
}

class _ChatListPage extends State<ChatListPage> {
  final ChatListModel chatListModel = ChatListModel();
  @override
  void initState() {
    super.initState();
    chatListModel.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('客服对话', style: TextStyle(fontSize: 16.px)),
        backgroundColor: const Color(0xFFd32f2f),
        foregroundColor: Colors.white,
        actions: [],
      ),
      body: Builder(
        builder: (context) {
          if (chatListModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatListModel.chatSessions?.isEmpty ?? true) {
            return Center(
              child: Text('暂无对话记录', style: TextStyle(fontSize: 16.px)),
            );
          }

          return RefreshIndicator(
            onRefresh: chatListModel.loadChatSessions,
            child: ListView.builder(
              itemCount: chatListModel.chatSessions?.length ?? 0,
              itemBuilder: (context, index) {
                final session = chatListModel.chatSessions?[index];
                return _buildChatSessionItem(
                  session ??
                      ChatSessionModel(
                        sessionId: '',
                        userType: '',
                        userName: '',
                        status: '',
                        createTime: '',
                        updateTime: '',
                      ),
                  chatListModel,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatSessionItem(
    ChatSessionModel session,
    ChatListModel chatListModel,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.px, vertical: 4.px),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFd32f2f),
          child: const Icon(Icons.support_agent, color: Colors.white),
        ),
        title: Text(
          session.nickName ?? session.userName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          session.lastMessage?.isEmpty ?? true
              ? '点击开始对话'
              : session.lastMessage ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12.px),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(
                DateTime.parse(
                  session.lastMessageTime ?? DateTime.now().toIso8601String(),
                ),
              ),
              style: TextStyle(fontSize: 12.px, color: Colors.grey[600]),
            ),
            if ((session.unreadCount ?? 0) > 0)
              Container(
                margin: EdgeInsets.only(top: 4.px),
                padding: EdgeInsets.symmetric(horizontal: 6.px, vertical: 2.px),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10.px),
                ),
                child: Text(
                  '${session.unreadCount}',
                  style: TextStyle(color: Colors.white, fontSize: 12.px),
                ),
              ),
          ],
        ),
        onTap:
            () => chatListModel.enterChat(
              context,
              session.sessionId,
              (session.unreadCount ?? 0) > 0,
            ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays > 0) {
      return '${diff.inDays}天前';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}小时前';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}
