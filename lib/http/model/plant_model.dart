class PlantModel {
  int? fId;
  String? name;
  String? picture;
  String? introduce;
  String? location;
  String? type;
  String? status;
  int? sort;
  String? remark;
  String? language;
  String? food;
  String? habit;
  String? origin;
  String? peacockType;
  String? reproduce;
  String? otherName;
  String? code;
  String? feature;

  PlantModel({
    this.fId,
    this.name,
    this.picture,
    this.introduce,
    this.location,
    this.type,
    this.status,
    this.sort,
    this.remark,
    this.language,
    this.food,
    this.habit,
    this.origin,
    this.peacockType,
    this.reproduce,
    this.code,
    this.feature,
    this.otherName,
  });

  PlantModel.fromJson(Map<String, dynamic> json) {
    fId = json["fId"];
    name = json["name"];
    picture = json["picture"];
    introduce = json["introduce"];
    location = json["location"];
    type = json["type"];
    status = json["status"];
    sort = json["sort"];
    remark = json["remark"];
    language = json["language"];
    food = json["food"];
    habit = json["habit"];
    origin = json["origin"];
    peacockType = json["peacockType"];
    reproduce = json["reproduce"];
    code = json["code"];
    feature = json["feature"];
    otherName = json["otherName"];
  }

  static List<PlantModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => PlantModel.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["fId"] = fId;
    _data["name"] = name;
    _data["picture"] = picture;
    _data["introduce"] = introduce;
    _data["location"] = location;
    _data["type"] = type;
    _data["status"] = status;
    _data["sort"] = sort;
    _data["remark"] = remark;
    _data["language"] = language;
    _data["food"] = food;
    _data["habit"] = habit;
    _data["origin"] = origin;
    _data["peacockType"] = peacockType;
    _data["reproduce"] = reproduce;
    _data["code"] = code;
    _data["otherName"] = otherName;
    _data["feature"] = feature;
    return _data;
  }
}

class PlantTreeModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  Null? endQueryTime;
  int? id;
  String? name;
  String? code;
  int? type;
  int? sort;
  String? status;
  String? delFlag;
  String? deleteBy;
  String? deleteTime;
  List<PlantModel>? children;

  PlantTreeModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.name,
    this.code,
    this.type,
    this.sort,
    this.status,
    this.delFlag,
    this.deleteBy,
    this.deleteTime,
    this.children,
  });

  PlantTreeModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    name = json['name'];
    code = json['code'];
    type = json['type'];
    sort = json['sort'];
    status = json['status'];
    delFlag = json['delFlag'];
    deleteBy = json['deleteBy'];
    deleteTime = json['deleteTime'];
    if (json['children'] != null) {
      children = <PlantModel>[];
      json['children'].forEach((v) {
        children!.add(new PlantModel.fromJson(v));
      });
    }
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
    data['code'] = this.code;
    data['type'] = this.type;
    data['sort'] = this.sort;
    data['status'] = this.status;
    data['delFlag'] = this.delFlag;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
