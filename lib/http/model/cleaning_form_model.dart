class CleaningFormModel {
  String? contacts;
  String? tel;
  String? cleanPrice;
  String? remark;
  String? clNo;
  String? clArea;
  String? roomNo;
  int? rlaId;
  int? rlId;
  int? cpId;
  String? reserveDate;

  CleaningFormModel({
    this.contacts,
    this.tel,
    this.cleanPrice,
    this.remark,
    this.clNo,
    this.clArea,
    this.roomNo,
    this.rlaId,
    this.rlId,
    this.cpId,
    this.reserveDate,
  });

  factory CleaningFormModel.fromJson(Map<String, dynamic> json) {
    return CleaningFormModel(
      contacts: json['contacts'],
      tel: json['tel'],
      cleanPrice: json['cleanPrice'],
      remark: json['remark'],
      clNo: json['clNo'],
      clArea: json['clArea'],
      roomNo: json['roomNo'],
      rlaId: json['rlaId'],
      rlId: json['rlId'],
      cpId: json['cpId'],
      reserveDate: json['reserveDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contacts': contacts,
      'tel': tel,
      'cleanPrice': cleanPrice,
      'remark': remark,
      'clNo': clNo,
      'clArea': clArea,
      'roomNo': roomNo,
      'rlaId': rlaId,
      'rlId': rlId,
      'cpId': cpId,
      'reserveDate': reserveDate,
    };
  }
}
