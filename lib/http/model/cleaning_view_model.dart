class CleaningViewModel {
  int? id;
  int? cpId;
  String? contacts;
  String? tel;
  int? orderStatus;
  double? cleanPrice;
  String? remark;
  String? clNo;
  String? clArea;
  String? roomNo;
  int? rlaId;
  int? rlId;
  String? createTime;
  String? createBy;
  String? handleTime;
  String? handler;
  String? evaluate;
  int? score;
  String? updateTime;
  String? updateBy;

  CleaningViewModel({
    this.id,
    this.cpId,
    this.contacts,
    this.tel,
    this.orderStatus,
    this.cleanPrice,
    this.remark,
    this.clNo,
    this.clArea,
    this.roomNo,
    this.rlaId,
    this.rlId,
    this.createTime,
    this.createBy,
    this.handleTime,
    this.handler,
    this.evaluate,
    this.score,
    this.updateTime,
    this.updateBy,
  });

  factory CleaningViewModel.fromJson(Map<String, dynamic> json) {
    return CleaningViewModel(
      id: json['id'],
      cpId: json['cpId'],
      contacts: json['contacts'],
      tel: json['tel'],
      orderStatus: json['orderStatus'],
      cleanPrice: json['cleanPrice'],
      remark: json['remark'],
      clNo: json['clNo'],
      clArea: json['clArea'],
      roomNo: json['roomNo'],
      rlaId: json['rlaId'],
      rlId: json['rlId'],
      createTime: json['createTime'],
      createBy: json['createBy'],
      handleTime: json['handleTime'],
      handler: json['handler'],
      evaluate: json['evaluate'],
      score: json['score'],
      updateTime: json['updateTime'],
      updateBy: json['updateBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cpId': cpId,
      'contacts': contacts,
      'tel': tel,
      'orderStatus': orderStatus,
      'cleanPrice': cleanPrice,
      'remark': remark,
      'clNo': clNo,
      'clArea': clArea,
      'roomNo': roomNo,
      'rlaId': rlaId,
      'rlId': rlId,
      'createTime': createTime,
      'createBy': createBy,
      'handleTime': handleTime,
      'handler': handler,
      'evaluate': evaluate,
      'score': score,
      'updateTime': updateTime,
      'updateBy': updateBy,
    };
  }
}

class CleaningTypeModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  int? chargeType;
  String? belongingCompany;
  String? projectDetails;
  String? chargeMethod;
  double? chargePrice;
  String? ancestors;
  int? status;
  String? delFlag;

  CleaningTypeModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.chargeType,
    this.belongingCompany,
    this.projectDetails,
    this.chargeMethod,
    this.chargePrice,
    this.ancestors,
    this.status,
    this.delFlag,
  });

  CleaningTypeModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    chargeType = json['chargeType'];
    belongingCompany = json['belongingCompany'];
    projectDetails = json['projectDetails'];
    chargeMethod = json['chargeMethod'];
    chargePrice = json['chargePrice'];
    ancestors = json['ancestors'];
    status = json['status'];
    delFlag = json['delFlag'];
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
    data['chargeType'] = this.chargeType;
    data['belongingCompany'] = this.belongingCompany;
    data['projectDetails'] = this.projectDetails;
    data['chargeMethod'] = this.chargeMethod;
    data['chargePrice'] = this.chargePrice;
    data['ancestors'] = this.ancestors;
    data['status'] = this.status;
    data['delFlag'] = this.delFlag;
    return data;
  }
}
