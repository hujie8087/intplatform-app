class FoodMenuModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  String? menuDate;
  String? dids;
  List<Dishs>? dishs;
  String? beginDate;
  String? endDate;

  FoodMenuModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.menuDate,
    this.dids,
    this.dishs,
    this.beginDate,
    this.endDate,
  });

  FoodMenuModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    menuDate = json['menuDate'];
    dids = json['dids'];
    if (json['dishs'] != null) {
      dishs = <Dishs>[];
      json['dishs'].forEach((v) {
        dishs!.add(new Dishs.fromJson(v));
      });
    }
    beginDate = json['beginDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['startQueryTime'] = this.startQueryTime;
    data['endQueryTime'] = this.endQueryTime;
    data['id'] = this.id;
    data['menuDate'] = this.menuDate;
    data['dids'] = this.dids;
    if (this.dishs != null) {
      data['dishs'] = this.dishs!.map((v) => v.toJson()).toList();
    }
    data['beginDate'] = this.beginDate;
    data['endDate'] = this.endDate;
    return data;
  }
}

class Dishs {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  String? name;
  String? englishName;
  String? indonesianName;
  int? status;
  String? description;
  String? imageUrl;
  int? mealType;
  int? dishType;

  Dishs({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.name,
    this.englishName,
    this.indonesianName,
    this.status,
    this.description,
    this.imageUrl,
    this.mealType,
    this.dishType,
  });

  Dishs.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    name = json['name'];
    englishName = json['englishName'];
    indonesianName = json['indonesianName'];
    status = json['status'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    mealType = json['mealType'];
    dishType = json['dishType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['startQueryTime'] = this.startQueryTime;
    data['endQueryTime'] = this.endQueryTime;
    data['id'] = this.id;
    data['name'] = this.name;
    data['englishName'] = this.englishName;
    data['indonesianName'] = this.indonesianName;
    data['status'] = this.status;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['mealType'] = this.mealType;
    data['dishType'] = this.dishType;
    return data;
  }
}
