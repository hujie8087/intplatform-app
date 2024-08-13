/// code : 0
/// message : ""
/// data : {"buildBuildVersion":"7","forceUpdateVersion":"","forceUpdateVersionNo":"","needForceUpdate":false,"downloadURL":"https://www.pgyer.com/app/installUpdate/a13612a93812c0d4cfa3da5f50c9284b?sig=brAFJYcCf6R2gleDIKXxTGMt35R5wNKPcMcimnx2R1P6jBvfbnYk3FcIR51RF%2F7P&forceHttps=","buildHaveNewVersion":false,"buildVersionNo":"7","buildVersion":"1.0.7","buildDescription":"","buildUpdateDescription":"","appURl":"https://www.pgyer.com/a13612a93812c0d4cfa3da5f50c9284b","appKey":"2639f784ce9ee850532074b7b0534e62","buildKey":"a13612a93812c0d4cfa3da5f50c9284b","buildName":"Android资讯","buildIcon":"https://cdn-app-icon.pgyer.com/a/5/c/8/4/a5c84809a0096a2b96efc81e6d0af63f?x-oss-process=image/resize,m_lfit,h_120,w_120/format,jpg","buildFileKey":"556e82d16b9f1718d76a48a98b40eff2.apk","buildFileSize":"16977009"}

class AppCheckUpdateModel {
  AppCheckUpdateModel({
    this.code,
    this.message,
    this.data,
  });

  AppCheckUpdateModel.fromJson(Map<String, dynamic>? json) {
    code = json?['code'];
    message = json?['message'];
    data =
        json?['data'] != null ? UpdateInfoData.fromJson(json?['data']) : null;
  }

  num? code;
  String? message;
  UpdateInfoData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

// "hasUpdate": true,
// "isIgnorable": true,
// "versionCode": 3,
// "versionName": "1.0.2",
// "updateLog": "\r\n1、优化api接口。\r\n2、添加使用demo演示。\r\n3、新增自定义更新服务API接口。\r\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。\n1、优化api接口。\n2、添加使用demo演示。\n3、新增自定义更新服务API接口。\n4、优化更新提示界面。",
// "apkUrl": "https://down.qq.com/qqweb/QQ_1/android_apk/Android_8.5.0.5025_537066738.apk",
// "apkSize": 4096

class UpdateInfoData {
  bool? hasUpdate;
  bool? isIgnorable;
  late String versionCode;
  late String versionName;
  String? updateLog;
  late String apkUrl;
  late int apkSize;

  UpdateInfoData(
      {this.hasUpdate,
      this.isIgnorable,
      required this.versionCode,
      required this.versionName,
      this.updateLog,
      required this.apkUrl,
      required this.apkSize});

  UpdateInfoData.fromJson(Map<String, dynamic> json) {
    hasUpdate = json['hasUpdate'];
    isIgnorable = json['isIgnorable'];
    versionCode = json['versionCode'] ?? ''; // 确保非空
    versionName = json['versionName'] ?? ''; // 确保非空
    updateLog = json['updateLog'];
    apkUrl = json['apkUrl'] ?? ''; // 确保非空
    apkSize = json['apkSize'] ?? 0; // 确保非空
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasUpdate'] = this.hasUpdate;
    data['isIgnorable'] = this.isIgnorable;
    data['versionCode'] = this.versionCode;
    data['versionName'] = this.versionName;
    data['updateLog'] = this.updateLog;
    data['apkUrl'] = this.apkUrl;
    data['apkSize'] = this.apkSize;
    return data;
  }
}
