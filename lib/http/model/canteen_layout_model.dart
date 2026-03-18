class CanteenLayoutModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  int? canteenId;
  String? canteen;
  int? width;
  int? height;
  int? status;
  List<FoodCanteenLayoutDeskList>? foodCanteenLayoutDeskList;

  CanteenLayoutModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.canteenId,
    this.canteen,
    this.width,
    this.height,
    this.status,
    this.foodCanteenLayoutDeskList,
  });

  CanteenLayoutModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    canteenId = json['canteenId'];
    canteen = json['canteen'];
    width = json['width'];
    height = json['height'];
    status = json['status'];
    if (json['foodCanteenLayoutDeskList'] != null) {
      foodCanteenLayoutDeskList = <FoodCanteenLayoutDeskList>[];
      json['foodCanteenLayoutDeskList'].forEach((v) {
        foodCanteenLayoutDeskList!.add(
          new FoodCanteenLayoutDeskList.fromJson(v),
        );
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
    data['canteenId'] = this.canteenId;
    data['canteen'] = this.canteen;
    data['width'] = this.width;
    data['height'] = this.height;
    data['status'] = this.status;
    if (this.foodCanteenLayoutDeskList != null) {
      data['foodCanteenLayoutDeskList'] =
          this.foodCanteenLayoutDeskList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodCanteenLayoutDeskList {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  int? lId;
  String? label;
  String? type;
  int? capacity;
  int? x;
  int? y;
  int? width;
  int? height;
  String? status;
  int? rotation;
  String? icon;

  FoodCanteenLayoutDeskList({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.lId,
    this.label,
    this.type,
    this.capacity,
    this.x,
    this.y,
    this.width,
    this.height,
    this.status,
    this.rotation,
    this.icon,
  });

  FoodCanteenLayoutDeskList.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    lId = json['lId'];
    label = json['label'];
    type = json['type'];
    capacity = json['capacity'];
    x = json['x'];
    y = json['y'];
    width = json['width'];
    height = json['height'];
    status = json['status'];
    rotation = json['rotation'];
    icon = json['icon'];
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
    data['lId'] = this.lId;
    data['label'] = this.label;
    data['type'] = this.type;
    data['capacity'] = this.capacity;
    data['x'] = this.x;
    data['y'] = this.y;
    data['width'] = this.width;
    data['height'] = this.height;
    data['status'] = this.status;
    data['rotation'] = this.rotation;
    data['icon'] = this.icon;
    return data;
  }
}
