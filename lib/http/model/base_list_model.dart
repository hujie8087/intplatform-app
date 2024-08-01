class BaseListModel<T> {
  List<T>? data;
  int? code;
  String? msg;

  BaseListModel({this.data, this.code, this.msg});

  factory BaseListModel.fromJson(dynamic json, T Function(dynamic) fromJsonT) {
    var list = json['data'] as List;
    List<T> rowsList = list.map((i) => fromJsonT(i)).toList();
    return BaseListModel(
      data: rowsList,
      code: json['code'],
      msg: json['msg'],
    );
  }
}
