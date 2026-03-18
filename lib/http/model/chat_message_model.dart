class ChatMessageModel {
  final String? id;
  final String? messageId;
  final String sessionId;
  final String senderType;
  final String senderId;
  final String senderName;
  final String type;
  final String userId;
  final String nickName;
  final String userName;
  final String contentType;
  final String content;
  final String timestamp;
  final bool? isRead;
  final String? status;
  final String userType;
  final String? createTime;
  final String? updateTime;
  final String? createBy;
  final String? updateBy;
  final String? avatar;
  final int? duration;
  final dynamic extra;

  ChatMessageModel({
    this.id,
    this.messageId,
    required this.sessionId,
    required this.senderType,
    required this.senderId,
    required this.senderName,
    required this.type,
    required this.userId,
    required this.nickName,
    required this.userName,
    required this.contentType,
    required this.content,
    required this.timestamp,
    this.isRead,
    this.status,
    required this.userType,
    this.createTime,
    this.updateTime,
    this.createBy,
    this.updateBy,
    this.avatar,
    this.duration,
    this.extra,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id']?.toString(),
      messageId: json['messageId']?.toString() ?? json['id']?.toString(),
      sessionId: json['sessionId']?.toString() ?? '',
      senderType: json['senderType']?.toString() ?? 'USER',
      senderId: json['senderId']?.toString() ?? '',
      senderName:
          json['senderName']?.toString() ??
          (json['senderType']?.toString() == 'AGENT' ? '客服' : '用户'),
      type: json['type']?.toString() ?? 'CHAT_MESSAGE',
      userId: json['userId']?.toString() ?? json['senderId']?.toString() ?? '',
      nickName: json['nickName']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      contentType: json['contentType']?.toString() ?? 'TEXT',
      content: json['content']?.toString() ?? '',
      timestamp:
          json['timestamp']?.toString() ??
          json['createTime']?.toString() ??
          DateTime.now().toIso8601String(),
      isRead:
          json['isRead'] as bool? ??
          (json['status']?.toString().toUpperCase() == 'READ'.toUpperCase()),
      status: json['status']?.toString(),
      userType:
          json['userType']?.toString() ??
          json['senderType']?.toString() ??
          'USER',
      createTime: json['createTime']?.toString(),
      updateTime: json['updateTime']?.toString(),
      createBy: json['createBy']?.toString(),
      updateBy: json['updateBy']?.toString(),
      avatar: json['avatar']?.toString(),
      duration: json['duration'] as int?,
      extra: json['extra'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['messageId'] = messageId;
    data['sessionId'] = sessionId;
    data['senderType'] = senderType;
    data['senderId'] = senderId;
    data['senderName'] = senderName;
    data['type'] = type;
    data['userId'] = userId;
    data['nickName'] = nickName;
    data['userName'] = userName;
    data['contentType'] = contentType;
    data['content'] = content;
    data['timestamp'] = timestamp;
    data['isRead'] = isRead;
    data['status'] = status;
    data['userType'] = userType;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['createBy'] = createBy;
    data['updateBy'] = updateBy;
    data['avatar'] = avatar;
    data['duration'] = duration;
    data['extra'] = extra;
    return data;
  }
}

class ChatSession {
  final String sessionId;
  final String? userId;
  final String userType;
  final String userName;
  final String? nickName;
  final String? orderId;
  final String? orderNumber;
  final String status;
  final String? createBy;
  final String? updateBy;
  final String createTime;
  final String updateTime;
  final int? unreadCount;
  final String? lastMessage;
  final String? lastMessageTime;
  final String? avatar;
  final String? orderNo;

  ChatSession({
    required this.sessionId,
    this.userId,
    required this.userType,
    required this.userName,
    this.nickName,
    this.orderId,
    this.orderNumber,
    required this.status,
    this.createBy,
    this.updateBy,
    required this.createTime,
    required this.updateTime,
    this.unreadCount,
    this.lastMessage,
    this.lastMessageTime,
    this.avatar,
    this.orderNo,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      sessionId: json['sessionId']?.toString() ?? '',
      userId: json['userId']?.toString(),
      userType: json['userType']?.toString() ?? 'USER',
      userName: json['userName']?.toString() ?? '',
      nickName: json['nickName']?.toString(),
      orderId: json['orderId']?.toString(),
      orderNumber: json['orderNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? 'OPEN',
      createBy: json['createBy']?.toString(),
      updateBy: json['updateBy']?.toString(),
      createTime: json['createTime']?.toString() ?? '',
      updateTime: json['updateTime']?.toString() ?? '',
      unreadCount: json['unreadCount'] as int?,
      lastMessage: json['lastMessage']?.toString(),
      lastMessageTime: json['lastMessageTime']?.toString(),
      avatar: json['avatar']?.toString(),
      orderNo: json['orderNo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['sessionId'] = sessionId;
    data['userId'] = userId;
    data['userType'] = userType;
    data['userName'] = userName;
    data['nickName'] = nickName;
    data['orderId'] = orderId;
    data['orderNumber'] = orderNumber;
    data['status'] = status;
    data['createBy'] = createBy;
    data['updateBy'] = updateBy;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['unreadCount'] = unreadCount;
    data['lastMessage'] = lastMessage;
    data['lastMessageTime'] = lastMessageTime;
    data['avatar'] = avatar;
    data['orderNo'] = orderNo;
    return data;
  }
}
