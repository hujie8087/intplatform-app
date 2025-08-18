class RepairViewModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  int? id;
  String? repairArea;
  int? repairAreaId;
  int? repairRoomId;
  String? engineer;
  int? engineerId;
  String? repairMessage;
  String? repairNo;
  String? roomNo;
  String? repairPerson;
  String? tel;
  String? repairPhoto;
  int? repairType;
  int? repairManId;

  String? repairMan;
  int? repairState;
  String? repairTime;
  String? repairNote;
  String? delFlag;
  String? ancestors;
  String? appDelFlag;
  int? rating;
  String? ratingMessage;
  String? readStatus;

  RepairViewModel(
      {this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.id,
      this.repairArea,
      this.repairAreaId,
      this.repairRoomId,
      this.engineer,
      this.engineerId,
      this.repairMessage,
      this.repairNo,
      this.roomNo,
      this.repairPerson,
      this.tel,
      this.repairPhoto,
      this.repairType,
      this.repairManId,
      this.repairMan,
      this.repairState,
      this.repairTime,
      this.repairNote,
      this.delFlag,
      this.ancestors,
      this.appDelFlag,
      this.rating,
      this.ratingMessage,
      this.readStatus});

  RepairViewModel.fromJson(Map<String, dynamic> json) {
    createBy = json["createBy"];
    createTime = json["createTime"];
    updateBy = json["updateBy"];
    updateTime = json["updateTime"];
    engineer = json["engineer"];
    engineerId = json["engineerId"];
    id = json["id"];
    repairArea = json["repairArea"];
    repairAreaId = json["repairAreaId"];
    repairRoomId = json["repairRoomId"];
    repairMessage = json["repairMessage"];
    roomNo = json["roomNo"];
    repairNo = json["repairNo"];

    repairPerson = json["repairPerson"];
    tel = json["tel"];
    repairPhoto = json["repairPhoto"];
    repairType = json["repairType"];
    repairManId = json["repairManId"];
    repairMan = json["repairMan"];
    repairState = json["repairState"];
    repairTime = json["repairTime"];
    repairNote = json["repairNote"];
    delFlag = json["delFlag"];
    ancestors = json["ancestors"];
    appDelFlag = json["appDelFlag"];
    rating = json["rating"];
    ratingMessage = json["ratingMessage"];
    readStatus = json['readStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["createBy"] = createBy;
    _data["createTime"] = createTime;
    _data["updateBy"] = updateBy;
    _data["updateTime"] = updateTime;
    _data["id"] = id;
    _data["repairArea"] = repairArea;
    _data["repairAreaId"] = repairAreaId;
    _data["repairRoomId"] = repairRoomId;
    _data["engineer"] = engineer;
    _data["engineerId"] = engineerId;
    _data["repairMessage"] = repairMessage;
    _data["roomNo"] = roomNo;
    _data["repairPerson"] = repairPerson;
    _data["repairNo"] = repairNo;

    _data["tel"] = tel;
    _data["repairPhoto"] = repairPhoto;
    _data["repairType"] = repairType;
    _data["repairManId"] = repairManId;
    _data["repairMan"] = repairMan;
    _data["repairState"] = repairState;
    _data["repairTime"] = repairTime;
    _data["repairNote"] = repairNote;
    _data["delFlag"] = delFlag;
    _data["ancestors"] = ancestors;
    _data["appDelFlag"] = appDelFlag;
    _data["rating"] = rating;
    _data["ratingMessage"] = ratingMessage;
    _data['readStatus'] = readStatus;
    return _data;
  }
}
