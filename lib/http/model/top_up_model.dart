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
  String? no;
  int? id;
  int? userId;
  String? account;
  String? name;
  int? amount;
  String? yearMonth;
  String? createTime;
  String? deductedMonths;
  String? status;

  TopUpDetailModel({
    this.no,
    this.id,
    this.yearMonth,
    this.account,
    this.name,
    this.amount,
    this.userId,
    this.createTime,
    this.deductedMonths,
    this.status,
  });

  TopUpDetailModel.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    id = json['id'];
    yearMonth = json['yearMonth'];
    account = json['account'];
    name = json['name'];
    amount = json['amount'];
    userId = json['userId'];
    createTime = json['createTime'];
    deductedMonths = json['deductedMonths'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['no'] = this.no;
    data['id'] = this.id;
    data['yearMonth'] = this.yearMonth;
    data['account'] = this.account;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['userId'] = this.userId;
    data['createTime'] = this.createTime;
    data['deductedMonths'] = this.deductedMonths;
    data['status'] = this.status;
    return data;
  }
}

class SignatureModel {
  int? id;
  String? signLabel;
  String? signImageUrl;

  SignatureModel({this.id, this.signLabel, this.signImageUrl});

  SignatureModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    signLabel = json['signLabel'];
    signImageUrl = json['signImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['signLabel'] = this.signLabel;
    data['signImageUrl'] = this.signImageUrl;
    return data;
  }
}
