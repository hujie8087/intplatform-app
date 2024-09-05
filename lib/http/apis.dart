///  apis.dart
///
///  Created by iotjin on 2020/07/07.
///  description:  api管理

class APIs {
  /// url 前缀
  // 正式环境
  // static const String apiPrefix =
  //     'http://36.92.27.251:38080/api/intplatform/app'; // 外网
  // static const String apiPrefixWifi =
  //     'http://192.168.90.40/api/intplatform/app'; // 内网
  // static const String imagePrefix =
  //     'http://36.92.27.251:28080/static/intplatform'; // 图片外网地址
  // static const String imagePrefixWifi =
  //     'http://192.168.90.30/static/intplatform'; // 图片内网地址

  // 测试环境
  // static const String apiPrefix = 'http://192.168.91.50:10200'; // 外网
  // static const String apiPrefixWifi = 'http://192.168.91.50:10200'; // 内网
  static const String imagePrefix =
      'http://192.168.91.50:9000/intplatform'; // 图片外网地址
  static const String imagePrefixWifi =
      'http://192.168.91.50:9000/intplatform'; // 图片内网地址

  // 韩栋本地环境
  // static const String apiPrefix = 'http://10.40.10.18:10200'; // 外网
  // static const String apiPrefixWifi = 'http://10.40.10.18:10200'; // 内网

  // 阿泽本地环境
  static const String apiPrefix = 'http://10.40.11.26:10200'; // 外网
  static const String apiPrefixWifi = 'http://10.40.11.26:10200'; // 内网

  /// 注册接口
  static const String register = '/auth/register';

  /// 登录接口
  static const String login = '/auth/appLogin';

  // 退出登录
  static const String logout = '/auth/logout';

  // 获取用户信息
  static const String getUserInfo = '/system/user/getInfo';

  // 编辑用户信息
  static const String editUser = '/system/user/edit';

  // 储存用户设备token
  static const String addToken = '/system/user/addToken';

  /// 获取分页数据
  static const String getPage = '/mock/pages';

  /// 获取分页分组数据
  static const String getGroupPage = '/mock/groupPages';

  /// 获取固定数据
  static const String getSimpleDictList = '/mock/simpleDictList';

  /// 获取固定数据
  static const String getSimpleDict = '/mock/dict';

  // 用户修改密码
  static const String updateUserPwd = '/system/user/profile/updatePwd';

  // 获取数据字典
  static const String getDictDataList = '/system/dict/data/type/';

  // 获取公共便利字典
  static const String getOtherDataList = '/other/show/list';

  // 获取新闻公共详情
  static const String getNoticeDetail = '/system/notice';

  // 获取APP最新版本
  static const String getAppLastVersion = '/other/app/getNewApp';
}
