class MealDeliverySiteModel {
  // keyword: null, createBy: 1424051717, createTime: 2025-02-10 15:26:37, updateBy: system, updateTime: 2025-06-20 16:00:24, remark: null, deleteTime: null, deleteBy: null, userIdList: null, strArrays: null, statusArrays: null, foodArrays: null, orderArrays: null, fsId: 745, fsAddressCn: 15印尼SENDIRI, fsAddressEn: 15印尼SENDIRI, fsAddressId: 15印尼SENDIRI, fsMessHallId: 11, fsMessHall: 路易印尼食堂/KANTIN LUYI INDO, fcId: 22, fcName: 自取餐, latitude: null, longitude: null, nationType: 1, delFlag: 0, status: 0
  String? keyword;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? deleteTime;
  String? deleteBy;
  String? userIdList;
  String? strArrays;
  String? statusArrays;
  String? foodArrays;
  String? orderArrays;
  int? fsId;
  String? fsAddressCn;
  String? fsAddressEn;
  String? fsAddressId;
  int? fsMessHallId;
  String? fsMessHall;
  int? fcId;
  String? fcName;
  String? latitude;
  String? longitude;
  String? nationType;
  String? delFlag;
  String? status;

  MealDeliverySiteModel({
    this.keyword,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.deleteTime,
    this.deleteBy,
    this.userIdList,
    this.strArrays,
    this.statusArrays,
    this.foodArrays,
    this.orderArrays,
    this.fsId,
    this.fsAddressCn,
    this.fsAddressEn,
    this.fsAddressId,
    this.fsMessHallId,
    this.fsMessHall,
    this.fcId,
    this.fcName,
    this.latitude,
    this.longitude,
    this.nationType,
    this.delFlag,
    this.status,
  });

  factory MealDeliverySiteModel.fromJson(Map<String, dynamic> json) {
    return MealDeliverySiteModel(
      keyword: json['keyword'],
      createBy: json['createBy'],
      createTime: json['createTime'],
      updateBy: json['updateBy'],
      updateTime: json['updateTime'],
      remark: json['remark'],
      deleteTime: json['deleteTime'],
      deleteBy: json['deleteBy'],
      userIdList: json['userIdList'],
      strArrays: json['strArrays'],
      statusArrays: json['statusArrays'],
      foodArrays: json['foodArrays'],
      orderArrays: json['orderArrays'],
      fsId: json['fsId'],
      fsAddressCn: json['fsAddressCn'],
      fsAddressEn: json['fsAddressEn'],
      fsAddressId: json['fsAddressId'],
      fsMessHallId: json['fsMessHallId'],
      fsMessHall: json['fsMessHall'],
      fcId: json['fcId'],
      fcName: json['fcName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      nationType: json['nationType'],
      delFlag: json['delFlag'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
      'createBy': createBy,
      'createTime': createTime,
      'updateBy': updateBy,
      'updateTime': updateTime,
      'remark': remark,
      'deleteTime': deleteTime,
      'deleteBy': deleteBy,
      'userIdList': userIdList,
      'strArrays': strArrays,
      'statusArrays': statusArrays,
      'foodArrays': foodArrays,
      'orderArrays': orderArrays,
      'fsId': fsId,
      'fsAddressCn': fsAddressCn,
      'fsAddressEn': fsAddressEn,
      'fsAddressId': fsAddressId,
      'fsMessHallId': fsMessHallId,
      'fsMessHall': fsMessHall,
      'fcId': fcId,
      'fcName': fcName,
      'latitude': latitude,
      'longitude': longitude,
      'nationType': nationType,
      'delFlag': delFlag,
      'status': status,
    };
  }
}

class MealDeliveryTimeModel {
  int? id;
  String? name;
  String? value;
  bool? disabled;

  MealDeliveryTimeModel({this.id, this.name, this.value, this.disabled});

  factory MealDeliveryTimeModel.fromJson(Map<String, dynamic> json) {
    return MealDeliveryTimeModel(
      id: json['id'],
      name: json['name'],
      value: json['value'],
      disabled: json['disabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'value': value, 'disabled': disabled};
  }
}

class MealDeliveryPersonModel {
  String? keyword;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? deleteTime;
  String? deleteBy;
  String? userIdList;
  String? strArrays;
  String? statusArrays;
  String? foodArrays;
  String? orderArrays;
  int? id;
  String? jobNumber;
  String? username;
  int? companyId;
  String? companyName;
  String? deptId;
  int? postId;
  String? postName;
  String? deptName;
  String? deptPath;
  String? phone;
  String? status;
  String? sex;
  String? delFlag;
  String? nationType;
  String? creator;
  String? religion;

  MealDeliveryPersonModel({
    this.keyword,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.deleteTime,
    this.deleteBy,
    this.userIdList,
    this.strArrays,
    this.statusArrays,
    this.foodArrays,
    this.orderArrays,
    this.id,
    this.jobNumber,
    this.username,
    this.companyId,
    this.companyName,
    this.deptId,
    this.postId,
    this.postName,
    this.deptName,
    this.deptPath,
    this.phone,
    this.status,
    this.sex,
    this.delFlag,
    this.nationType,
    this.creator,
    this.religion,
  });

  MealDeliveryPersonModel.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    deleteTime = json['deleteTime'];
    deleteBy = json['deleteBy'];
    userIdList = json['userIdList'];
    strArrays = json['strArrays'];
    statusArrays = json['statusArrays'];
    foodArrays = json['foodArrays'];
    orderArrays = json['orderArrays'];
    id = json['id'];
    jobNumber = json['jobNumber'];
    username = json['username'];
    companyId = json['companyId'];
    companyName = json['companyName'];
    deptId = json['deptId'];
    postId = json['postId'];
    postName = json['postName'];
    deptName = json['deptName'];
    deptPath = json['deptPath'];
    phone = json['phone'];
    status = json['status'];
    sex = json['sex'];
    delFlag = json['delFlag'];
    nationType = json['nationType'];
    creator = json['creator'];
    religion = json['religion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keyword'] = this.keyword;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['deleteTime'] = this.deleteTime;
    data['deleteBy'] = this.deleteBy;
    data['userIdList'] = this.userIdList;
    data['strArrays'] = this.strArrays;
    data['statusArrays'] = this.statusArrays;
    data['foodArrays'] = this.foodArrays;
    data['orderArrays'] = this.orderArrays;
    data['id'] = this.id;
    data['jobNumber'] = this.jobNumber;
    data['username'] = this.username;
    data['companyId'] = this.companyId;
    data['companyName'] = this.companyName;
    data['deptId'] = this.deptId;
    data['postId'] = this.postId;
    data['postName'] = this.postName;
    data['deptName'] = this.deptName;
    data['deptPath'] = this.deptPath;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['sex'] = this.sex;
    data['delFlag'] = this.delFlag;
    data['nationType'] = this.nationType;
    data['creator'] = this.creator;
    data['religion'] = this.religion;
    return data;
  }
}

class MealDeliveryTimeListModel {
  String? keyword;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? deleteTime;
  String? deleteBy;
  String? userIdList;
  String? strArrays;
  String? statusArrays;
  String? foodArrays;
  String? orderArrays;
  int? tId;
  String? tType;
  String? beginTime;
  String? endTime;
  String? deptBeginTime;
  String? deptEndTime;

  MealDeliveryTimeListModel({
    this.keyword,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.deleteTime,
    this.deleteBy,
    this.userIdList,
    this.strArrays,
    this.statusArrays,
    this.foodArrays,
    this.orderArrays,
    this.tId,
    this.tType,
    this.beginTime,
    this.endTime,
    this.deptBeginTime,
    this.deptEndTime,
  });

  MealDeliveryTimeListModel.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    deleteTime = json['deleteTime'];
    deleteBy = json['deleteBy'];
    userIdList = json['userIdList'];
    strArrays = json['strArrays'];
    statusArrays = json['statusArrays'];
    foodArrays = json['foodArrays'];
    orderArrays = json['orderArrays'];
    tId = json['tId'];
    tType = json['tType'];
    beginTime = json['beginTime'];
    endTime = json['endTime'];
    deptBeginTime = json['deptBeginTime'];
    deptEndTime = json['deptEndTime'];
  }

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
      'createBy': createBy,
      'createTime': createTime,
      'updateBy': updateBy,
      'updateTime': updateTime,
      'remark': remark,
      'deleteTime': deleteTime,
      'deleteBy': deleteBy,
      'userIdList': userIdList,
      'strArrays': strArrays,
      'statusArrays': statusArrays,
      'foodArrays': foodArrays,
      'orderArrays': orderArrays,
      'tId': tId,
      'tType': tType,
      'beginTime': beginTime,
      'endTime': endTime,
      'deptBeginTime': deptBeginTime,
      'deptEndTime': deptEndTime,
    };
  }
}

class MealDeliveryOrderModel {
  String? keyword;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? deleteTime;
  String? deleteBy;
  String? userIdList;
  String? strArrays;
  String? statusArrays;
  String? foodArrays;
  String? orderArrays;
  int? oId;
  String? orderStatus;
  int? deliveryId;
  String? deliverySite;
  String? remarks;
  String? orderNo;
  String? foodName;
  String? foodType;
  int? fdId;
  String? canteen;
  int? fcId;
  String? fcName;
  String? imageUrl;
  String? leaderStatus;
  String? delFlag;
  String? centerStatus;
  String? deliveryType;
  String? packageType;
  int? pNum;
  int? userId;
  int? deptId;
  String? reason;
  String? centerBy;
  String? sourceId;
  String? sourceType;
  String? userUame;
  String? phone;
  String? sourceNo;
  String? deptName;
  String? auditTime;
  String? rejectTime;
  String? printed;
  String? canteenPrinted;
  String? orderTime;
  String? leadTime;
  String? packTime;
  String? mealTime;
  String? completeTime;
  String? teamSubmitTime;
  String? deptSubmitTime;
  List<OrderPerson>? children;
  String? jobNumber;
  String? specifiedCompanyId;
  String? specifiedCompanyName;
  String? orderType;
  String? firstLevelDeptName;
  String? orderDate;
  List<FoodOrdersDetil>? foodOrdersDetil;

  MealDeliveryOrderModel({
    this.keyword,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.deleteTime,
    this.deleteBy,
    this.userIdList,
    this.strArrays,
    this.statusArrays,
    this.foodArrays,
    this.orderArrays,
    this.oId,
    this.orderStatus,
    this.deliveryId,
    this.deliverySite,
    this.remarks,
    this.orderNo,
    this.foodName,
    this.foodType,
    this.fdId,
    this.canteen,
    this.fcId,
    this.fcName,
    this.imageUrl,
    this.leaderStatus,
    this.delFlag,
    this.centerStatus,
    this.deliveryType,
    this.packageType,
    this.pNum,
    this.userId,
    this.deptId,
    this.reason,
    this.centerBy,
    this.sourceId,
    this.sourceType,
    this.userUame,
    this.phone,
    this.sourceNo,
    this.deptName,
    this.auditTime,
    this.rejectTime,
    this.printed,
    this.canteenPrinted,
    this.orderTime,
    this.leadTime,
    this.packTime,
    this.mealTime,
    this.completeTime,
    this.teamSubmitTime,
    this.deptSubmitTime,
    this.children,
    this.jobNumber,
    this.specifiedCompanyId,
    this.specifiedCompanyName,
    this.orderType,
    this.firstLevelDeptName,
    this.orderDate,
    this.foodOrdersDetil,
  });

  MealDeliveryOrderModel.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    deleteTime = json['deleteTime'];
    deleteBy = json['deleteBy'];
    userIdList = json['userIdList'];
    strArrays = json['strArrays'];
    statusArrays = json['statusArrays'];
    foodArrays = json['foodArrays'];
    orderArrays = json['orderArrays'];
    oId = json['oId'];
    orderStatus = json['orderStatus'];
    deliveryId = json['deliveryId'];
    deliverySite = json['deliverySite'];
    remarks = json['remarks'];
    orderNo = json['orderNo'];
    foodName = json['foodName'];
    foodType = json['foodType'];
    fdId = json['fdId'];
    canteen = json['canteen'];
    fcId = json['fcId'];
    fcName = json['fcName'];
    imageUrl = json['imageUrl'];
    leaderStatus = json['leaderStatus'];
    delFlag = json['delFlag'];
    centerStatus = json['centerStatus'];
    deliveryType = json['deliveryType'];
    packageType = json['packageType'];
    pNum = json['pNum'];
    userId = json['userId'];
    deptId = json['deptId'];
    reason = json['reason'];
    centerBy = json['centerBy'];
    sourceId = json['sourceId'];
    sourceType = json['sourceType'];
    userUame = json['userUame'];
    phone = json['phone'];
    sourceNo = json['sourceNo'];
    deptName = json['deptName'];
    auditTime = json['auditTime'];
    rejectTime = json['rejectTime'];
    printed = json['printed'];
    canteenPrinted = json['canteenPrinted'];
    orderTime = json['orderTime'];
    leadTime = json['leadTime'];
    packTime = json['packTime'];
    mealTime = json['mealTime'];
    completeTime = json['completeTime'];
    teamSubmitTime = json['teamSubmitTime'];
    deptSubmitTime = json['deptSubmitTime'];
    jobNumber = json['jobNumber'];
    specifiedCompanyId = json['specifiedCompanyId'];
    specifiedCompanyName = json['specifiedCompanyName'];
    orderType = json['orderType'];
    firstLevelDeptName = json['firstLevelDeptName'];
    orderDate = json['orderDate'];
    if (json['foodOrdersDetil'] != null) {
      foodOrdersDetil = <FoodOrdersDetil>[];
      json['foodOrdersDetil'].forEach((v) {
        foodOrdersDetil!.add(new FoodOrdersDetil.fromJson(v));
      });
    }
    if (json['children'] != null) {
      children = <OrderPerson>[];
      json['children'].forEach((v) {
        children!.add(new OrderPerson.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keyword'] = this.keyword;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['deleteTime'] = this.deleteTime;
    data['deleteBy'] = this.deleteBy;
    data['userIdList'] = this.userIdList;
    data['strArrays'] = this.strArrays;
    data['statusArrays'] = this.statusArrays;
    data['foodArrays'] = this.foodArrays;
    data['orderArrays'] = this.orderArrays;
    data['oId'] = this.oId;
    data['orderStatus'] = this.orderStatus;
    data['deliveryId'] = this.deliveryId;
    data['deliverySite'] = this.deliverySite;
    data['remarks'] = this.remarks;
    data['orderNo'] = this.orderNo;
    data['foodName'] = this.foodName;
    data['foodType'] = this.foodType;
    data['fdId'] = this.fdId;
    data['canteen'] = this.canteen;
    data['fcId'] = this.fcId;
    data['fcName'] = this.fcName;
    data['imageUrl'] = this.imageUrl;
    data['leaderStatus'] = this.leaderStatus;
    data['delFlag'] = this.delFlag;
    data['centerStatus'] = this.centerStatus;
    data['deliveryType'] = this.deliveryType;
    data['packageType'] = this.packageType;
    data['pNum'] = this.pNum;
    data['userId'] = this.userId;
    data['deptId'] = this.deptId;
    data['reason'] = this.reason;
    data['centerBy'] = this.centerBy;
    data['sourceId'] = this.sourceId;
    data['sourceType'] = this.sourceType;
    data['userUame'] = this.userUame;
    data['phone'] = this.phone;
    data['sourceNo'] = this.sourceNo;
    data['deptName'] = this.deptName;
    data['auditTime'] = this.auditTime;
    data['rejectTime'] = this.rejectTime;
    data['printed'] = this.printed;
    data['canteenPrinted'] = this.canteenPrinted;
    data['orderTime'] = this.orderTime;
    data['leadTime'] = this.leadTime;
    data['packTime'] = this.packTime;
    data['mealTime'] = this.mealTime;
    data['completeTime'] = this.completeTime;
    data['teamSubmitTime'] = this.teamSubmitTime;
    data['deptSubmitTime'] = this.deptSubmitTime;
    data['children'] = this.children;
    data['jobNumber'] = this.jobNumber;
    data['specifiedCompanyId'] = this.specifiedCompanyId;
    data['specifiedCompanyName'] = this.specifiedCompanyName;
    data['orderType'] = this.orderType;
    data['firstLevelDeptName'] = this.firstLevelDeptName;
    data['orderDate'] = this.orderDate;
    if (this.foodOrdersDetil != null) {
      data['foodOrdersDetil'] =
          this.foodOrdersDetil!.map((v) => v.toJson()).toList();
    }
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodOrdersDetil {
  String? keyword;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? deleteTime;
  String? deleteBy;
  String? userIdList;
  String? strArrays;
  String? statusArrays;
  String? foodArrays;
  String? orderArrays;
  int? odId;
  int? oId;
  String? userName;
  String? userNo;
  String? remarks;
  String? userId;
  String? deptId;
  String? def3;
  String? def4;
  String? def5;
  String? postId;
  String? companyId;
  String? postName;
  String? nationType;
  String? companyName;
  String? deptName;
  String? delFlag;
  String? firstLevelDeptName;

  FoodOrdersDetil({
    this.keyword,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.deleteTime,
    this.deleteBy,
    this.userIdList,
    this.strArrays,
    this.statusArrays,
    this.foodArrays,
    this.orderArrays,
    this.odId,
    this.oId,
    this.userName,
    this.userNo,
    this.remarks,
    this.userId,
    this.deptId,
    this.def3,
    this.def4,
    this.def5,
    this.postId,
    this.companyId,
    this.postName,
    this.nationType,
    this.companyName,
    this.deptName,
    this.delFlag,
    this.firstLevelDeptName,
  });

  FoodOrdersDetil.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    deleteTime = json['deleteTime'];
    deleteBy = json['deleteBy'];
    userIdList = json['userIdList'];
    strArrays = json['strArrays'];
    statusArrays = json['statusArrays'];
    foodArrays = json['foodArrays'];
    orderArrays = json['orderArrays'];
    odId = json['odId'];
    oId = json['oId'];
    userName = json['userName'];
    userNo = json['userNo'];
    remarks = json['remarks'];
    userId = json['userId'];
    deptId = json['deptId'];
    def3 = json['def3'];
    def4 = json['def4'];
    def5 = json['def5'];
    postId = json['postId'];
    companyId = json['companyId'];
    postName = json['postName'];
    nationType = json['nationType'];
    companyName = json['companyName'];
    deptName = json['deptName'];
    delFlag = json['delFlag'];
    firstLevelDeptName = json['firstLevelDeptName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keyword'] = this.keyword;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['deleteTime'] = this.deleteTime;
    data['deleteBy'] = this.deleteBy;
    data['userIdList'] = this.userIdList;
    data['strArrays'] = this.strArrays;
    data['statusArrays'] = this.statusArrays;
    data['foodArrays'] = this.foodArrays;
    data['orderArrays'] = this.orderArrays;
    data['odId'] = this.odId;
    data['oId'] = this.oId;
    data['userName'] = this.userName;
    data['userNo'] = this.userNo;
    data['remarks'] = this.remarks;
    data['userId'] = this.userId;
    data['deptId'] = this.deptId;
    data['def3'] = this.def3;
    data['def4'] = this.def4;
    data['def5'] = this.def5;
    data['postId'] = this.postId;
    data['companyId'] = this.companyId;
    data['postName'] = this.postName;
    data['nationType'] = this.nationType;
    data['companyName'] = this.companyName;
    data['deptName'] = this.deptName;
    data['delFlag'] = this.delFlag;
    data['firstLevelDeptName'] = this.firstLevelDeptName;
    return data;
  }
}

class OrderPerson {
  String? keyword;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? deleteTime;
  String? deleteBy;
  String? userIdList;
  String? strArrays;
  String? statusArrays;
  String? foodArrays;
  String? orderArrays;
  int? odId;
  int? oId;
  String? userName;
  String? userNo;
  String? remarks;
  String? userId;
  String? deptId;
  String? def3;
  String? def4;
  String? def5;
  String? postId;
  String? companyId;
  String? postName;
  String? nationType;
  String? companyName;
  String? deptName;
  String? delFlag;
  String? firstLevelDeptName;

  OrderPerson({
    this.keyword,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.deleteTime,
    this.deleteBy,
    this.userIdList,
    this.strArrays,
    this.statusArrays,
    this.foodArrays,
    this.orderArrays,
    this.odId,
    this.oId,
    this.userName,
    this.userNo,
    this.remarks,
    this.userId,
    this.deptId,
    this.def3,
    this.def4,
    this.def5,
    this.postId,
    this.companyId,
    this.postName,
    this.nationType,
    this.companyName,
    this.deptName,
    this.delFlag,
    this.firstLevelDeptName,
  });

  OrderPerson.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    deleteTime = json['deleteTime'];
    deleteBy = json['deleteBy'];
    userIdList = json['userIdList'];
    strArrays = json['strArrays'];
    statusArrays = json['statusArrays'];
    foodArrays = json['foodArrays'];
    orderArrays = json['orderArrays'];
    odId = json['odId'];
    oId = json['oId'];
    userName = json['userName'];
    userNo = json['userNo'];
    remarks = json['remarks'];
    userId = json['userId'];
    deptId = json['deptId'];
    def3 = json['def3'];
    def4 = json['def4'];
    def5 = json['def5'];
    postId = json['postId'];
    companyId = json['companyId'];
    postName = json['postName'];
    nationType = json['nationType'];
    companyName = json['companyName'];
    deptName = json['deptName'];
    delFlag = json['delFlag'];
    firstLevelDeptName = json['firstLevelDeptName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keyword'] = this.keyword;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['deleteTime'] = this.deleteTime;
    data['deleteBy'] = this.deleteBy;
    data['userIdList'] = this.userIdList;
    data['strArrays'] = this.strArrays;
    data['statusArrays'] = this.statusArrays;
    data['foodArrays'] = this.foodArrays;
    data['orderArrays'] = this.orderArrays;
    data['odId'] = this.odId;
    data['oId'] = this.oId;
    data['userName'] = this.userName;
    data['userNo'] = this.userNo;
    data['remarks'] = this.remarks;
    data['userId'] = this.userId;
    data['deptId'] = this.deptId;
    data['def3'] = this.def3;
    data['def4'] = this.def4;
    data['def5'] = this.def5;
    data['postId'] = this.postId;
    data['companyId'] = this.companyId;
    data['postName'] = this.postName;
    data['nationType'] = this.nationType;
    data['companyName'] = this.companyName;
    data['deptName'] = this.deptName;
    data['delFlag'] = this.delFlag;
    data['firstLevelDeptName'] = this.firstLevelDeptName;
    return data;
  }
}
