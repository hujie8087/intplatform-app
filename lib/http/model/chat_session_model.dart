class ChatSessionModel {
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

  ChatSessionModel({
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

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
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
