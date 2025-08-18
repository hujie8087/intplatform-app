
class CarInfoListData {
    int? total;
    List<CarInfoData>? rows;
    int? code;
    String? msg;

    CarInfoListData({this.total, this.rows, this.code, this.msg});

    CarInfoListData.fromJson(Map<String, dynamic> json) {
        total = json["total"];
        rows = json["rows"] == null ? null : (json["rows"] as List).map((e) => CarInfoData.fromJson(e)).toList();
        code = json["code"];
        msg = json["msg"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["total"] = total;
        if(rows != null) {
            _data["rows"] = rows?.map((e) => e.toJson()).toList();
        }
        _data["code"] = code;
        _data["msg"] = msg;
        return _data;
    }
}

class CarInfoData {
    String? createBy;
    String? createTime;
    String? updateBy;
    String? updateTime;
    String? remark;
    int? cmId;
    String? parkNo;
    String? carState;
    String? lineNo;
    String? carType;
    int? loadNumber;
    String? path;
    String? delFlag;
    dynamic def1;
    dynamic def2;
    dynamic def3;
    dynamic def4;
    dynamic def5;
    dynamic deleteBy;
    dynamic deleteTime;
    dynamic sourceNo;
    dynamic souceType;

    CarInfoData({this.createBy, this.createTime, this.updateBy, this.updateTime, this.remark, this.cmId, this.parkNo, this.carState, this.lineNo, this.carType, this.loadNumber, this.path, this.delFlag, this.def1, this.def2, this.def3, this.def4, this.def5, this.deleteBy, this.deleteTime, this.sourceNo, this.souceType});

    CarInfoData.fromJson(Map<String, dynamic> json) {
        createBy = json["createBy"];
        createTime = json["createTime"];
        updateBy = json["updateBy"];
        updateTime = json["updateTime"];
        remark = json["remark"];
        cmId = json["cmId"];
        parkNo = json["parkNo"];
        carState = json["carState"];
        lineNo = json["lineNo"];
        carType = json["carType"];
        loadNumber = json["loadNumber"];
        path = json["path"];
        delFlag = json["delFlag"];
        def1 = json["def1"];
        def2 = json["def2"];
        def3 = json["def3"];
        def4 = json["def4"];
        def5 = json["def5"];
        deleteBy = json["deleteBy"];
        deleteTime = json["deleteTime"];
        sourceNo = json["sourceNo"];
        souceType = json["souceType"];
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
        _data["carState"] = carState;
        _data["lineNo"] = lineNo;
        _data["carType"] = carType;
        _data["loadNumber"] = loadNumber;
        _data["path"] = path;
        _data["delFlag"] = delFlag;
        _data["def1"] = def1;
        _data["def2"] = def2;
        _data["def3"] = def3;
        _data["def4"] = def4;
        _data["def5"] = def5;
        _data["deleteBy"] = deleteBy;
        _data["deleteTime"] = deleteTime;
        _data["sourceNo"] = sourceNo;
        _data["souceType"] = souceType;
        return _data;
    }
}