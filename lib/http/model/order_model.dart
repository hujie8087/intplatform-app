class OrderModel {
  int? id;
  String? no;
  String? nick;
  String? name;
  String? tel;
  int? canteenId;
  String? canteenName;
  String? createTime;
  String? expectedTime;
  int? print;
  int? refund;
  String? endTime;
  int? status;
  String? remark;
  String? deliveryArea;
  int? totalPrice;
  int? postPrice;
  int? pickupType;
  String? tableNumber;
  String? address;
  List<OrderDetailsList>? orderDetailsList;
  String? versionNum;

  OrderModel(
      {this.id,
      this.no,
      this.nick,
      this.name,
      this.tel,
      this.canteenId,
      this.canteenName,
      this.createTime,
      this.expectedTime,
      this.print,
      this.refund,
      this.endTime,
      this.status,
      this.remark,
      this.deliveryArea,
      this.totalPrice,
      this.postPrice,
      this.pickupType,
      this.tableNumber,
      this.address,
      this.orderDetailsList,
      this.versionNum});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    no = json['no'];
    nick = json['nick'];
    name = json['name'];
    tel = json['tel'];
    canteenId = json['canteenId'];
    canteenName = json['canteenName'];
    createTime = json['createTime'];
    expectedTime = json['expectedTime'];
    print = json['print'];
    refund = json['refund'];
    endTime = json['endTime'];
    status = json['status'];
    remark = json['remark'];
    deliveryArea = json['deliveryArea'];
    totalPrice = json['totalPrice'];
    postPrice = json['postPrice'];
    pickupType = json['pickupType'];
    tableNumber = json['tableNumber'];
    address = json['address'];
    if (json['orderDetailsList'] != null) {
      orderDetailsList = <OrderDetailsList>[];
      json['orderDetailsList'].forEach((v) {
        orderDetailsList!.add(new OrderDetailsList.fromJson(v));
      });
    }
    versionNum = json['versionNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['no'] = this.no;
    data['nick'] = this.nick;
    data['name'] = this.name;
    data['tel'] = this.tel;
    data['canteenId'] = this.canteenId;
    data['canteenName'] = this.canteenName;
    data['createTime'] = this.createTime;
    data['expectedTime'] = this.expectedTime;
    data['print'] = this.print;
    data['refund'] = this.refund;
    data['endTime'] = this.endTime;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['deliveryArea'] = this.deliveryArea;
    data['totalPrice'] = this.totalPrice;
    data['postPrice'] = this.postPrice;
    data['pickupType'] = this.pickupType;
    data['tableNumber'] = this.tableNumber;
    data['address'] = this.address;
    if (this.orderDetailsList != null) {
      data['orderDetailsList'] =
          this.orderDetailsList!.map((v) => v.toJson()).toList();
    }
    data['versionNum'] = this.versionNum;
    return data;
  }
}

class OrderDetailsList {
  int? id;
  int? commodityId;
  int? orderId;
  String? code;
  String? name;
  int? num;
  String? deal;
  String? taste;
  int? price;
  String? image;
  String? createTime;

  OrderDetailsList(
      {this.id,
      this.commodityId,
      this.orderId,
      this.code,
      this.name,
      this.num,
      this.deal,
      this.taste,
      this.price,
      this.image,
      this.createTime});

  OrderDetailsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commodityId = json['commodityId'];
    orderId = json['orderId'];
    code = json['code'];
    name = json['name'];
    num = json['num'];
    deal = json['deal'];
    taste = json['taste'];
    price = json['price'];
    image = json['image'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['commodityId'] = this.commodityId;
    data['orderId'] = this.orderId;
    data['code'] = this.code;
    data['name'] = this.name;
    data['num'] = this.num;
    data['deal'] = this.deal;
    data['taste'] = this.taste;
    data['price'] = this.price;
    data['image'] = this.image;
    data['createTime'] = this.createTime;
    return data;
  }
}
