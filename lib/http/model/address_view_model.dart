class AddressViewModel {
  String? msg;
  int? code;
  List<AddressData>? data;

  AddressViewModel({this.msg, this.code, this.data});

  AddressViewModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    if (json['data'] != null) {
      data = <AddressData>[];
      json['data'].forEach((v) {
        data!.add(new AddressData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressData {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  int? id;
  int? pid;
  String? title;
  String? code;
  int? sort;
  int? createById;
  int? updateById;
  int? createByDeptId;
  int? updateByDeptId;
  String? deleted;
  String? version;
  int? status;
  String? expected;
  String? actual;
  String? roomTypeId;
  String? ancestors;
  List<AddressData>? children;
  String? roomTitle;

  AddressData(
      {this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.remark,
      this.id,
      this.pid,
      this.title,
      this.code,
      this.sort,
      this.createById,
      this.updateById,
      this.createByDeptId,
      this.updateByDeptId,
      this.deleted,
      this.version,
      this.status,
      this.expected,
      this.actual,
      this.roomTypeId,
      this.ancestors,
      this.children,
      this.roomTitle});

  AddressData.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    id = json['id'];
    pid = json['pid'];
    title = json['title'];
    code = json['code'];
    sort = json['sort'];
    createById = json['createById'];
    updateById = json['updateById'];
    createByDeptId = json['createByDeptId'];
    updateByDeptId = json['updateByDeptId'];
    deleted = json['deleted'];
    version = json['version'];
    status = json['status'];
    expected = json['expected'];
    actual = json['actual'];
    roomTypeId = json['roomTypeId'];
    ancestors = json['ancestors'];
    if (json['children'] != null) {
      children = <AddressData>[];
      json['children'].forEach((v) {
        children!.add(new AddressData.fromJson(v));
      });
    }
    roomTitle = json['roomTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['title'] = this.title;
    data['code'] = this.code;
    data['sort'] = this.sort;
    data['createById'] = this.createById;
    data['updateById'] = this.updateById;
    data['createByDeptId'] = this.createByDeptId;
    data['updateByDeptId'] = this.updateByDeptId;
    data['deleted'] = this.deleted;
    data['version'] = this.version;
    data['status'] = this.status;
    data['expected'] = this.expected;
    data['actual'] = this.actual;
    data['roomTypeId'] = this.roomTypeId;
    data['ancestors'] = this.ancestors;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    data['roomTitle'] = this.roomTitle;
    return data;
  }
}
