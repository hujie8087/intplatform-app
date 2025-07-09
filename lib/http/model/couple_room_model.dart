class CoupleRoomModel {
  String? createTime;
  String? updateTime;
  int? createById;
  int? status;
  String? remark;
  int? id;
  String? name;
  String? lastTime;
  bool? isSubmit;
  String? rollTime;
  int? areaType;

  CoupleRoomModel({
    this.createTime,
    this.updateTime,
    this.createById,
    this.status,
    this.remark,
    this.id,
    this.name,
    this.lastTime,
    this.isSubmit,
    this.rollTime,
    this.areaType,
  });

  CoupleRoomModel.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    createById = json['createById'];
    status = json['status'];
    remark = json['remark'];
    id = json['id'];
    name = json['name'];
    lastTime = json['lastTime'];
    isSubmit = json['isSubmit'];
    rollTime = json['rollTime'];
    areaType = json['areaType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['createById'] = this.createById;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['id'] = this.id;
    data['name'] = this.name;
    data['lastTime'] = this.lastTime;
    data['isSubmit'] = this.isSubmit;
    data['rollTime'] = this.rollTime;
    data['areaType'] = this.areaType;
    return data;
  }
}

class CoupleOrder {
  String? createTime;
  String? updateTime;
  int? createById;
  int? status;
  String? remark;
  int? id;
  String? no;
  String? startTime;
  String? chamberName;
  String? name;
  String? nick;
  int? day;
  String? endTime;
  int? price;
  bool? freeze;
  List<CoupleStaffListModel>? staffList;
  List<CoupleAuditListModel>? auditList;
  int? keychain;
  int? deleted;
  String? confirmTime;

  CoupleOrder({
    this.createTime,
    this.updateTime,
    this.createById,
    this.status,
    this.remark,
    this.id,
    this.no,
    this.startTime,
    this.chamberName,
    this.name,
    this.nick,
    this.day,
    this.endTime,
    this.price,
    this.freeze,
    this.staffList,
    this.auditList,
    this.keychain,
    this.deleted,
    this.confirmTime,
  });

  CoupleOrder.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    createById = json['createById'];
    status = json['status'];
    remark = json['remark'];
    id = json['id'];
    no = json['no'];
    startTime = json['startTime'];
    chamberName = json['chamberName'];
    name = json['name'];
    nick = json['nick'];
    day = json['day'];
    endTime = json['endTime'];
    price = json['price'];
    freeze = json['freeze'];
    staffList = json['staffList'];
    auditList = json['auditList'];
    keychain = json['keychain'];
    deleted = json['deleted'];
    confirmTime = json['confirmTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['createById'] = this.createById;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['id'] = this.id;
    data['no'] = this.no;
    data['startTime'] = this.startTime;
    data['chamberName'] = this.chamberName;
    data['name'] = this.name;
    data['nick'] = this.nick;
    data['day'] = this.day;
    data['endTime'] = this.endTime;
    data['price'] = this.price;
    data['freeze'] = this.freeze;
    data['staffList'] = this.staffList;
    data['auditList'] = this.auditList;
    data['keychain'] = this.keychain;
    data['deleted'] = this.deleted;
    data['confirmTime'] = this.confirmTime;
    return data;
  }
}

class CoupleOrderModel {
  String? createTime;
  String? updateTime;
  int? createById;
  int? status;
  String? remark;
  int? id;
  String? no;
  String? startTime;
  String? chamberName;
  String? name;
  String? nick;
  int? day;
  String? endTime;
  int? price;
  List<CoupleStaffListModel>? staffList;
  List<CoupleAuditListModel>? auditList;
  bool? freeze;
  String? confirmTime;

  CoupleOrderModel({
    this.createTime,
    this.updateTime,
    this.createById,
    this.status,
    this.remark,
    this.id,
    this.no,
    this.startTime,
    this.chamberName,
    this.name,
    this.nick,
    this.day,
    this.endTime,
    this.price,
    this.staffList,
    this.auditList,
    this.freeze,
    this.confirmTime,
  });

  CoupleOrderModel.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    createById = json['createById'];
    status = json['status'];
    remark = json['remark'];
    id = json['id'];
    no = json['no'];
    startTime = json['startTime'];
    chamberName = json['chamberName'];
    name = json['name'];
    nick = json['nick'];
    day = json['day'];
    endTime = json['endTime'];
    price = json['price'];
    if (json['staffList'] != null) {
      staffList = <CoupleStaffListModel>[];
      json['staffList'].forEach((v) {
        staffList!.add(CoupleStaffListModel.fromJson(v));
      });
    }
    if (json['auditList'] != null) {
      auditList = <CoupleAuditListModel>[];
      json['auditList'].forEach((v) {
        auditList!.add(CoupleAuditListModel.fromJson(v));
      });
    }
    freeze = json['freeze'];
    confirmTime = json['confirmTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['createById'] = this.createById;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['id'] = this.id;
    data['no'] = this.no;
    data['startTime'] = this.startTime;
    data['chamberName'] = this.chamberName;
    data['name'] = this.name;
    data['nick'] = this.nick;
    data['day'] = this.day;
    data['endTime'] = this.endTime;
    data['price'] = this.price;
    if (this.staffList != null) {
      data['staffList'] = this.staffList!.map((v) => v.toJson()).toList();
    }
    if (this.auditList != null) {
      data['auditList'] = this.auditList!.map((v) => v.toJson()).toList();
    }
    data['freeze'] = this.freeze;
    data['confirmTime'] = this.confirmTime;
    return data;
  }
}

class CoupleStaffListModel {
  String? createTime;
  String? updateTime;
  int? createById;
  int? status;
  String? remark;
  int? id;
  String? username;
  String? name;
  String? password;
  String? dept;
  String? job;
  String? tel;
  String? entrtyTime;
  String? bind;
  String? sex;
  int? num;

  CoupleStaffListModel({
    this.createTime,
    this.updateTime,
    this.createById,
    this.status,
    this.remark,
    this.id,
    this.username,
    this.name,
    this.password,
    this.dept,
    this.job,
    this.tel,
    this.entrtyTime,
    this.bind,
    this.sex,
    this.num,
  });

  CoupleStaffListModel.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    createById = json['createById'];
    status = json['status'];
    remark = json['remark'];
    id = json['id'];
    username = json['username'];
    name = json['name'];
    password = json['password'];
    dept = json['dept'];
    job = json['job'];
    tel = json['tel'];
    entrtyTime = json['entrtyTime'];
    bind = json['bind'];
    sex = json['sex'];
    num = json['num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['createById'] = this.createById;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    data['password'] = this.password;
    data['dept'] = this.dept;
    data['job'] = this.job;
    data['tel'] = this.tel;
    data['entrtyTime'] = this.entrtyTime;
    data['bind'] = this.bind;
    data['sex'] = this.sex;
    data['num'] = this.num;
    return data;
  }
}

class CoupleAuditListModel {
  int? id;
  int? orderId;
  String? title;
  String? name;
  String? content;
  String? status;
  String? createTime;

  CoupleAuditListModel({
    this.id,
    this.orderId,
    this.title,
    this.name,
    this.content,
    this.status,
    this.createTime,
  });

  CoupleAuditListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    title = json['title'];
    name = json['name'];
    content = json['content'];
    status = json['status'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderId'] = this.orderId;
    data['title'] = this.title;
    data['name'] = this.name;
    data['content'] = this.content;
    data['status'] = this.status;
    data['createTime'] = this.createTime;
    return data;
  }
}
