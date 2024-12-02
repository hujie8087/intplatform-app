class ParseQrCodeModel {
  String? type;
  String? amount;
  String? dealerNum;
  String? staNum;
  String? recId;
  String? sign;

  ParseQrCodeModel(
      {this.type,
      this.amount,
      this.dealerNum,
      this.staNum,
      this.recId,
      this.sign});

  ParseQrCodeModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    amount = json['amount'];
    dealerNum = json['dealerNum'];
    staNum = json['staNum'];
    recId = json['recId'];
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['dealerNum'] = this.dealerNum;
    data['staNum'] = this.staNum;
    data['recId'] = this.recId;
    data['sign'] = this.sign;
    return data;
  }
}
