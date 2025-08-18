class DeliveryStaffModel {
  String createBy;
  DateTime createTime;
  String updateBy;
  DateTime updateTime;
  String? remark;
  DateTime? startQueryTime;
  DateTime? endQueryTime;
  int userId;
  String userName;
  String nickName;
  String tel;
  String? type;
  String? def1;
  String? def2;
  String status;

  DeliveryStaffModel({
    required this.createBy,
    required this.createTime,
    required this.updateBy,
    required this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    required this.userId,
    required this.userName,
    required this.nickName,
    required this.tel,
    required this.type,
    this.def1,
    this.def2,
    required this.status,
  });

  factory DeliveryStaffModel.fromJson(Map<String, dynamic> json) {
    return DeliveryStaffModel(
      createBy: json['createBy'],
      createTime: DateTime.parse(json['createTime']),
      updateBy: json['updateBy'],
      updateTime: DateTime.parse(json['updateTime']),
      remark: json['remark'],
      startQueryTime: json['startQueryTime'] != null
          ? DateTime.parse(json['startQueryTime'])
          : null,
      endQueryTime: json['endQueryTime'] != null
          ? DateTime.parse(json['endQueryTime'])
          : null,
      userId: json['userId'],
      userName: json['userName'],
      nickName: json['nickName'],
      tel: json['tel'],
      type: json['type'],
      def1: json['def1'],
      def2: json['def2'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createBy': createBy,
      'createTime': createTime.toIso8601String(),
      'updateBy': updateBy,
      'updateTime': updateTime.toIso8601String(),
      'remark': remark,
      'startQueryTime': startQueryTime?.toIso8601String(),
      'endQueryTime': endQueryTime?.toIso8601String(),
      'userId': userId,
      'userName': userName,
      'nickName': nickName,
      'tel': tel,
      'type': type,
      'def1': def1,
      'def2': def2,
      'status': status,
    };
  }
}
