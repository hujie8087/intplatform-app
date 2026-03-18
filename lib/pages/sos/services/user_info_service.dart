import 'package:logistics_app/constants.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 用户信息数据类
class UserInfo {
  final String userId;
  final String userName; // 工号
  final String nickName; // 姓名
  final String deviceId;
  final bool isLoggedIn;

  UserInfo({
    required this.userId,
    required this.userName,
    required this.nickName,
    required this.deviceId,
    required this.isLoggedIn,
  });

  @override
  String toString() {
    return 'UserInfo(userId: $userId, userName: $userName, nickName: $nickName, deviceId: $deviceId, isLoggedIn: $isLoggedIn)';
  }
}

/// 统一用户信息服务
class UserInfoService {
  /// - 如果用户已登录：使用用户的userName（工号）、nickName（姓名）等身份信息
  /// - 如果用户未登录：所有字段（userId、userName、nickName）都使用设备ID的值
  static Future<UserInfo> getUserInfo() async {
    try {
      print('=== 获取用户信息 ===');

      // 首先获取设备ID
      String deviceId =
          await SpUtils.getString(Constants.SP_DEVICE_TOKEN) ?? '';
      print('设备ID: $deviceId');

      UserInfo? userInfo = await _getUserInfoFromSharedPreferences();

      if (userInfo != null && userInfo.isLoggedIn) {
        // 用户已登录，使用用户的身份信息，但保持设备ID
        print('用户已登录，使用用户身份信息');
        print('获取到用户信息: $userInfo');
        print('==================');
        return userInfo;
      }

      // 用户未登录或获取失败，使用设备ID作为所有字段的值
      print('用户未登录，使用设备ID作为所有字段的值');
      UserInfo deviceInfo = UserInfo(
        userId: deviceId,
        userName: deviceId,
        nickName: deviceId,
        deviceId: deviceId,
        isLoggedIn: false,
      );
      print('设备信息: $deviceInfo');
      print('==================');
      return deviceInfo;
    } catch (e) {
      print('获取用户信息失败: $e');
      // 出错时使用设备信息作为备用
      String deviceId =
          await SpUtils.getString(Constants.SP_DEVICE_TOKEN) ?? '';
      return UserInfo(
        userId: deviceId,
        userName: deviceId,
        nickName: deviceId,
        deviceId: deviceId,
        isLoggedIn: false,
      );
    }
  }

  /// 清空本地存储的用户信息
  /// 在用户退出登录或离开SOS报警页面时调用
  static Future<void> clearUserInfo() async {
    try {
      print('=== 清空用户信息 ===');
      // 清空SharedPreferences中的用户信息
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_id');
        await prefs.remove('user_name');
        await prefs.remove('user_nick_name');
        await prefs.remove('user_job_id');
        print('已清空SharedPreferences中的用户信息');
      } catch (e) {
        print('清空SharedPreferences用户信息失败: $e');
      }

      print('==================');
    } catch (e) {
      print('清空用户信息失败: $e');
    }
  }

  /// 从SharedPreferences获取用户信息
  static Future<UserInfo?> _getUserInfoFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // 获取存储的用户信息
      String? userIdStr = prefs.getString('user_id');

      print('从SharedPreferences获取用户信息:');
      print('用户ID: $userIdStr');

      // 如果有存储的用户信息，则使用它
      if (userIdStr != null && userIdStr.isNotEmpty) {
        String? userNameStr = prefs.getString('user_name');
        String? nickNameStr = prefs.getString('user_nick_name');
        String? jobIdStr = prefs.getString('user_job_id');

        // 获取设备ID作为备用
        String deviceId =
            await SpUtils.getString(Constants.SP_DEVICE_TOKEN) ?? '';

        return UserInfo(
          userId: userIdStr,
          userName: userNameStr ?? jobIdStr ?? '', // 工号
          nickName: nickNameStr ?? '', // 姓名
          deviceId: deviceId,
          isLoggedIn: true,
        );
      } else {
        print('SharedPreferences中没有存储用户信息');
        return null;
      }
    } catch (e) {
      print('从SharedPreferences获取用户信息失败: $e');
      return null;
    }
  }
}
