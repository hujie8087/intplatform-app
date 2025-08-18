class DeliveryStationModel {
  int? id;
  String? sourceType;
  String? sourceStation;
  String? status;
  String? delFlag;
  String? address;

  String? contacts;
  String? tel;
  String? longitude;
  String? latitude;
  String? remark;
  String? createBy;
  String? createTime;

  String? updateBy;
  String? updateTime;
  String? deleteBy;
  String? deleteTime;
  String? code;

  DeliveryStationModel(
      {this.id,
      this.sourceType,
      this.sourceStation,
      this.status,
      this.delFlag,
      this.address,
      this.contacts,
      this.tel,
      this.longitude,
      this.latitude,
      this.remark,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.deleteBy,
      this.deleteTime,
      this.code});

  DeliveryStationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sourceType = json['sourceType'];
    sourceStation = json['sourceStation'];
    status = json['status'];
    delFlag = json['delFlag'];

    address = json['address'];
    contacts = json['contacts'];
    tel = json['tel'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    remark = json['remark'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    deleteBy = json['deleteBy'];
    deleteTime = json['deleteTime'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sourceType'] = this.sourceType;
    data['sourceStation'] = this.sourceStation;
    data['status'] = this.status;
    data['delFlag'] = this.delFlag;
    data['address'] = this.address;
    data['contacts'] = this.contacts;
    data['tel'] = this.tel;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['remark'] = this.remark;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    data['code'] = this.code;
    return data;
  }
}
