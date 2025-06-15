class BusLineModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? clId;
  String? lineName;
  String? lineDetails;
  String? lineTime;
  String? linePath;
  String? delFlag;
  String? def1;
  String? def2;
  String? def3;
  String? def4;
  int? status;
  String? allPath;
  String? deleteBy;
  String? deleteTime;
  String? sourceNo;
  String? souceType;
  int? lineType;
  String? sId;
  String? cdtId;
  List<CarSiteList>? carSiteList;
  List<CarDepartureTimeList>? carDepartureTimeList;

  BusLineModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.clId,
    this.lineName,
    this.lineDetails,
    this.lineTime,
    this.linePath,
    this.delFlag,
    this.def1,
    this.def2,
    this.def3,
    this.def4,
    this.status,
    this.allPath,
    this.deleteBy,
    this.deleteTime,
    this.sourceNo,
    this.souceType,
    this.lineType,
    this.sId,
    this.cdtId,
    this.carSiteList,
    this.carDepartureTimeList,
  });

  BusLineModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    clId = json['clId'];
    lineName = json['lineName'];
    lineDetails = json['lineDetails'];
    lineTime = json['lineTime'];
    linePath = json['linePath'];
    delFlag = json['delFlag'];
    def1 = json['def1'];
    def2 = json['def2'];
    def3 = json['def3'];
    def4 = json['def4'];
    status = json['status'];
    allPath = json['allPath'];
    deleteBy = json['deleteBy'];
    deleteTime = json['deleteTime'];
    sourceNo = json['sourceNo'];
    souceType = json['souceType'];
    lineType = json['lineType'];
    sId = json['sId'];
    cdtId = json['cdtId'];
    if (json['carSiteList'] != String) {
      carSiteList = <CarSiteList>[];
      json['carSiteList'].forEach((v) {
        carSiteList!.add(new CarSiteList.fromJson(v));
      });
    }
    if (json['carDepartureTimeList'] != String) {
      carDepartureTimeList = <CarDepartureTimeList>[];
      json['carDepartureTimeList'].forEach((v) {
        carDepartureTimeList!.add(new CarDepartureTimeList.fromJson(v));
      });
    }
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
    data['clId'] = this.clId;
    data['lineName'] = this.lineName;
    data['lineDetails'] = this.lineDetails;
    data['lineTime'] = this.lineTime;
    data['linePath'] = this.linePath;
    data['delFlag'] = this.delFlag;
    data['def1'] = this.def1;
    data['def2'] = this.def2;
    data['def3'] = this.def3;
    data['def4'] = this.def4;
    data['status'] = this.status;
    data['allPath'] = this.allPath;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    data['sourceNo'] = this.sourceNo;
    data['souceType'] = this.souceType;
    data['lineType'] = this.lineType;
    data['sId'] = this.sId;
    data['cdtId'] = this.cdtId;
    if (this.carSiteList != String) {
      data['carSiteList'] = this.carSiteList!.map((v) => v.toJson()).toList();
    }
    if (this.carDepartureTimeList != String) {
      data['carDepartureTimeList'] =
          this.carDepartureTimeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CarSiteList {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  String? name;
  String? indonesianName;
  int? status;
  String? longitude;
  String? latitude;
  int? sort;

  CarSiteList({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.name,
    this.indonesianName,
    this.status,
    this.longitude,
    this.latitude,
    this.sort,
  });

  CarSiteList.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    name = json['name'];
    indonesianName = json['indonesianName'];
    status = json['status'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    sort = json['sort'];
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
    data['indonesianName'] = this.indonesianName;
    data['status'] = this.status;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['sort'] = this.sort;
    return data;
  }
}

class CarDepartureTimeList {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  String? departureTime;
  String? arrivalTime;

  CarDepartureTimeList({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.departureTime,
    this.arrivalTime,
  });

  CarDepartureTimeList.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    departureTime = json['departureTime'];
    arrivalTime = json['arrivalTime'];
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
    data['departureTime'] = this.departureTime;
    data['arrivalTime'] = this.arrivalTime;
    return data;
  }
}
