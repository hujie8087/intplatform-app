class DeliveryFeeModel {
  int? id;
  String? name;
  String? billingConditions;
  double? price;

  DeliveryFeeModel({this.id, this.name, this.billingConditions, this.price});

  DeliveryFeeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    billingConditions = json['billingConditions'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['billingConditions'] = this.billingConditions;
    data['price'] = this.price;
    return data;
  }
}
