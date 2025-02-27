class ApplyViewModel {
  int? id;
  String? title;
  String? url;
  String? getTokenUrl;
  String? checkTokenUrl;
  String? img;
  String? icon;
  String? isLogin;
  String? formId;
  String? sort;
  String? status;
  String? delFlag;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? deleteBy;
  String? deleteTime;
  String? remark;
  String? def1;
  String? def2;

  ApplyViewModel(
      {this.id,
      this.title,
      this.url,
      this.getTokenUrl,
      this.checkTokenUrl,
      this.img,
      this.icon,
      this.isLogin,
      this.formId,
      this.sort,
      this.status,
      this.delFlag,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.deleteBy,
      this.deleteTime,
      this.remark,
      this.def1,
      this.def2});

  factory ApplyViewModel.fromJson(Map<String, dynamic> json) {
    return ApplyViewModel(
        id: json['id'],
        title: json['title'],
        url: json['url'],
        getTokenUrl: json['getTokenUrl'],
        checkTokenUrl: json['checkTokenUrl'],
        img: json['img'],
        icon: json['icon'],
        isLogin: json['isLogin'],
        formId: json['formId'],
        sort: json['sort'],
        status: json['status'],
        delFlag: json['delFlag'],
        createBy: json['createBy'],
        createTime: json['createTime'],
        updateBy: json['updateBy'],
        updateTime: json['updateTime'],
        deleteBy: json['deleteBy'],
        deleteTime: json['deleteTime'],
        remark: json['remark'],
        def1: json['def1'],
        def2: json['def2']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['url'] = this.url;
    data['getTokenUrl'] = this.getTokenUrl;
    data['checkTokenUrl'] = this.checkTokenUrl;
    data['img'] = this.img;
    data['icon'] = this.icon;
    data['isLogin'] = this.isLogin;
    data['formId'] = this.formId;
    data['sort'] = this.sort;
    data['status'] = this.status;
    data['delFlag'] = this.delFlag;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    data['remark'] = this.remark;
    data['def1'] = this.def1;
    data['def2'] = this.def2;
    return data;
  }
}
