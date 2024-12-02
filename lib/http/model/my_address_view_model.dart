class MyAddressViewModel {
  List<AddressModel?> data = [];

  MyAddressViewModel(this.data);

  MyAddressViewModel.fromJson(dynamic json) {
    if (json is List) {
      for (var element in json) {
        data.add(AddressModel.fromJson(element));
      }
    }
  }
}

class AddressModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  int? id;
  String? name;
  String? tel;
  String? region;
  String? area;
  String? roomNo;
  int? areaId;
  String? detailedAddress;
  String? isDefault;
  String? delFlag;

  AddressModel(
      {this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.remark,
      this.id,
      this.name,
      this.tel,
      this.region,
      this.area,
      this.roomNo,
      this.areaId,
      this.detailedAddress,
      this.isDefault,
      this.delFlag});

  AddressModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    id = json['id'];
    name = json['name'];
    tel = json['tel'];
    region = json['region'];
    area = json['area'];
    roomNo = json['roomNo'];
    areaId = json['areaId'];
    detailedAddress = json['detailedAddress'];
    isDefault = json['isDefault'];
    delFlag = json['delFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['id'] = this.id;
    data['name'] = this.name;
    data['tel'] = this.tel;
    data['region'] = this.region;
    data['area'] = this.area;
    data['roomNo'] = this.roomNo;
    data['areaId'] = this.areaId;
    data['detailedAddress'] = this.detailedAddress;
    data['isDefault'] = this.isDefault;
    data['delFlag'] = this.delFlag;
    return data;
  }
}
