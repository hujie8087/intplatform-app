class GoodDeedModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  String? title;
  String? description;
  String? personName;
  String? contactInfo;
  int? status;
  String? likesCount;
  String? auditTime;
  String? auditUser;
  String? deleteBy;
  String? deleteTime;
  String? delFlag;

  GoodDeedModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.title,
    this.description,
    this.personName,
    this.contactInfo,
    this.status,
    this.likesCount,
    this.auditTime,
    this.auditUser,
    this.deleteBy,
    this.deleteTime,
    this.delFlag,
  });

  GoodDeedModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    title = json['title'];
    description = json['description'];
    personName = json['personName'];
    contactInfo = json['contactInfo'];
    status = json['status'];
    likesCount = json['likesCount'];
    auditTime = json['auditTime'];
    auditUser = json['auditUser'];
    deleteBy = json['deleteBy'];
    deleteTime = json['deleteTime'];
    delFlag = json['delFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['startQueryTime'] = this.startQueryTime;
    data['endQueryTime'] = this.endQueryTime;
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['personName'] = this.personName;
    data['contactInfo'] = this.contactInfo;
    data['status'] = this.status;
    data['likesCount'] = this.likesCount;
    data['auditTime'] = this.auditTime;
    data['auditUser'] = this.auditUser;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    data['delFlag'] = this.delFlag;
    return data;
  }
}
