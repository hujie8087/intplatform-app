  class BaseModel<T> {
  T? data;
  int? code;
  String? msg;

  BaseModel.fromJson(dynamic json) {
    data = json['data'];
    code = json['code'];
    msg = json['msg'];
  }
}
