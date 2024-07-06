  class RowsModel<T> {
  T? rows;
  int? total;
  int? code;
  String? msg;

  RowsModel.fromJson(dynamic json) {
    rows = json['rows'];
    total = json['total'];
    code = json['code'];
    msg = json['msg'];
  }
}
