class OtherViewModel {
  dynamic createBy;
  dynamic createTime;
  String? updateBy;
  String? updateTime;
  dynamic remark;
  int? id;
  String? showTitle;
  int? regionId;
  String? region;
  String? address;
  String? businessHours;
  String? head;
  String? telephone;
  String? details;
  String? image;
  String? delFlag;
  dynamic def1;
  dynamic def2;
  dynamic def3;
  dynamic def4;
  dynamic def5;
  dynamic deleteBy;
  dynamic deleteTime;
  dynamic sourceNo;
  String? souceType;

  OtherViewModel(
      {this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.remark,
      this.id,
      this.showTitle,
      this.regionId,
      this.region,
      this.address,
      this.businessHours,
      this.head,
      this.telephone,
      this.details,
      this.image,
      this.delFlag,
      this.def1,
      this.def2,
      this.def3,
      this.def4,
      this.def5,
      this.deleteBy,
      this.deleteTime,
      this.sourceNo,
      this.souceType});

  OtherViewModel.fromJson(Map<String, dynamic> json) {
    createBy = json["createBy"];
    createTime = json["createTime"];
    updateBy = json["updateBy"];
    updateTime = json["updateTime"];
    remark = json["remark"];
    id = json["id"];
    showTitle = json["showTitle"];
    regionId = json["regionId"];
    region = json["region"];
    address = json["address"];
    businessHours = json["businessHours"];
    head = json["head"];
    telephone = json["telephone"];
    details = json["details"];
    image = json["image"];
    delFlag = json["delFlag"];
    def1 = json["def1"];
    def2 = json["def2"];
    def3 = json["def3"];
    def4 = json["def4"];
    def5 = json["def5"];
    deleteBy = json["deleteBy"];
    deleteTime = json["deleteTime"];
    sourceNo = json["sourceNo"];
    souceType = json["souceType"];
  }

  static List<OtherViewModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => OtherViewModel.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["createBy"] = createBy;
    _data["createTime"] = createTime;
    _data["updateBy"] = updateBy;
    _data["updateTime"] = updateTime;
    _data["remark"] = remark;
    _data["id"] = id;
    _data["showTitle"] = showTitle;
    _data["regionId"] = regionId;
    _data["region"] = region;
    _data["address"] = address;
    _data["businessHours"] = businessHours;
    _data["head"] = head;
    _data["telephone"] = telephone;
    _data["details"] = details;
    _data["image"] = image;
    _data["delFlag"] = delFlag;
    _data["def1"] = def1;
    _data["def2"] = def2;
    _data["def3"] = def3;
    _data["def4"] = def4;
    _data["def5"] = def5;
    _data["deleteBy"] = deleteBy;
    _data["deleteTime"] = deleteTime;
    _data["sourceNo"] = sourceNo;
    _data["souceType"] = souceType;
    return _data;
  }
}
