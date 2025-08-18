class AccommodationProcessModel {
  int? id;
  String? title;
  String? content;
  String? requirements;
  String? img;
  String? icon;
  String? isLogin;
  int? sort;
  int? views;
  String? status;
  String? delFlag;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? deleteBy;
  String? deleteTime;
  String? remark;

  AccommodationProcessModel(
      {this.id,
      this.title,
      this.content,
      this.requirements,
      this.img,
      this.icon,
      this.isLogin,
      this.sort,
      this.views,
      this.status,
      this.delFlag,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.deleteBy,
      this.deleteTime,
      this.remark});

  AccommodationProcessModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    requirements = json['requirements'];
    img = json['img'];
    icon = json['icon'];
    isLogin = json['isLogin'];
    sort = json['sort'];
    views = json['views'];
    status = json['status'];
    delFlag = json['delFlag'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    deleteBy = json['deleteBy'];
    deleteTime = json['deleteTime'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['requirements'] = this.requirements;
    data['img'] = this.img;
    data['icon'] = this.icon;
    data['isLogin'] = this.isLogin;
    data['sort'] = this.sort;
    data['views'] = this.views;
    data['status'] = this.status;
    data['delFlag'] = this.delFlag;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    data['remark'] = this.remark;
    return data;
  }
}
