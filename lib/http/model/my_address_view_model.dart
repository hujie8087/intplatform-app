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
      this.detailedAddress,
      this.isDefault});

  AddressModel.fromJson(dynamic json) {
    if (json["createBy"] is String) {
      createBy = json["createBy"];
    }
    if (json["createTime"] is String) {
      createTime = json["createTime"];
    }
    if (json["updateBy"] is String) {
      updateBy = json["updateBy"];
    }
    updateTime = json["updateTime"];
    if (json["remark"] is String) {
      remark = json["remark"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["tel"] is String) {
      tel = json["tel"];
    }
    if (json["region"] is String) {
      region = json["region"];
    }
    if (json["isDefault"] is String) {
      isDefault = json["isDefault"];
    }
    if (json["detailedAddress"] is String) {
      detailedAddress = json["detailedAddress"];
    }
  }

  String? createBy;
  String? createTime;
  String? updateBy;
  dynamic updateTime;
  String? remark;
  int? id;
  String? name;
  String? tel;
  String? region;
  dynamic detailedAddress;
  String? isDefault;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["createBy"] = createBy;
    _data["createTime"] = createTime;
    _data["updateBy"] = updateBy;
    _data["updateTime"] = updateTime;
    _data["remark"] = remark;
    _data["id"] = id;
    _data["name"] = name;
    _data["tel"] = tel;
    _data["region"] = region;
    _data["detailedAddress"] = detailedAddress;
    _data["isDefault"] = isDefault;
    return _data;
  }
}
