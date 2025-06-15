class FoundModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  String? photo;
  String? lostName;
  int? lostNum;
  String? foundName;
  String? foundTime;
  String? foundPlace;
  String? receiveName;
  String? receiveTime;
  String? receivePlace;
  String? isFound;
  String? delFlag;
  String? def1;
  String? def2;
  String? def3;
  String? def4;
  String? def5;
  String? deleteBy;
  String? deleteTime;
  String? sourceNo;
  String? souceType;
  int? reviewStatus;
  String? tel;

  FoundModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.photo,
    this.lostName,
    this.lostNum,
    this.foundName,
    this.foundTime,
    this.foundPlace,
    this.receiveName,
    this.receiveTime,
    this.receivePlace,
    this.isFound,
    this.delFlag,
    this.def1,
    this.def2,
    this.def3,
    this.def4,
    this.def5,
    this.deleteBy,
    this.deleteTime,
    this.sourceNo,
    this.souceType,
    this.tel,
    this.reviewStatus,
  });

  FoundModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    photo = json['photo'];
    lostName = json['lostName'];
    lostNum = json['lostNum'];
    foundName = json['foundName'];
    foundTime = json['foundTime'];
    foundPlace = json['foundPlace'];
    receiveName = json['receiveName'];
    receiveTime = json['receiveTime'];
    receivePlace = json['receivePlace'];
    isFound = json['isFound'];
    delFlag = json['delFlag'];
    def1 = json['def1'];
    def2 = json['def2'];
    def3 = json['def3'];
    def4 = json['def4'];
    def5 = json['def5'];
    deleteBy = json['deleteBy'];
    deleteTime = json['deleteTime'];
    sourceNo = json['sourceNo'];
    souceType = json['souceType'];
    tel = json['tel'];
    reviewStatus = json['reviewStatus'];
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
    data['photo'] = this.photo;
    data['lostName'] = this.lostName;
    data['lostNum'] = this.lostNum;
    data['foundName'] = this.foundName;
    data['foundTime'] = this.foundTime;
    data['foundPlace'] = this.foundPlace;
    data['receiveName'] = this.receiveName;
    data['receiveTime'] = this.receiveTime;
    data['receivePlace'] = this.receivePlace;
    data['isFound'] = this.isFound;
    data['delFlag'] = this.delFlag;
    data['def1'] = this.def1;
    data['def2'] = this.def2;
    data['def3'] = this.def3;
    data['def4'] = this.def4;
    data['def5'] = this.def5;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    data['sourceNo'] = this.sourceNo;
    data['souceType'] = this.souceType;
    data['tel'] = this.tel;
    data['reviewStatus'] = this.reviewStatus;
    return data;
  }
}
