import 'dart:convert';

class AppInfo {
  final bool isForce;
  final bool hasUpdate;
  final bool isIgnorable;
  final int versionCode;
  final String versionName;
  final String updateLog;
  final String apkUrl;
  final int apkSize;

  AppInfo({
    required this.isForce,
    required this.hasUpdate,
    required this.isIgnorable,
    required this.versionCode,
    required this.versionName,
    required this.updateLog,
    required this.apkUrl,
    required this.apkSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'isForce': isForce,
      'hasUpdate': hasUpdate,
      'isIgnorable': isIgnorable,
      'versionCode': versionCode,
      'versionName': versionName,
      'updateLog': updateLog,
      'apkUrl': apkUrl,
      'apkSize': apkSize,
    };
  }

  static AppInfo fromMap(Map<String, dynamic> map) {
    return AppInfo(
      isForce: map['isForce'],
      hasUpdate: map['hasUpdate'],
      isIgnorable: map['isIgnorable'],
      versionCode: map['versionCode']?.toInt(),
      versionName: map['versionName'],
      updateLog: map['updateLog'],
      apkUrl: map['apkUrl'],
      apkSize: map['apkSize']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  static AppInfo fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppInfo isForce: $isForce, hasUpdate: $hasUpdate, isIgnorable: $isIgnorable, versionCode: $versionCode, versionName: $versionName, updateLog: $updateLog, apkUrl: $apkUrl, apkSize: $apkSize';
  }
}
