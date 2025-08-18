
class HomeNoticeListData {
  List<HomeNoticeData>? data;

  HomeNoticeListData({this.data});

  HomeNoticeListData.fromJson(dynamic json) {
    if(json != null) {
      data = [];
      json.forEach((v) {
        data?.add(HomeNoticeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class HomeNoticeData {
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
  String? status;

  HomeNoticeData({this.createBy, this.createTime, this.updateBy, this.updateTime, this.remark, this.noticeId, this.noticeTitle, this.noticeType, this.noticeContent, this.noticeGrade, this.status});

  HomeNoticeData.fromJson(Map<String, dynamic> json) {
    if(json["createBy"] is String) {
      createBy = json["createBy"];
    }
    if(json["createTime"] is String) {
      createTime = json["createTime"];
    }
    if(json["updateBy"] is String) {
      updateBy = json["updateBy"];
    }
    updateTime = json["updateTime"];
    if(json["remark"] is String) {
      remark = json["remark"];
    }
    if(json["noticeId"] is int) {
      noticeId = json["noticeId"];
    }
    if(json["noticeTitle"] is String) {
      noticeTitle = json["noticeTitle"];
    }
    if(json["noticeType"] is String) {
      noticeType = json["noticeType"];
    }
    if(json["noticeContent"] is String) {
      noticeContent = json["noticeContent"];
    }
    noticeGrade = json["noticeGrade"];
    if(json["status"] is String) {
      status = json["status"];
    }
  }

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
    _data["status"] = status;
    return _data;
  }
}