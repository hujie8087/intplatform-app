class AddressFormModel {
  int? id;
  String? name;
  String? region;
  String? detailedAddress;
  String? tel;
  String? isDefault;

  AddressFormModel({
    this.id,
    this.name,
    this.region,
    this.detailedAddress,
    this.tel,
    this.isDefault,
  });

  factory AddressFormModel.fromJson(Map<String, dynamic> json) {
    return AddressFormModel(
      id: json['id'],
      name: json['name'],
      region: json['region'],
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
      'detailedAddress': detailedAddress,
      'tel': tel,
      'isDefault': isDefault,
    };
  }
}
