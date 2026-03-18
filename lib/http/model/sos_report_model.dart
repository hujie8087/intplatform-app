class SosReportModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  String? orderNo;
  int? level;
  String? reportLocation;
  String? reportDescription;
  String? reportBy;
  String? tel;
  String? reportTime;
  String? reportImage;
  String? processingBy;
  String? processingResult;
  String? processingTime;
  double? longitude;
  double? latitude;
  String? delFlag;
  int? systemSource;
  int? status;
  String? deviceType;

  SosReportModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.orderNo,
    this.level,
    this.reportLocation,
    this.reportDescription,
    this.reportBy,
    this.tel,
    this.reportTime,
    this.reportImage,
    this.processingBy,
    this.processingResult,
    this.processingTime,
    this.longitude,
    this.latitude,
    this.delFlag,
    this.systemSource,
    this.status,
    this.deviceType,
  });

  SosReportModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    orderNo = json['orderNo'];
    level = json['level'];
    reportLocation = json['reportLocation'];
    reportDescription = json['reportDescription'];
    reportBy = json['reportBy'];
    tel = json['tel'];
    reportTime = json['reportTime'];
    reportImage = json['reportImage'];
    processingBy = json['processingBy'];
    processingResult = json['processingResult'];
    processingTime = json['processingTime'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    delFlag = json['delFlag'];
    systemSource = json['systemSource'];
    status = json['status'];
    deviceType = json['deviceType'];
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
    data['orderNo'] = this.orderNo;
    data['level'] = this.level;
    data['reportLocation'] = this.reportLocation;
    data['reportDescription'] = this.reportDescription;
    data['reportBy'] = this.reportBy;
    data['tel'] = this.tel;
    data['reportTime'] = this.reportTime;
    data['reportImage'] = this.reportImage;
    data['processingBy'] = this.processingBy;
    data['processingResult'] = this.processingResult;
    data['processingTime'] = this.processingTime;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['delFlag'] = this.delFlag;
    data['systemSource'] = this.systemSource;
    data['status'] = this.status;
    data['deviceType'] = this.deviceType;
    return data;
  }
}
