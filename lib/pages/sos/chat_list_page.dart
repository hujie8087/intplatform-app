import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
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
    chatListModel.loadChatSessions();
  }

  @override
  void dispose() {
    chatListModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.chat_sessions, style: TextStyle(fontSize: 16.px)),
        backgroundColor: const Color(0xFFd32f2f),
        foregroundColor: Colors.white,
        actions: [],
      ),
      body: AnimatedBuilder(
        animation: chatListModel,
        builder: (context, _) {
          if (chatListModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatListModel.chatSessions?.isEmpty ?? true) {
            return Center(
              child: Text(
                S.current.no_message,
                style: TextStyle(fontSize: 16.px),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await chatListModel.loadChatSessions();
            },
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.px)),
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
              ? S.current.click_to_start_dialog
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
              _formatTime(DateTime.parse(session.createTime)),
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
        onTap: () {
          chatListModel.enterChat(
            context,
            session.sessionId,
            (session.unreadCount ?? 0) > 0,
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays > 0) {
      return '${diff.inDays} ${S.current.days_ago}';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} ${S.current.hours_ago}';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} ${S.current.minutes_ago}';
    } else {
      return S.current.just_now;
    }
  }
}
