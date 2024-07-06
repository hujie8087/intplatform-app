
class RouteQueryData {
  List<RouteQueryDataData>? data;

  RouteQueryData({this.data});

  RouteQueryData.fromJson(dynamic json) {
    if(json != null) {
      data = [];
      json.forEach((v) {
        data?.add(RouteQueryDataData.fromJson(v));
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

class RouteQueryDataData {
  String? createBy;
  String? createTime;
  String? updateBy;
  dynamic updateTime;
  String? remark;
  int cmId=0;
  String parkNo='';
  String lineNo='';
  String carType='';
  String path='';
  List<String>? def1=[];
  String? def2;
  String? def3;
  String? def4;
  String? def5;
  String? souceType;
  String? sourceNo;
  dynamic routeGrade;
  String status='';

  RouteQueryDataData({this.createBy, this.createTime, this.updateBy, this.updateTime, this.remark, this.cmId=1, this.carType='大巴车', this.def1, this.def2, this.def3, this.status='1',this.def4,this.def5,this.lineNo='',this.parkNo='',this.path='',this.routeGrade,this.souceType,this.sourceNo});

  RouteQueryDataData.fromJson(Map<String, dynamic> json) {
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
    cmId = json["cmId"];
    if(json["parkNo"] is String) {
      parkNo = json["parkNo"];
    }
    if(json["lineNo"] is String) {
      lineNo = json["lineNo"];
    }
    carType = json["carType"];
    if(json["def1"] is String) {
      def1 = json["def1"];
    }
    if(json["def2"] is String) {
      def2 = json["def2"];
    }
    if(json["def3"] is String) {
      def3 = json["def3"];
    }
    if(json["def4"] is String) {
      def4 = json["def4"];
    }
    if(json["def5"] is String) {
      def5 = json["def5"];
    }
    path = json["path"];
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
    _data["cmId"] = cmId;
    _data["parkNo"] = parkNo;
    _data["lineNo"] = lineNo;
    _data["path"] = path;
    _data["carType"] = carType;
    _data["def1"] = def1;
    _data["def2"] = def2;
    _data["def3"] = def3;
    _data["def4"] = def4;
    _data["def5"] = def5;
    _data["status"] = status;
    return _data;
  }
}