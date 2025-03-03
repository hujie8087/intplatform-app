import 'package:logistics_app/http/model/delivery_staff_model.dart';

class DeliveryOrderModel {
  String createBy;
  String createTime;
  String updateBy;
  String updateTime;
  String remark;
  String? startQueryTime;
  String? endQueryTime;
  int id;
  String orderNo;
  int orderType;
  String nick;
  String deliveryName;
  String deliveryTel;
  String deliveryAddress;
  String deliveryTime;
  String orderTime;
  double deliveryFee;
  double actualPayment;
  String delFlag;
  String deleteBy;
  String? deleteTime;
  String sourceNo;
  int deliveryStatus;
  String? sourceType;
  String? deliveryStaffId;
  String? deliveryNo;
  String? arrivalTime;
  String? acceptTime;
  String? receiptTime;
  String? errorMsg;
  String? code;
  DeliveryStaffModel? deliveryStaff;

  DeliveryOrderModel(
      {required this.createBy,
      required this.createTime,
      required this.updateBy,
      required this.updateTime,
      required this.remark,
      this.startQueryTime,
      this.endQueryTime,
      required this.id,
      required this.orderNo,
      required this.orderType,
      required this.nick,
      required this.deliveryName,
      required this.deliveryTel,
      required this.deliveryAddress,
      required this.deliveryTime,
      required this.orderTime,
      required this.deliveryFee,
      required this.actualPayment,
      required this.delFlag,
      required this.deleteBy,
      this.deleteTime,
      required this.sourceNo,
      required this.deliveryStatus,
      this.sourceType,
      this.deliveryStaffId,
      this.deliveryNo,
      this.arrivalTime,
      this.acceptTime,
      this.receiptTime,
      this.deliveryStaff,
      this.errorMsg,
      this.code});

  factory DeliveryOrderModel.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderModel(
        createBy: json['createBy'] ?? '',
        createTime: json['createTime'] ?? '',
        updateBy: json['updateBy'] ?? '',
        updateTime: json['updateTime'] ?? '',
        remark: json['remark'] ?? '',
        startQueryTime: json['startQueryTime'],
        endQueryTime: json['endQueryTime'],
        id: json['id'] ?? 0,
        orderNo: json['orderNo'] ?? '',
        orderType: json['orderType'] ?? 0,
        nick: json['nick'] ?? '',
        deliveryName: json['deliveryName'] ?? '',
        deliveryTel: json['deliveryTel'] ?? '',
        deliveryAddress: json['deliveryAddress'] ?? '',
        deliveryTime: json['deliveryTime'] ?? '',
        orderTime: json['orderTime'] ?? '',
        deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
        actualPayment: (json['actualPayment'] ?? 0).toDouble(),
        delFlag: json['delFlag'] ?? '0',
        deleteBy: json['deleteBy'] ?? '',
        deleteTime: json['deleteTime'],
        sourceNo: json['sourceNo'] ?? '',
        deliveryStatus: json['deliveryStatus'] ?? 0,
        sourceType: json['sourceType'],
        deliveryStaffId: json['deliveryStaffId'],
        deliveryNo: json['deliveryNo'],
        arrivalTime: json['arrivalTime'],
        acceptTime: json['acceptTime'],
        receiptTime: json['receiptTime'],
        deliveryStaff: json['deliveryStaff'] != null
            ? DeliveryStaffModel.fromJson(json['deliveryStaff'])
            : null,
        errorMsg: json['errorMsg'],
        code: json['code']);
  }

  Map<String, dynamic> toJson() {
    return {
      'createBy': createBy,
      'createTime': createTime,
      'updateBy': updateBy,
      'updateTime': updateTime,
      'remark': remark,
      'startQueryTime': startQueryTime,
      'endQueryTime': endQueryTime,
      'id': id,
      'orderNo': orderNo,
      'orderType': orderType,
      'nick': nick,
      'deliveryName': deliveryName,
      'deliveryTel': deliveryTel,
      'deliveryAddress': deliveryAddress,
      'deliveryTime': deliveryTime,
      'orderTime': orderTime,
      'deliveryFee': deliveryFee,
      'actualPayment': actualPayment,
      'delFlag': delFlag,
      'deleteBy': deleteBy,
      'deleteTime': deleteTime,
      'sourceNo': sourceNo,
      'deliveryStatus': deliveryStatus,
      'sourceType': sourceType,
      'deliveryStaffId': deliveryStaffId,
      'deliveryNo': deliveryNo,
      'arrivalTime': arrivalTime,
      'acceptTime': acceptTime,
      'receiptTime': receiptTime,
      'deliveryStaff': deliveryStaff?.toJson(),
      'errorMsg': errorMsg,
      'code': code,
    };
  }
}
