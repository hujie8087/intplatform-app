class UserInfoModel {
  List<String>? permissions;
  List<String>? roles;
  User? user;
  MealUser? mealUser;

  UserInfoModel({this.permissions, this.roles, this.user, this.mealUser});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    permissions = json['permissions'].cast<String>();
    roles = json['roles'].cast<String>();
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    mealUser =
        json['mealUser'] != null
            ? new MealUser.fromJson(json['mealUser'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['permissions'] = this.permissions;
    data['roles'] = this.roles;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.mealUser != null) {
      data['mealUser'] = this.mealUser!.toJson();
    }
    return data;
  }
}

class MealUser {
  int? userId;
  String? username;
  List<String>? permissions;
  List<String>? roles;
  User? sysUser;

  MealUser({
    required this.userId,
    required this.username,
    required this.permissions,
    required this.roles,
    required this.sysUser,
  });

  MealUser.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    permissions = json['permissions'].cast<String>();
    roles = json['roles'].cast<String>();
    sysUser = User.fromJson(json['sysUser']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['permissions'] = this.permissions;
    data['roles'] = this.roles;
    if (this.sysUser != null) {
      data['sysUser'] = this.sysUser!.toJson();
    }
    return data;
  }
}

class User {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? userId;
  int? deptId;
  String? canteenId;
  String? userName;
  String? mobilePhoneId;
  String? nickName;
  String? userType;
  String? email;
  String? phonenumber;
  String? sex;
  String? avatar;
  String? password;
  String? status;
  String? delFlag;
  String? loginIp;
  String? loginDate;
  Dept? dept;
  List<Roles>? roles;
  String? roleIds;
  String? postIds;
  String? roleId;
  String? card;
  String? money;
  bool? vip;
  bool? admin;
  int? isLogin;
  String? facePhoto;

  User({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.userId,
    this.deptId,
    this.canteenId,
    this.userName,
    this.mobilePhoneId,
    this.nickName,
    this.userType,
    this.email,
    this.phonenumber,
    this.sex,
    this.avatar,
    this.password,
    this.status,
    this.delFlag,
    this.loginIp,
    this.loginDate,
    this.dept,
    this.roles,
    this.roleIds,
    this.postIds,
    this.roleId,
    this.card,
    this.money,
    this.vip,
    this.admin,
    this.isLogin,
    this.facePhoto,
  });

  User.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    userId = json['userId'];
    deptId = json['deptId'];
    canteenId = json['canteenId'];
    userName = json['userName'];
    mobilePhoneId = json['mobilePhoneId'];
    nickName = json['nickName'];
    userType = json['userType'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    sex = json['sex'];
    avatar = json['avatar'];
    password = json['password'];
    status = json['status'];
    delFlag = json['delFlag'];
    loginIp = json['loginIp'];
    loginDate = json['loginDate'];
    dept = json['dept'] != null ? new Dept.fromJson(json['dept']) : null;
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
    roleIds = json['roleIds'];
    postIds = json['postIds'];
    roleId = json['roleId'];
    card = json['card'];
    money = json['money'];
    vip = json['vip'];
    admin = json['admin'];
    isLogin = json['isLogin'];
    facePhoto = json['facePhoto'];
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
    data['userId'] = this.userId;
    data['deptId'] = this.deptId;
    data['canteenId'] = this.canteenId;
    data['userName'] = this.userName;
    data['mobilePhoneId'] = this.mobilePhoneId;
    data['nickName'] = this.nickName;
    data['userType'] = this.userType;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    data['sex'] = this.sex;
    data['avatar'] = this.avatar;
    data['password'] = this.password;
    data['status'] = this.status;
    data['delFlag'] = this.delFlag;
    data['loginIp'] = this.loginIp;
    data['loginDate'] = this.loginDate;
    if (this.dept != null) {
      data['dept'] = this.dept!.toJson();
    }
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    data['roleIds'] = this.roleIds;
    data['postIds'] = this.postIds;
    data['roleId'] = this.roleId;
    data['card'] = this.card;
    data['money'] = this.money;
    data['vip'] = this.vip;
    data['admin'] = this.admin;
    data['isLogin'] = this.isLogin;
    data['facePhoto'] = this.facePhoto;
    return data;
  }
}

class Dept {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? deptId;
  int? parentId;
  String? ancestors;
  String? deptName;
  int? orderNum;
  String? leader;
  String? phone;
  String? email;
  String? status;
  String? delFlag;
  String? parentName;
  String? originDeptId;
  String? companyidOA;
  String? deptType;

  Dept({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.deptId,
    this.parentId,
    this.ancestors,
    this.deptName,
    this.orderNum,
    this.leader,
    this.phone,
    this.email,
    this.status,
    this.delFlag,
    this.parentName,
    this.originDeptId,
    this.companyidOA,
    this.deptType,
  });

  Dept.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    deptId = json['deptId'];
    parentId = json['parentId'];
    ancestors = json['ancestors'];
    deptName = json['deptName'];
    orderNum = json['orderNum'];
    leader = json['leader'];
    phone = json['phone'];
    email = json['email'];
    status = json['status'];
    delFlag = json['delFlag'];
    parentName = json['parentName'];
    originDeptId = json['originDeptId'];
    companyidOA = json['companyidOA'];
    deptType = json['deptType'];
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
    data['deptId'] = this.deptId;
    data['parentId'] = this.parentId;
    data['ancestors'] = this.ancestors;
    data['deptName'] = this.deptName;
    data['orderNum'] = this.orderNum;
    data['leader'] = this.leader;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['status'] = this.status;
    data['delFlag'] = this.delFlag;
    data['parentName'] = this.parentName;
    data['originDeptId'] = this.originDeptId;
    data['companyidOA'] = this.companyidOA;
    data['deptType'] = this.deptType;
    return data;
  }
}

class Roles {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? roleId;
  String? roleName;
  String? roleKey;
  int? roleSort;
  String? repairAreaId;
  String? dataScope;
  bool? menuCheckStrictly;
  bool? deptCheckStrictly;
  String? status;
  String? delFlag;
  bool? flag;
  String? menuIds;
  String? deptIds;
  List<String>? permissions;
  bool? admin;

  Roles({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.roleId,
    this.roleName,
    this.roleKey,
    this.roleSort,
    this.repairAreaId,
    this.dataScope,
    this.menuCheckStrictly,
    this.deptCheckStrictly,
    this.status,
    this.delFlag,
    this.flag,
    this.menuIds,
    this.deptIds,
    this.permissions,
    this.admin,
  });

  Roles.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    roleId = json['roleId'];
    roleName = json['roleName'];
    roleKey = json['roleKey'];
    roleSort = json['roleSort'];
    repairAreaId = json['repairAreaId'];
    dataScope = json['dataScope'];
    menuCheckStrictly = json['menuCheckStrictly'];
    deptCheckStrictly = json['deptCheckStrictly'];
    status = json['status'];
    delFlag = json['delFlag'];
    flag = json['flag'];
    menuIds = json['menuIds'];
    deptIds = json['deptIds'];
    permissions = (json['permissions'] as List?)?.cast<String>() ?? [];
    admin = json['admin'];
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
    data['roleId'] = this.roleId;
    data['roleName'] = this.roleName;
    data['roleKey'] = this.roleKey;
    data['roleSort'] = this.roleSort;
    data['repairAreaId'] = this.repairAreaId;
    data['dataScope'] = this.dataScope;
    data['menuCheckStrictly'] = this.menuCheckStrictly;
    data['deptCheckStrictly'] = this.deptCheckStrictly;
    data['status'] = this.status;
    data['delFlag'] = this.delFlag;
    data['flag'] = this.flag;
    data['menuIds'] = this.menuIds;
    data['deptIds'] = this.deptIds;
    data['permissions'] = this.permissions;
    data['admin'] = this.admin;
    return data;
  }
}

class ThirdUserInfoModel {
  int? id;
  String? account;
  String? avatar;
  String? name;
  int? sex;
  String? tel;
  String? postName;
  String? formatOrganizeName;

  ThirdUserInfoModel({
    this.id,
    this.account,
    this.avatar,
    this.name,
    this.sex,
    this.tel,
    this.postName,
    this.formatOrganizeName,
  });

  ThirdUserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    account = json['account'];
    avatar = json['avatar'];
    name = json['name'];
    sex = json['sex'];
    tel = json['tel'];
    postName = json['postName'];
    formatOrganizeName = json['formatOrganizeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['account'] = this.account;
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['sex'] = this.sex;
    data['tel'] = this.tel;
    data['postName'] = this.postName;
    data['formatOrganizeName'] = this.formatOrganizeName;
    return data;
  }
}
