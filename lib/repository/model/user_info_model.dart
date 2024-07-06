class UserInfoModel {
  UserInfoModel({
    this.permissions,
    this.roles,
    this.user,
  });

  UserInfoModel.fromJson(Map<String, dynamic>? json) {
    permissions = json?['permissions']?.cast<String>();
    roles = json?['roles']?.cast<String>();
    user = json?['user'] != null ? User.fromJson(json?['user']) : null;
  }

  List<String>? permissions;
  List<String>? roles;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['permissions'] = permissions;
    map['roles'] = roles;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}

class User {
  User({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.userId,
    this.deptId,
    this.userName,
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
    this.admin,
  });

  User.fromJson(Map<String, dynamic>? json) {
    createBy = json?['createBy'];
    createTime = json?['createTime'];
    updateBy = json?['updateBy'];
    updateTime = json?['updateTime'];
    remark = json?['remark'];
    userId = json?['userId'];
    deptId = json?['deptId'];
    userName = json?['userName'];
    nickName = json?['nickName'];
    userType = json?['userType'];
    email = json?['email'];
    phonenumber = json?['phonenumber'];
    sex = json?['sex'];
    avatar = json?['avatar'];
    password = json?['password'];
    status = json?['status'];
    delFlag = json?['delFlag'];
    loginIp = json?['loginIp'];
    loginDate = json?['loginDate'];
    dept = json?['dept'] != null ? Dept.fromJson(json?['dept']) : null;
    roles = json?['roles'] != null
        ? List<Role>.from(json?['roles'].map((role) => Role.fromJson(role)))
        : null;
    admin = json?['admin'];
  }

  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  int? userId;
  int? deptId;
  String? userName;
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
  List<Role>? roles;
  bool? admin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createBy'] = createBy;
    map['createTime'] = createTime;
    map['updateBy'] = updateBy;
    map['updateTime'] = updateTime;
    map['remark'] = remark;
    map['userId'] = userId;
    map['deptId'] = deptId;
    map['userName'] = userName;
    map['nickName'] = nickName;
    map['userType'] = userType;
    map['email'] = email;
    map['phonenumber'] = phonenumber;
    map['sex'] = sex;
    map['avatar'] = avatar;
    map['password'] = password;
    map['status'] = status;
    map['delFlag'] = delFlag;
    map['loginIp'] = loginIp;
    map['loginDate'] = loginDate;
    if (dept != null) {
      map['dept'] = dept?.toJson();
    }
    if (roles != null) {
      map['roles'] = roles?.map((role) => role.toJson()).toList();
    }
    map['admin'] = admin;
    return map;
  }
}

class Dept {
  Dept({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
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
    this.children,
  });

  Dept.fromJson(Map<String, dynamic>? json) {
    createBy = json?['createBy'];
    createTime = json?['createTime'];
    updateBy = json?['updateBy'];
    updateTime = json?['updateTime'];
    remark = json?['remark'];
    deptId = json?['deptId'];
    parentId = json?['parentId'];
    ancestors = json?['ancestors'];
    deptName = json?['deptName'];
    orderNum = json?['orderNum'];
    leader = json?['leader'];
    phone = json?['phone'];
    email = json?['email'];
    status = json?['status'];
    delFlag = json?['delFlag'];
    parentName = json?['parentName'];
    children = json?['children'] != null ? List<dynamic>.from(json?['children']) : null;
  }

  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
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
  List<dynamic>? children;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createBy'] = createBy;
    map['createTime'] = createTime;
    map['updateBy'] = updateBy;
    map['updateTime'] = updateTime;
    map['remark'] = remark;
    map['deptId'] = deptId;
    map['parentId'] = parentId;
    map['ancestors'] = ancestors;
    map['deptName'] = deptName;
    map['orderNum'] = orderNum;
    map['leader'] = leader;
    map['phone'] = phone;
    map['email'] = email;
    map['status'] = status;
    map['delFlag'] = delFlag;
    map['parentName'] = parentName;
    if (children != null) {
      map['children'] = children;
    }
    return map;
  }
}

class Role {
  Role({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.roleId,
    this.roleName,
    this.roleKey,
    this.roleSort,
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

  Role.fromJson(Map<String, dynamic>? json) {
    createBy = json?['createBy'];
    createTime = json?['createTime'];
    updateBy = json?['updateBy'];
    updateTime = json?['updateTime'];
    remark = json?['remark'];
    roleId = json?['roleId'];
    roleName = json?['roleName'];
    roleKey = json?['roleKey'];
    roleSort = json?['roleSort'];
    dataScope = json?['dataScope'];
    menuCheckStrictly = json?['menuCheckStrictly'];
    deptCheckStrictly = json?['deptCheckStrictly'];
    status = json?['status'];
    delFlag = json?['delFlag'];
    flag = json?['flag'];
    menuIds = json?['menuIds'] != null ? List<dynamic>.from(json?['menuIds']) : null;
    deptIds = json?['deptIds'] != null ? List<dynamic>.from(json?['deptIds']) : null;
    permissions = json?['permissions'] != null ? List<dynamic>.from(json?['permissions']) : null;
    admin = json?['admin'];
  }

  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  int? roleId;
  String? roleName;
  String? roleKey;
  int? roleSort;
  String? dataScope;
  bool? menuCheckStrictly;
  bool? deptCheckStrictly;
  String? status;
  String? delFlag;
  bool? flag;
  List<dynamic>? menuIds;
  List<dynamic>? deptIds;
  List<dynamic>? permissions;
  bool? admin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createBy'] = createBy;
    map['createTime'] = createTime;
    map['updateBy'] = updateBy;
    map['updateTime'] = updateTime;
    map['remark'] = remark;
    map['roleId'] = roleId;
    map['roleName'] = roleName;
    map['roleKey'] = roleKey;
    map['roleSort'] = roleSort;
    map['dataScope'] = dataScope;
    map['menuCheckStrictly'] = menuCheckStrictly;
    map['deptCheckStrictly'] = deptCheckStrictly;
    map['status'] = status;
    map['delFlag'] = delFlag;
    map['flag'] = flag;
    if (menuIds != null) {
      map['menuIds'] = menuIds;
    }
    if (deptIds != null) {
      map['deptIds'] = deptIds;
    }
    if (permissions != null) {
      map['permissions'] = permissions;
    }
    map['admin'] = admin;
    return map;
  }
}
