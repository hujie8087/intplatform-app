class RestaurantViewModel {
  List<RestaurantModel?> data = [];

  RestaurantViewModel(this.data);

  RestaurantViewModel.fromJson(dynamic json) {
    if (json is List) {
      for (var element in json) {
        data.add(RestaurantModel.fromJson(element));
      }
    }
  }
}

class RestaurantModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  int? id;
  String? typeId;
  String? name;
  String? image;
  int? status;
  String? startTime;
  String? endTime;
  int? bookTable;
  int? pickup;
  List<dynamic>? pickTypes;
  String? code;

  RestaurantModel(
      {this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.remark,
      this.id,
      this.typeId,
      this.name,
      this.image,
      this.status,
      this.endTime,
      this.startTime,
      this.bookTable,
      this.pickup,
      this.pickTypes,
      this.code});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    id = json['id'];
    typeId = json['typeId'];
    name = json['name'];
    image = json['image'];
    status = json['status'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    bookTable = json['bookTable'];
    pickup = json['pickup'];
    pickTypes = json['pickTypes'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['id'] = this.id;
    data['typeId'] = this.typeId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['status'] = this.status;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['bookTable'] = this.bookTable;
    data['pickup'] = this.pickup;
    data['pickTypes'] = this.pickTypes ?? null;
    data['code'] = this.code;
    return data;
  }
}
