class RepairFormModel {
  int? repairAreaId;
  String? repairArea;
  String? repairRoomId;
  String? repairMessage;
  String? roomNo;
  String? tel;
  String? repairPhoto;
  String? repairPerson;
  String? repairKey;

  RepairFormModel(
      {this.repairAreaId,
      this.repairArea,
      this.repairRoomId,
      this.repairMessage,
      this.roomNo,
      this.tel,
      this.repairPhoto,
      this.repairPerson,
      this.repairKey});

  factory RepairFormModel.fromJson(Map<String, dynamic> json) {
    return RepairFormModel(
      repairAreaId: json['repairAreaId'],
      repairArea: json['repairArea'],
      repairRoomId: json['repairRoomId'],
      repairMessage: json['repairMessage'],
      roomNo: json['roomNo'],
      tel: json['tel'],
      repairPhoto: json['repairPhoto'],
      repairPerson: json['repairPerson'],
      repairKey: json['repairKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'repairAreaId': repairAreaId,
      'repairArea': repairArea,
      'repairRoomId': repairRoomId,
      'repairMessage': repairMessage,
      'roomNo': roomNo,
      'tel': tel,
      'repairPhoto': repairPhoto,
      'repairPerson': repairPerson,
      'repairKey': repairKey,
    };
  }
}
