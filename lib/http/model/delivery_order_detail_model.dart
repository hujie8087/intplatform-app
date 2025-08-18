import 'package:logistics_app/http/model/delivery_staff_model.dart';

class DeliveryOrderDetailModel {
  OrderDelivery? orderDelivery;
  List<OrderDeliveryLocations>? orderDeliveryLocations;
  List<OrderDeliveryItemDetailsList>? orderDeliveryItemDetailsList;
  List<StatusNodes>? statusNodes;
  DeliveryStaffModel? deliveryStaff;

  DeliveryOrderDetailModel(
      {this.orderDelivery,
      this.orderDeliveryLocations,
      this.orderDeliveryItemDetailsList,
      this.statusNodes,
      this.deliveryStaff});

  DeliveryOrderDetailModel.fromJson(Map<String, dynamic> json) {
    orderDelivery = json['orderDelivery'] != null
        ? new OrderDelivery.fromJson(json['orderDelivery'])
        : null;
    if (json['orderDeliveryLocations'] != null) {
      orderDeliveryLocations = <OrderDeliveryLocations>[];
      json['orderDeliveryLocations'].forEach((v) {
        orderDeliveryLocations!.add(new OrderDeliveryLocations.fromJson(v));
      });
    }
    if (json['orderDeliveryItemDetailsList'] != null) {
      orderDeliveryItemDetailsList = <OrderDeliveryItemDetailsList>[];

      json['orderDeliveryItemDetailsList'].forEach((v) {
        orderDeliveryItemDetailsList!
            .add(new OrderDeliveryItemDetailsList.fromJson(v));
      });
    }
    if (json['statusNodes'] != null) {
      statusNodes = <StatusNodes>[];
      json['statusNodes'].forEach((v) {
        statusNodes!.add(new StatusNodes.fromJson(v));
      });
    }
    if (json['deliveryStaff'] != null) {
      deliveryStaff = DeliveryStaffModel.fromJson(json['deliveryStaff']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderDelivery != null) {
      data['orderDelivery'] = this.orderDelivery!.toJson();
    }
    // if (this.orderDeliveryLocations != null) {
    //   data['orderDeliveryLocations'] =
    //       this.orderDeliveryLocations!.map((v) => v.toJson()).toList();
    // }
    if (this.orderDeliveryItemDetailsList != null) {
      data['orderDeliveryItemDetailsList'] =
          this.orderDeliveryItemDetailsList!.map((v) => v.toJson()).toList();
    }
    if (this.statusNodes != null) {
      data['statusNodes'] = this.statusNodes!.map((v) => v.toJson()).toList();
    }
    if (this.deliveryStaff != null) {
      data['deliveryStaff'] = this.deliveryStaff!.toJson();
    }
    return data;
  }
}

class OrderDelivery {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  String? orderNo;
  int? orderType;
  String? nick;
  String? deliveryName;
  String? deliveryTel;
  String? deliveryAddress;
  String? deliveryTime;
  String? orderTime;
  double? deliveryFee;
  double? actualPayment;
  String? delFlag;
  String? deleteBy;
  String? deleteTime;
  String? sourceNo;
  int? deliveryStatus;
  String? sourceType;
  String? deliveryStaffId;
  String? deliveryNo;
  String? arrivalTime;
  String? acceptTime;
  String? receiptTime;
  String? code;
  String? msg;

  OrderDelivery(
      {this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.remark,
      this.startQueryTime,
      this.endQueryTime,
      this.id,
      this.orderNo,
      this.orderType,
      this.nick,
      this.deliveryName,
      this.deliveryTel,
      this.deliveryAddress,
      this.deliveryTime,
      this.orderTime,
      this.deliveryFee,
      this.actualPayment,
      this.delFlag,
      this.deleteBy,
      this.deleteTime,
      this.sourceNo,
      this.deliveryStatus,
      this.sourceType,
      this.deliveryStaffId,
      this.deliveryNo,
      this.arrivalTime,
      this.acceptTime,
      this.receiptTime,
      this.code,
      this.msg});

  OrderDelivery.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    orderNo = json['orderNo'];
    orderType = json['orderType'];
    nick = json['nick'];
    deliveryName = json['deliveryName'];
    deliveryTel = json['deliveryTel'];
    deliveryAddress = json['deliveryAddress'];
    deliveryTime = json['deliveryTime'];
    orderTime = json['orderTime'];
    deliveryFee = json['deliveryFee'];
    actualPayment = json['actualPayment'];
    delFlag = json['delFlag'];
    deleteBy = json['deleteBy'];
    deleteTime = json['deleteTime'];
    sourceNo = json['sourceNo'];
    deliveryStatus = json['deliveryStatus'];
    sourceType = json['sourceType'];
    deliveryStaffId = json['deliveryStaffId'];
    deliveryNo = json['deliveryNo'];
    arrivalTime = json['arrivalTime'];
    acceptTime = json['acceptTime'];
    receiptTime = json['receiptTime'];
    code = json['code'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['startQueryTime'] = this.startQueryTime;
    data['endQueryTime'] = this.endQueryTime;
    data['id'] = this.id;
    data['orderNo'] = this.orderNo;
    data['orderType'] = this.orderType;
    data['nick'] = this.nick;
    data['deliveryName'] = this.deliveryName;
    data['deliveryTel'] = this.deliveryTel;
    data['deliveryAddress'] = this.deliveryAddress;
    data['deliveryTime'] = this.deliveryTime;
    data['orderTime'] = this.orderTime;
    data['deliveryFee'] = this.deliveryFee;
    data['actualPayment'] = this.actualPayment;
    data['delFlag'] = this.delFlag;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    data['sourceNo'] = this.sourceNo;
    data['deliveryStatus'] = this.deliveryStatus;
    data['sourceType'] = this.sourceType;
    data['deliveryStaffId'] = this.deliveryStaffId;
    data['deliveryNo'] = this.deliveryNo;
    data['arrivalTime'] = this.arrivalTime;
    data['acceptTime'] = this.acceptTime;
    data['receiptTime'] = this.receiptTime;
    data['code'] = this.code;
    data['msg'] = this.msg;
    return data;
  }
}

class OrderDeliveryItemDetailsList {
  int? id;
  String? sourceNo;
  String? itemName;
  int? itemQuantity;
  double? itemPrice;
  String? remarks;
  String? delFlag;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? deleteBy;
  String? deleteTime;
  String? def1;
  String? def2;
  String? def3;
  String? def4;
  String? status;

  OrderDeliveryItemDetailsList(
      {this.id,
      this.sourceNo,
      this.itemName,
      this.itemQuantity,
      this.itemPrice,
      this.remarks,
      this.delFlag,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.deleteBy,
      this.deleteTime,
      this.def1,
      this.def2,
      this.def3,
      this.def4,
      this.status});

  OrderDeliveryItemDetailsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sourceNo = json['sourceNo'];
    itemName = json['itemName'];
    itemQuantity = json['itemQuantity'];
    itemPrice = json['itemPrice'];
    remarks = json['remarks'];
    delFlag = json['delFlag'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    deleteBy = json['deleteBy'];
    deleteTime = json['deleteTime'];
    def1 = json['def1'];
    def2 = json['def2'];
    def3 = json['def3'];
    def4 = json['def4'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sourceNo'] = this.sourceNo;
    data['itemName'] = this.itemName;
    data['itemQuantity'] = this.itemQuantity;
    data['itemPrice'] = this.itemPrice;
    data['remarks'] = this.remarks;
    data['delFlag'] = this.delFlag;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    data['def1'] = this.def1;
    data['def2'] = this.def2;
    data['def3'] = this.def3;
    data['def4'] = this.def4;
    data['status'] = this.status;
    return data;
  }
}

class StatusNodes {
  int? status;
  String? time;
  String? deliveryStaffMsg;

  StatusNodes({this.status, this.time, this.deliveryStaffMsg});

  StatusNodes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    deliveryStaffMsg = json['deliveryStaffMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['time'] = this.time;
    data['deliveryStaffMsg'] = this.deliveryStaffMsg;
    return data;
  }
}

class OrderDeliveryLocations {
  String? latitude;
  String? longitude;

  OrderDeliveryLocations({this.latitude, this.longitude});

  OrderDeliveryLocations.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
