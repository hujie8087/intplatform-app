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
