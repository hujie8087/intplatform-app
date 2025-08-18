class RestaurantPickupViewModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  int? id;
  String? name;
  int? status;
  String? delFlag;
  String? deleteBy;
  String? deleteTime;

  RestaurantPickupViewModel(
      {this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.remark,
      this.id,
      this.name,
      this.status,
      this.delFlag,
      this.deleteBy,
      this.deleteTime});

  RestaurantPickupViewModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    id = json['id'];
    name = json['name'];
    status = json['status'];
    delFlag = json['delFlag'];
    deleteBy = json['deleteBy'];
    deleteTime = json['deleteTime'];
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
    data['status'] = this.status;
    data['delFlag'] = this.delFlag;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    return data;
  }
}
