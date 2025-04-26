class FoodRecommendModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? rdId;
  String? rdLocation;
  String? rdDate;
  String? rdTime;
  String? foodName;
  String? rdReason;
  String photoUrl;
  String? deleteBy;
  String? deleteTime;
  String? delFlag;
  String? status;
  String? recommendedBy;

  FoodRecommendModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.rdId,
    this.rdLocation,
    this.rdDate,
    this.rdTime,
    this.foodName,
    this.rdReason,
    this.deleteBy,
    this.deleteTime,
    this.delFlag,
    this.status,
    this.recommendedBy,
    this.photoUrl = '', // ✅ 给一个默认值即可解决报错
  });

  factory FoodRecommendModel.fromJson(Map<String, dynamic> json) {
    return FoodRecommendModel(
      createBy: json["createBy"],
      createTime: json["createTime"],
      updateBy: json["updateBy"],
      updateTime: json["updateTime"],
      remark: json["remark"],
      startQueryTime: json["startQueryTime"],
      endQueryTime: json["endQueryTime"],
      rdId: json["rdId"],
      rdLocation: json["rdLocation"],
      rdDate: json["rdDate"],
      rdTime: json["rdTime"],
      foodName: json["foodName"],
      rdReason: json["rdReason"],
      photoUrl: json["photoUrl"] ?? '', // ✅ 兼容 null
      deleteBy: json["deleteBy"],
      deleteTime: json["deleteTime"],
      delFlag: json["delFlag"],
      status: json["status"],
      recommendedBy: json["recommendedBy"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "createBy": createBy,
      "createTime": createTime,
      "updateBy": updateBy,
      "updateTime": updateTime,
      "remark": remark,
      "startQueryTime": startQueryTime,
      "endQueryTime": endQueryTime,
      "rdId": rdId,
      "rdLocation": rdLocation,
      "rdDate": rdDate,
      "rdTime": rdTime,
      "foodName": foodName,
      "rdReason": rdReason,
      "photoUrl": photoUrl,
      "deleteBy": deleteBy,
      "deleteTime": deleteTime,
      "delFlag": delFlag,
      "status": status,
      "recommendedBy": recommendedBy,
    };
  }
}
