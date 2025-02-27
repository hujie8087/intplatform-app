class AppMenuModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  String? cname;
  String? uname;
  String? yname;
  int? sort;
  int? status;
  String? icon;
  String? permissions;
  String? delFlag;
  String? deleteBy;
  String? deleteTime;
  int? isLogin;
  List<IconArticles>? iconArticles;

  AppMenuModel(
      {this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.remark,
      this.startQueryTime,
      this.endQueryTime,
      this.id,
      this.cname,
      this.uname,
      this.yname,
      this.sort,
      this.status,
      this.icon,
      this.permissions,
      this.delFlag,
      this.deleteBy,
      this.deleteTime,
      this.isLogin,
      this.iconArticles});

  AppMenuModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];

    endQueryTime = json['endQueryTime'];
    id = json['id'];
    cname = json['cname'];
    uname = json['uname'];
    yname = json['yname'];
    sort = json['sort'];
    status = json['status'];
    icon = json['icon'];
    permissions = json['permissions'];
    delFlag = json['delFlag'];
    deleteBy = json['deleteBy'];
    deleteTime = json['deleteTime'];
    isLogin = json['isLogin'];
    if (json['iconArticles'] != null) {
      iconArticles = <IconArticles>[];
      json['iconArticles'].forEach((v) {
        iconArticles!.add(new IconArticles.fromJson(v));
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
    data['id'] = this.id;
    data['cname'] = this.cname;
    data['uname'] = this.uname;
    data['yname'] = this.yname;
    data['sort'] = this.sort;
    data['status'] = this.status;
    data['icon'] = this.icon;
    data['permissions'] = this.permissions;
    data['delFlag'] = this.delFlag;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    data['isLogin'] = this.isLogin;
    if (this.iconArticles != null) {
      data['iconArticles'] = this.iconArticles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IconArticles {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;

  String? endQueryTime;
  int? id;
  int? typeId;
  String? cname;
  String? uname;
  String? yname;
  int? sort;

  int? status;
  String? icon;
  int? isMic;
  String? router;
  String? permissions;
  String? delFlag;
  String? deleteBy;
  String? deleteTime;
  int? isLogin;

  IconArticles(
      {this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.remark,
      this.startQueryTime,
      this.endQueryTime,
      this.id,
      this.typeId,
      this.cname,
      this.uname,
      this.yname,
      this.sort,
      this.status,
      this.icon,
      this.isMic,
      this.router,
      this.permissions,
      this.delFlag,
      this.deleteBy,
      this.deleteTime,
      this.isLogin});

  IconArticles.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    typeId = json['typeId'];
    cname = json['cname'];
    uname = json['uname'];
    yname = json['yname'];
    sort = json['sort'];
    status = json['status'];
    icon = json['icon'];
    isMic = json['isMic'];
    router = json['router'];
    permissions = json['permissions'];
    delFlag = json['delFlag'];
    deleteBy = json['deleteBy'];
    deleteTime = json['deleteTime'];
    isLogin = json['isLogin'];
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
    data['typeId'] = this.typeId;
    data['cname'] = this.cname;
    data['uname'] = this.uname;
    data['yname'] = this.yname;
    data['sort'] = this.sort;
    data['status'] = this.status;
    data['icon'] = this.icon;
    data['isMic'] = this.isMic;
    data['router'] = this.router;
    data['permissions'] = this.permissions;
    data['delFlag'] = this.delFlag;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    data['isLogin'] = this.isLogin;
    return data;
  }
}
