class ComplaintMessageModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  String? content;
  String? type;
  int? typeId;
  String? contacts;
  String? phone;
  String? delFlag;
  int? processingStatus;
  String? processingResults;
  String? def1;
  String? def2;
  String? def3;
  String? def4;
  String? moduleType;
  String? deleteBy;
  String? handleBy;
  String? deleteTime;
  String? handleTime;

  ComplaintMessageModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.content,
    this.type,
    this.typeId,
    this.contacts,
    this.phone,
    this.delFlag,
    this.processingStatus,
    this.processingResults,
    this.def1,
    this.def2,
    this.def3,
    this.def4,
    this.moduleType,
    this.deleteBy,
    this.handleBy,
    this.deleteTime,
    this.handleTime,
  });

  ComplaintMessageModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    content = json['content'];
    type = json['type'];
    typeId = json['typeId'];
    contacts = json['contacts'];
    phone = json['phone'];
    delFlag = json['delFlag'];
    processingStatus = json['processingStatus'];
    processingResults = json['processingResults'];
    def1 = json['def1'];
    def2 = json['def2'];
    def3 = json['def3'];
    def4 = json['def4'];
    moduleType = json['moduleType'];
    deleteBy = json['deleteBy'];
    handleBy = json['handleBy'];
    deleteTime = json['deleteTime'];
    handleTime = json['handleTime'];
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
    data['content'] = this.content;
    data['type'] = this.type;
    data['typeId'] = this.typeId;
    data['contacts'] = this.contacts;
    data['phone'] = this.phone;
    data['delFlag'] = this.delFlag;
    data['processingStatus'] = this.processingStatus;
    data['processingResults'] = this.processingResults;
    data['def1'] = this.def1;
    data['def2'] = this.def2;
    data['def3'] = this.def3;
    data['def4'] = this.def4;
    data['moduleType'] = this.moduleType;
    data['deleteBy'] = this.deleteBy;
    data['handleBy'] = this.handleBy;
    data['deleteTime'] = this.deleteTime;
    data['handleTime'] = this.handleTime;
    return data;
  }
}
