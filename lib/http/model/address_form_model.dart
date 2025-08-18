class AddressFormModel {
  int? id;
  String? name;
  String? region;
  String? area;
  int? areaId;
  String? roomNo;
  String? detailedAddress;
  String? tel;
  String? isDefault;

  AddressFormModel({
    this.id,
    this.name,
    this.region,
    this.area,
    this.areaId,
    this.roomNo,
    this.detailedAddress,
    this.tel,
    this.isDefault,
  });

  factory AddressFormModel.fromJson(Map<String, dynamic> json) {
    return AddressFormModel(
      id: json['id'],
      name: json['name'],
      region: json['region'],
      area: json['area'],
      areaId: json['areaId'],
      roomNo: json['roomNo'],
      detailedAddress: json['detailedAddress'],
      tel: json['tel'],
      isDefault: json['isDefault'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'area': area,
      'areaId': areaId,
      'roomNo': roomNo,
      'detailedAddress': detailedAddress,
      'tel': tel,
      'isDefault': isDefault,
    };
  }
}
