class AppResourceModel {
  String? createBy;
  String? createTime;
  Null updateBy;
  Null updateTime;
  Null remark;
  Null startQueryTime;
  Null endQueryTime;
  int? id;
  String? resourceType;
  String? resourceKey;
  String? resourceName;
  Null contentType;
  String? content;
  int? sortOrder;
  int? status;
  Null startTime;
  Null endTime;
  int? platform;
  Null extInfo;

  AppResourceModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.resourceType,
    this.resourceKey,
    this.resourceName,
    this.contentType,
    this.content,
    this.sortOrder,
    this.status,
    this.startTime,
    this.endTime,
    this.platform,
    this.extInfo,
  });

  AppResourceModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    resourceType = json['resourceType'];
    resourceKey = json['resourceKey'];
    resourceName = json['resourceName'];
    contentType = json['contentType'];
    content = json['content'];
    sortOrder = json['sortOrder'];
    status = json['status'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    platform = json['platform'];
    extInfo = json['extInfo'];
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
    data['resourceType'] = this.resourceType;
    data['resourceKey'] = this.resourceKey;
    data['resourceName'] = this.resourceName;
    data['contentType'] = this.contentType;
    data['content'] = this.content;
    data['sortOrder'] = this.sortOrder;
    data['status'] = this.status;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['platform'] = this.platform;
    data['extInfo'] = this.extInfo;
    return data;
  }
}
