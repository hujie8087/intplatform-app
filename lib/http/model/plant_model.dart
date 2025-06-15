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
    return _data;
  }
}
