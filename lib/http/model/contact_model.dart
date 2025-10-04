class ContactModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  String? name;
  String? details;
  String? tel;
  String? email;
  String? workTime;
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

  ContactModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.name,
    this.details,
    this.tel,
    this.email,
    this.workTime,
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
  });

  ContactModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    name = json['name'];
    details = json['details'];
    tel = json['tel'];
    email = json['email'];
    workTime = json['workTime'];
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
    data['details'] = this.details;
    data['tel'] = this.tel;
    data['email'] = this.email;
    data['workTime'] = this.workTime;
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
    return data;
  }
}
