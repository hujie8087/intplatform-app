class TopUpMonthModel {
  int? id;
  String? yearMonth;
  String? currency;
  double? exchangeRate;

  TopUpMonthModel({this.id, this.yearMonth, this.currency, this.exchangeRate});

  TopUpMonthModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yearMonth = json['yearMonth'];
    currency = json['currency'];
    exchangeRate = json['exchangeRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yearMonth'] = this.yearMonth;
    data['currency'] = this.currency;
    data['exchangeRate'] = this.exchangeRate;
    return data;
  }
}

class TopUpDetailModel {
  int? id;
  int? userId;
  String? account;
  String? name;
  int? amount;
  String? yearMonth;
  String? createTime;

  TopUpDetailModel({
    this.id,
    this.yearMonth,
    this.account,
    this.name,
    this.amount,
    this.userId,
    this.createTime,
  });

  TopUpDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yearMonth = json['yearMonth'];
    account = json['account'];
    name = json['name'];
    amount = json['amount'];
    userId = json['userId'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yearMonth'] = this.yearMonth;
    data['account'] = this.account;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['userId'] = this.userId;
    data['createTime'] = this.createTime;
    return data;
  }
}
