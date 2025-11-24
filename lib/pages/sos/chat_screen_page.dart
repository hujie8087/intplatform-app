import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/sos_utils.dart';
import 'package:logistics_app/http/model/chat_message_model.dart';
import 'package:logistics_app/pages/sos/models/chart_model.dart';
import 'package:logistics_app/pages/sos/services/chat_service.dart';
import 'package:logistics_app/pages/sos/widgets/audio_message_widget.dart';
import 'package:logistics_app/pages/sos/widgets/media_message_widgets.dart';
import 'package:logistics_app/pages/sos/widgets/voice_record_button.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/update_file.dart';
import 'package:logistics_app/utils/utils.dart';
import 'package:logistics_app/utils/voice_message_service.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

// Resource API base URL for static files (images, videos, etc.)
class ResourceConfig {
  static const String resourceApi = APIs.imagePrefix;
}

class ChatScreenPage extends StatefulWidget {
  final String sessionId;
  final ChatService chatService;
  final String senderId;
  final String senderName;
  final String senderType;
  final ChartModel chartModel; // 添加ChatController参数

  const ChatScreenPage({
    Key? key,
    required this.sessionId,
    required this.chatService,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.chartModel, // 添加ChatController参数
  }) : super(key: key);

  @override
  State<ChatScreenPage> createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showRelativeTime = true; // 控制时间显示模式的状态变量
  bool isConnected = false;
  bool isVoiceInput = false;
  final VoiceMessageService _voiceMessageService = VoiceMessageService();

  @override
  void initState() {
    super.initState();
    _setupChatService();
    _loadChatHistory();
    print('ChatScreen: 初始化后消息列表: ${widget.chartModel.messages}');

    // Ensure connection is properly established with a slight delay
    // to handle potential timing issues
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Check connection status after widget is built
      if (!widget.chatService.isConnected) {
        print('ChatScreen: 初始化后发现未连接，尝试连接...');
        await _tryReconnect();
      }
    });
  }

  void _setupChatService() {
    widget.chatService.onMessageReceived = (message) {
      print('ChatScreen: 收到消息: ${message.toJson()}');
      // Filter out messages without content (except system messages)
      if ((message.content.isEmpty) && message.type != 'SYSTEM_MESSAGE') {
        print('ChatScreen: 过滤掉无内容消息: ${message.toJson()}');
        return;
      }

      // Filter out ACK messages
      if (message.type == 'ACK_MESSAGE') {
        print('ChatScreen: 过滤掉ACK确认消息: ${message.toJson()}');
        return;
      }
      print('ChatScreen: 添加消息: ${message.toJson()}');
      widget.chartModel.messages.add(message);
      setState(() {});
      _scrollToBottom();
    };

    widget.chatService.onConnected = () {
      print('ChatScreen: WebSocket已连接');
      // Update local connection status based on actual service connection status
      isConnected = widget.chatService.isConnected;
      print('ChatScreen: 更新后的连接状态: ${isConnected}');
    };

    widget.chatService.onDisconnected = () {
      print('ChatScreen: WebSocket已断开');
      isConnected = false;
    };

    widget.chatService.onError = (error) {
      print('ChatScreen: WebSocket错误: $error');
      isConnected = false;
    };

    // 初始化连接状态 - use actual service connection status
    // Use Future.delayed to ensure state is updated after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isConnected = widget.chatService.isConnected;
      print('ChatScreen: 初始连接状态: ${isConnected}');

      // If not connected, try to connect
      if (!widget.chatService.isConnected) {
        print('ChatScreen: 检测到未连接，尝试连接...');
        _tryInitialConnection();
      }
    });
  }

  // 尝试初始连接的方法
  Future<void> _tryInitialConnection() async {
    String connectId = widget.chartModel.thirdUserInfo?.account ?? '';
    bool connected = await widget.chatService.connect(connectId);
    if (connected) {
      isConnected = true;
      print('ChatScreen: 重新连接成功');
    } else {
      print('ChatScreen: 重新连接失败');
    }
  }

  void _uploadFile() async {
    final result = await HJBottomSheet.wxPicker(
      context,
      [],
      1,
      RequestType.common,
    );
    if (result != null && result.isNotEmpty) {
      ProgressHUD.showLoadingText(S.current.uploading_file);

      final fileUrl = await uploadFile([result[0]], widget.sessionId);
      String contentType;
      final ext = fileUrl[0].split('.').last.toLowerCase();
      if (fileUrl.isNotEmpty) {
        if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(ext)) {
          contentType = 'IMAGE';
        } else if (['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'].contains(ext)) {
          contentType = 'VIDEO';
        } else {
          ProgressHUD.showError(S.current.unsupported_file_type);
          return;
        }
        ProgressHUD.hide();
        await widget.chartModel.sendMediaMessage(
          fileUrl[0],
          contentType,
          widget.sessionId,
        );
      } else {
        print('上传文件失败');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.chartModel,
      child: Consumer<ChartModel>(
        builder: (context, chartModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                S.current.online_customer_service,
                style: TextStyle(fontSize: 16.px),
              ),
              backgroundColor: const Color(0xFFE53E3E),
              foregroundColor: Colors.white,
              elevation: 0,
              // 返回按钮
              leading: IconButton(
                icon: Icon(Icons.arrow_back, size: 24.px),
                onPressed: () {
                  RouteUtils.pop(context);
                },
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.chatService.isConnected
                        ? Icon(Icons.circle, color: Colors.green, size: 14.px)
                        : Icon(Icons.circle, color: Colors.red, size: 14.px),
                    SizedBox(width: 8.px),
                    Text(
                      S.current.customer_service,
                      style: TextStyle(fontSize: 14.px, color: Colors.white),
                    ),
                    SizedBox(width: 16.px),
                  ],
                ),
              ],
            ),
            body: SafeArea(
              bottom: true,
              child: Column(
                children: [
                  // Chat messages list
                  _buildSessionInfoBanner(),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.px),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: chartModel.messages.length,
                        itemBuilder: (context, index) {
                          ChatMessageModel message = chartModel.messages[index];
                          bool isOwnMessage = message.senderType != 'AGENT';
                          bool isSystemMessage =
                              message.senderType == 'SYSTEM' ||
                              message.senderName == S.current.system;

                          // Determine message type
                          if (isSystemMessage) {
                            return _buildSystemMessage(message);
                          } else {
                            // 判断是否需要显示时间
                            bool showTime = _shouldShowTime(index);
                            return _buildChatMessage(
                              message,
                              isOwnMessage,
                              showTime: showTime,
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  // Input area
                  Container(
                    padding: EdgeInsets.all(8.px),
                    child: Row(
                      children: [
                        // 语音输入
                        Container(
                          width: 40.px,
                          height: 40.px,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.px),
                          ),
                          child: IconButton(
                            icon: Icon(
                              size: 24.px,
                              isVoiceInput ? Icons.keyboard : Icons.mic,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isVoiceInput = !isVoiceInput;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 6.px),
                        Expanded(
                          child: Container(
                            height: 40.px,
                            padding: EdgeInsets.symmetric(horizontal: 4.px),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.px),
                            ),
                            child:
                                isVoiceInput
                                    ? VoiceRecordButton(
                                      startRecording:
                                          () => _voiceMessageService
                                              .startRecording(
                                                widget.chartModel,
                                              ),
                                      stopRecording:
                                          () => _voiceMessageService
                                              .stopRecording(widget.chartModel),
                                      cancelRecording:
                                          () =>
                                              _voiceMessageService
                                                  .cancelRecording(),
                                    )
                                    : TextField(
                                      style: TextStyle(fontSize: 12.px),
                                      controller: _messageController,
                                      decoration: InputDecoration(
                                        hintText: S.current.inputMessage(
                                          S.current.message,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.px,
                                          vertical: 12.px,
                                        ),
                                      ),
                                      onSubmitted: (value) {
                                        _sendMessage();
                                      },
                                    ),
                          ),
                        ),
                        SizedBox(width: 6.px),
                        // Upload button
                        Container(
                          width: 40.px,
                          height: 40.px,
                          decoration: BoxDecoration(
                            color: Color(0xFFE53E3E),
                            borderRadius: BorderRadius.circular(10.px),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.attach_file, color: Colors.white),
                            onPressed: _uploadFile,
                          ),
                        ),
                        SizedBox(width: 6.px),
                        Container(
                          width: 40.px,
                          height: 40.px,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53E3E),
                            borderRadius: BorderRadius.circular(10.px),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.send, color: Colors.white),
                            onPressed: _sendMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSystemMessage(ChatMessageModel message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.px),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16.px),
          ),
          child: Text(
            message.content,
            style: TextStyle(color: Colors.grey, fontSize: 12.px),
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
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.px, vertical: 2.px),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4.px),
                ),
                child: Text(
                  _formatMessageTime(message.createTime ?? message.timestamp),
                  style: TextStyle(fontSize: 10.px, color: Colors.grey),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isOwnMessage)
            Container(
              padding: EdgeInsets.all(4.px),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(8.px),
              ),
              child: Icon(Icons.person, size: 16.px, color: Color(0xFFE53E3E)),
            ),
          if (!isOwnMessage) SizedBox(width: 8.px),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 6.px),
              decoration: BoxDecoration(
                color: isOwnMessage ? Color(0xFFE53E3E) : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.px),
                  topRight: Radius.circular(8.px),
                  bottomLeft:
                      isOwnMessage
                          ? Radius.circular(8.px)
                          : Radius.circular(4.px),
                  bottomRight:
                      isOwnMessage
                          ? Radius.circular(4.px)
                          : Radius.circular(8.px),
                ),
              ),
              child: _buildMessageContent(message, isOwnMessage),
            ),
          ),
          if (isOwnMessage) SizedBox(width: 6.px),
          if (isOwnMessage)
            Container(
              padding: EdgeInsets.all(6.px),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(8.px),
              ),
              child: Icon(Icons.person, size: 16.px, color: Color(0xFFE53E3E)),
            ),
        ],
      ),
    );

    return Container(
      // margin: EdgeInsets.only(bottom: 10.px),
      padding: EdgeInsets.only(
        left: 12.px,
        right: 12.px,
        top: 6.px,
        bottom: 6.px,
      ),
      child: Column(children: contentWidgets),
    );
  }

  Widget _buildSessionInfoBanner() {
    final session = widget.chartModel.currentSession;
    print('session: $session');
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 10.px),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEF),
        borderRadius: BorderRadius.circular(10.px),
        border: Border.all(color: const Color(0xFFE53E3E).withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53E3E).withOpacity(0.08),
            blurRadius: 8.px,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.emergency_alarm_session,
            style: TextStyle(
              fontSize: 14.px,
              fontWeight: FontWeight.w700,
              color: Color(0xFFB71C1C),
            ),
          ),
          if (session?.orderNo != null) ...[
            Text(
              S.current.alarm_order_number(session?.orderNo ?? ''),
              style: TextStyle(
                fontSize: 12.px,
                fontWeight: FontWeight.w600,
                color: Color(0xFF880E4F),
              ),
            ),
            SizedBox(height: 4.px),
          ],
          if (session?.nickName != null) ...[
            SizedBox(height: 2.px),
            _buildBannerLine(
              icon: Icons.person_outline,
              label: S.current.reporter,
              value: session?.nickName ?? '',
            ),
          ],
          if (session?.updateTime != null)
            Padding(
              padding: EdgeInsets.only(top: 4.px),
              child: _buildBannerLine(
                icon: Icons.history,
                label: S.current.latest_time,
                value: session?.updateTime ?? '',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBannerLine({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16.px, color: Color(0xFFE53935)),
        SizedBox(width: 6.px),
        Text(
          '$label：',
          style: TextStyle(
            fontSize: 12.px,
            color: Color(0xFF424242),
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.px,
              color: Color(0xFF424242),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // 构建消息内容，根据内容类型显示不同的组件
  Widget _buildMessageContent(ChatMessageModel message, bool isOwnMessage) {
    // 根据消息的contentType判断显示类型
    String contentType = message.contentType ?? 'TEXT';

    switch (contentType.toUpperCase()) {
      case 'IMAGE':
        String imageUrl = _getResourceUrl(message.content);
        return ImageMessageWidget(
          imageUrl: imageUrl,
          isOwnMessage: isOwnMessage,
        );
      case 'VIDEO':
        String videoUrl = _getResourceUrl(message.content);
        return VideoMessageWidget(
          videoUrl: videoUrl,
          isOwnMessage: isOwnMessage,
        );
      case 'AUDIO':
        String audioUrl = _getResourceUrl(message.content);
        return AudioMessageWidget(
          audioUrl: audioUrl,
          isOwnMessage: isOwnMessage,
        );
      case 'TEXT':
      default:
        return Text(
          message.content,
          style: TextStyle(color: isOwnMessage ? Colors.white : Colors.black87),
        );
    }
  }

  // 获取完整资源URL
  String _getResourceUrl(String relativePath) {
    // 如果路径已经是完整URL，直接返回
    if (relativePath.startsWith('http://') ||
        relativePath.startsWith('https://')) {
      return relativePath;
    }

    // 否则拼接基础URL
    return '${ResourceConfig.resourceApi}/$relativePath';
  }

  String _formatMessageTime(String timeString) {
    if (_showRelativeTime) {
      return Utils.formatRelativeTime(timeString);
    } else {
      return Utils.formatRelativeTime(timeString);
    }
  }

  void _sendMessage() async {
    String text = _messageController.text.trim();
    print('=== 尝试发送消息 ===');
    print('消息内容: $text');
    print('消息是否为空: ${text.isEmpty}');
    print('ChatService连接状态: ${widget.chartModel.isConnected}');
    print('本地连接状态: ${isConnected}');
    print('==================');

    // 检查消息内容
    if (text.isEmpty) {
      print('消息为空，无法发送');
      ProgressHUD.showError(S.current.inputMessage(S.current.message));
      return;
    }

    // 检查连接状态 - if not connected, try to connect first
    if (!widget.chatService.isConnected) {
      print('ChatService未连接，尝试重新连接...');
      await _tryReconnect();

      // After reconnection attempt, check status again
      if (!widget.chatService.isConnected) {
        print('重连后仍然未连接，无法发送消息');
        ProgressHUD.showError(S.current.networkError);
        return;
      }
    }

    // 使用ChatController统一发送文本消息
    await widget.chartModel.sendTextMessage(text, sessionId: widget.sessionId);

    _messageController.clear();
    _scrollToBottom();
    print('消息发送成功');
  }

  // 尝试重新连接的方法
  Future<void> _tryReconnect() async {
    // 显示连接尝试提示
    print('ChatScreen: 正在尝试重新连接...');
    ProgressHUD.showText(S.current.trying_to_reconnect);

    // 使用SOSAlarmController中的user info来获取连接ID
    String connectId = widget.chartModel.thirdUserInfo?.account ?? '';

    bool connected = await widget.chatService.connect(connectId);
    if (connected) {
      isConnected = widget.chatService.isConnected; // Use actual service status
      print('ChatScreen: 重新连接成功，当前连接状态: ${isConnected}');
      ProgressHUD.showSuccess(S.current.reconnected_to_server);
    } else {
      isConnected = false;
      print('ChatScreen: 重新连接失败，当前连接状态: ${isConnected}');
      ProgressHUD.showError(S.current.failed_to_reconnect_to_server);
    }
  }

  // 加载聊天历史记录
  Future<void> _loadChatHistory() async {
    SosUtils.getChatHistory(
      widget.sessionId,
      success: (value) {
        if (value != null && value['code'] == 200) {
          final data = value['data'];
          if (data != null && data['records'] != null) {
            List<dynamic> records = data['records'];
            List<ChatMessageModel> historyMessages =
                records.map((record) {
                  String senderType =
                      record['senderType']?.toString() ?? 'USER';
                  return ChatMessageModel.fromJson(record);
                }).toList();
            widget.chartModel.messages = historyMessages;
            setState(() {});
          }
        }
      },
      fail: (code, error) {
        print('加载聊天历史记录失败: $error');
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool _shouldShowTime(int index) {
    // 使用ChatController中的消息列表
    if (index == 0) return true; // 第一条消息总是显示时间

    final currentMessage = widget.chartModel.messages[index];
    final previousMessage = widget.chartModel.messages[index - 1];

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
}

// Video Player Widget for displaying video messages
class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onPreview;

  const VideoPlayerItem(this.videoUrl, {Key? key, this.onPreview})
    : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return GestureDetector(
        onTap: widget.onPreview,
        child: Container(
          width: 200,
          height: 150,
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onPreview,
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(_controller),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                  setState(() {}); // Update UI
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 视频预览播放器组件
class VideoPreviewPlayer extends StatefulWidget {
  final String videoUrl;

  const VideoPreviewPlayer({Key? key, required this.videoUrl})
    : super(key: key);

  @override
  State<VideoPreviewPlayer> createState() => _VideoPreviewPlayerState();
}

class _VideoPreviewPlayerState extends State<VideoPreviewPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      padding: EdgeInsets.all(8.px),
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
