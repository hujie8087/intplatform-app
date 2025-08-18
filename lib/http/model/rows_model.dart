class RowsModel<T> {
  List<T>? rows;
  int? total;
  int? code;
  String? msg;

  RowsModel({this.rows, this.total, this.code, this.msg});

  factory RowsModel.fromJson(dynamic json, T Function(dynamic) fromJsonT) {
    var list = json['rows'] as List;
    List<T> rowsList = list.map((i) => fromJsonT(i)).toList();
    return RowsModel(
      rows: rowsList,
      total: json['total'],
      code: json['code'],
      msg: json['msg'],
    );
  }
}
