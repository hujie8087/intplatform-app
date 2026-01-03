class HazardReportModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  String? name;
  String? location;
  String? userName;
  String? findTime;
  String? reportPerson;
  String? tel;
  String? describes;
  int? progress;
  String? url;
  String? handleBy;
  String? handleTime;
  String? handleResult;
  String? handlePhoto;
  String? delFlag;
  int? type;
  int? isRead;

  HazardReportModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.name,
    this.location,
    this.userName,
    this.findTime,
    this.reportPerson,
    this.tel,
    this.describes,
    this.progress,
    this.url,
    this.handleBy,
    this.handleTime,
    this.handleResult,
    this.handlePhoto,
    this.delFlag,
    this.type,
    this.isRead,
  });

  HazardReportModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    name = json['name'];
    location = json['location'];
    userName = json['userName'];
    findTime = json['findTime'];
    reportPerson = json['reportPerson'];
    tel = json['tel'];
    describes = json['describes'];
    progress = json['progress'];
    url = json['url'];
    handleBy = json['handleBy'];
    handleTime = json['handleTime'];
    handleResult = json['handleResult'];
    handlePhoto = json['handlePhoto'];
    delFlag = json['delFlag'];
    type = json['type'];
    isRead = json['isRead'];
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
    data['location'] = this.location;
    data['userName'] = this.userName;
    data['findTime'] = this.findTime;
    data['reportPerson'] = this.reportPerson;
    data['tel'] = this.tel;
    data['describes'] = this.describes;
    data['progress'] = this.progress;
    data['url'] = this.url;
    data['handleBy'] = this.handleBy;
    data['handleTime'] = this.handleTime;
    data['handleResult'] = this.handleResult;
    data['handlePhoto'] = this.handlePhoto;
    data['delFlag'] = this.delFlag;
    data['type'] = this.type;
    data['isRead'] = this.isRead;
    return data;
  }
}
