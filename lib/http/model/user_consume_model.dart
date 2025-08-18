class UserConsumeInfoData {
  int? id;
  String? username;
  String? nickname;
  String? tel;
  String? password;
  String? avatar;
  String? name;
  String? card;
  String? createTime;
  String? updateTime;
  int? status;
  String? pt;
  String? dept;
  String? remark;
  String? money;
  bool? vip;

  UserConsumeInfoData({
    this.id,
    this.username,
    this.nickname,
    this.tel,
    this.password,
    this.avatar,
    this.name,
    this.card,
    this.createTime,
    this.updateTime,
    this.status,
    this.pt,
    this.dept,
    this.remark,
    this.money,
    this.vip,
  });

  UserConsumeInfoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    nickname = json['nickname'];
    tel = json['tel'];
    password = json['password'];
    avatar = json['avatar'];
    name = json['name'];
    card = json['card'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    status = json['status'];
    pt = json['pt'];
    dept = json['dept'];
    remark = json['remark'];
    money = json['money'];
    vip = json['vip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['nickname'] = this.nickname;
    data['tel'] = this.tel;
    data['password'] = this.password;
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['card'] = this.card;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['status'] = this.status;
    data['pt'] = this.pt;
    data['dept'] = this.dept;
    data['remark'] = this.remark;
    data['money'] = this.money;
    data['vip'] = this.vip;
    return data;
  }
}
