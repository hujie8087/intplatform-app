class NoticeListModel {
  List<NoticeModel?> data = [];

  NoticeListModel(this.data);

  NoticeListModel.fromJson(dynamic json) {
    if (json is List) {
      for (var element in json) {
        data.add(NoticeModel.fromJson(element));
      }
    }
  }
}

class NoticeModel {
  NoticeModel(
      {this.createBy,
      this.createTime,
      this.createDept,
      this.updateBy,
      this.updateTime,
      this.remark,
      this.noticeId,
      this.noticeTitle,
      this.noticeType,
      this.noticeContent,
      this.noticeGrade,
      this.status});

  NoticeModel.fromJson(dynamic json) {
    if (json["createBy"] is String) {
      createBy = json["createBy"];
    }
    if (json["createTime"] is String) {
      createTime = json["createTime"];
    }
    if (json["updateBy"] is String) {
      updateBy = json["updateBy"];
    }
    updateTime = json["updateTime"];
    if (json["remark"] is String) {
      remark = json["remark"];
    }
    if (json["noticeId"] is int) {
      noticeId = json["noticeId"];
    }
    if (json["noticeTitle"] is String) {
      noticeTitle = json["noticeTitle"];
    }
    if (json["noticeType"] is String) {
      noticeType = json["noticeType"];
    }
    if (json["noticeContent"] is String) {
      noticeContent = json["noticeContent"];
    }
    if (json["createDept"] is String) {
      createDept = json["createDept"];
    }
    noticeGrade = json["noticeGrade"];
    if (json["status"] is String) {
      status = json["status"];
    }
  }

  String? createBy;
  String? createTime;
  String? updateBy;
  dynamic updateTime;
  String? remark;
  int? noticeId;
  String? noticeTitle;
  String? noticeType;
  String? noticeContent;
  dynamic noticeGrade;
  String? createDept;
  String? status;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["createBy"] = createBy;
    _data["createTime"] = createTime;
    _data["updateBy"] = updateBy;
    _data["updateTime"] = updateTime;
    _data["remark"] = remark;
    _data["noticeId"] = noticeId;
    _data["noticeTitle"] = noticeTitle;
    _data["noticeType"] = noticeType;
    _data["noticeContent"] = noticeContent;
    _data["noticeGrade"] = noticeGrade;
    _data["createDept"] = createDept;
    _data["status"] = status;
    return _data;
  }
}
