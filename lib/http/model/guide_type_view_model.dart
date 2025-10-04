class GuideTypeViewModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  int? id;
  String? title;
  String? content;
  String? img;
  int? isLogin;
  int? sort;
  String? status;
  String? delFlag;
  String? deleteBy;
  String? deleteTime;
  int? approvalStatus;
  String? file;
  String? url;

  GuideTypeViewModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.id,
    this.title,
    this.content,
    this.img,
    this.isLogin,
    this.sort,
    this.status,
    this.delFlag,
    this.deleteBy,
    this.deleteTime,
    this.approvalStatus,
    this.file,
    this.url,
  });

  GuideTypeViewModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    id = json['id'];
    title = json['title'];
    content = json['content'];
    img = json['img'];
    isLogin = json['isLogin'];
    sort = json['sort'];
    status = json['status'];
    delFlag = json['delFlag'];
    deleteBy = json['deleteBy'];
    deleteTime = json['deleteTime'];
    approvalStatus = json['approvalStatus'];
    file = json['file'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['img'] = this.img;
    data['isLogin'] = this.isLogin;
    data['sort'] = this.sort;
    data['status'] = this.status;
    data['delFlag'] = this.delFlag;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    data['approvalStatus'] = this.approvalStatus;
    data['file'] = this.file;
    data['url'] = this.url;
    return data;
  }
}
