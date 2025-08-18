/// access_token : ''
/// expires_in : 720

///用户数据返回
class LoginInfoModel {
  LoginInfoModel({
    this.access_token,
    this.expires_in,
  });

  LoginInfoModel.fromJson(Map<String, dynamic>? json) {
    access_token = json?['access_token'];
    expires_in = json?['expires_in'];
  }

  String? access_token;
  num? expires_in;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = access_token;
    map['expires_in'] = expires_in;
    return map;
  }
}
