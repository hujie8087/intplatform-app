import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:logistics_app/http/model/app_info.dart';

class CheckUpdate {
  // 将自定义的json内容解析为UpdateEntity实体类
  UpdateEntity customParseJson(String json) {
    AppInfo appInfo = AppInfo.fromJson(json);
    return UpdateEntity(
        isForce: appInfo.isForce, // 是否强制更新
        hasUpdate: appInfo.hasUpdate, // 是否需要更新  默认true， 手动自行判断
        isIgnorable: appInfo.isIgnorable, // 是否显示 “忽略该版本”
        versionCode: appInfo.versionCode, // 新版本号
        versionName: appInfo.versionName, // 新版名称
        updateContent: appInfo.updateLog, // 新版更新日志
        downloadUrl: appInfo.apkUrl, // 新版本下载链接
        apkSize: appInfo.apkSize); // 新版本大小
  }

  // 自定义JSON更新
  checkUpdateByUpdateEntity(Map jsonData) async {
    var versionCode = jsonData["versionCode"].replaceAll('.', '');
    var updateText = jsonData["updateContent"].split('。');
    var updateContent = '';
    updateText.forEach((t) {
      updateContent += '\r\n$t';
    });

    UpdateEntity updateEntity = new UpdateEntity(
        isForce: jsonData["isForce"] == 1,
        hasUpdate: true,
        isIgnorable: false,
        versionCode: int.parse(versionCode),
        versionName: jsonData["versionName"],
        updateContent: updateContent,
        downloadUrl: jsonData["downloadUrl"],
        apkSize: jsonData["apkSize"]);
    FlutterXUpdate.updateByInfo(updateEntity: updateEntity);
  }

  // 初始化插件
  Future<dynamic> initXUpdate() async {
    FlutterXUpdate.init(
            //是否输出日志
            debug: true,
            //是否使用post请求
            isPost: true,
            //post请求是否是上传json
            isPostJson: true,
            //是否开启自动模式
            isWifiOnly: false,

            ///是否开启自动模式
            isAutoMode: false,
            //需要设置的公共参数
            supportSilentInstall: false,
            //在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
            enableRetry: false)
        .then((value) {
      print("初始化成功: $value");
    }).catchError((error) {
      print(error);
    });

    FlutterXUpdate.setUpdateHandler(
      onUpdateError: (Map<String, dynamic>? message) async {
        print("初始化成功: $message");
        return; // 返回 void
      },
      onUpdateParse: (String? json) async {
        // 这里是自定义 json 解析
        if (json != null) {
          return customParseJson(json);
        } else {
          // 处理 json 为空的情况
          return Future.error('JSON is null');
        }
      },
    );
  }
}
