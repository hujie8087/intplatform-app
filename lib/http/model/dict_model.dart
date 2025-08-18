class DictModel {
  int? dictCode;
  int? dictSort;
  String? dictLabel;
  String? dictValue;
  String? dictType;
  String? cssClass;
  String? isDefault;
  String? status;
  String? dictLabelEn;
  String? dictLabelId;

  DictModel({
    this.dictCode,
    this.dictSort,
    this.dictLabel,
    this.dictValue,
    this.dictType,
    this.cssClass,
    this.isDefault,
    this.status,
    this.dictLabelEn,
    this.dictLabelId,
  });

  DictModel.fromJson(Map<String, dynamic> json) {
    dictCode = json["dictCode"];
    dictSort = json["dictSort"];
    dictLabel = json["dictLabel"];
    dictValue = json["dictValue"];
    dictType = json["dictType"];
    cssClass = json["cssClass"];
    isDefault = json["isDefault"];
    status = json["status"];
    dictLabelEn = json["dictLabelEn"];
    dictLabelId = json["dictLabelId"];
  }

  static List<DictModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => DictModel.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["dictCode"] = dictCode;
    _data["dictSort"] = dictSort;
    _data["dictLabel"] = dictLabel;
    _data["dictValue"] = dictValue;
    _data["dictType"] = dictType;
    _data["cssClass"] = cssClass;
    _data["isDefault"] = isDefault;
    _data["status"] = status;
    _data["dictLabelEn"] = dictLabelEn;
    _data["dictLabelId"] = dictLabelId;
    return _data;
  }
}
