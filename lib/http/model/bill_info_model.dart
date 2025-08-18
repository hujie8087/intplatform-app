class BillInfoModel {
  String? recNum;
  String? accName;
  String? accNum;
  String? accAreaNum;
  String? payAreaNum;
  String? deviceName;
  String? deviceNum;
  String? terminalNum;
  String? staSid;
  String? terSid;
  String? businessName;
  String? businessNum;
  String? dealTime;
  String? uploadTime;
  String? depName;
  String? eWalletName;
  String? eWalletId;
  String? feeName;
  String? feeNum;
  String? monCard;
  String? monDb;
  String? monDeal;
  String? monDiscount;
  String? optNum;
  String? perCode;
  String? payWay;

  BillInfoModel({
    this.recNum,
    this.accName,
    this.accNum,
    this.accAreaNum,
    this.payAreaNum,
    this.deviceName,
    this.deviceNum,
    this.terminalNum,
    this.staSid,
    this.terSid,
    this.businessName,
    this.businessNum,
    this.dealTime,
    this.uploadTime,
    this.depName,
    this.eWalletName,
    this.eWalletId,
    this.feeName,
    this.feeNum,
    this.monCard,
    this.monDb,
    this.monDeal,
    this.monDiscount,
    this.optNum,
    this.perCode,
    this.payWay,
  });

  BillInfoModel.fromJson(Map<String, dynamic> json) {
    recNum = json['recNum'];
    accName = json['accName'];
    accNum = json['accNum'];
    accAreaNum = json['accAreaNum'];
    payAreaNum = json['payAreaNum'];
    deviceName = json['deviceName'];
    deviceNum = json['deviceNum'];
    terminalNum = json['terminalNum'];
    staSid = json['staSid'];
    terSid = json['terSid'];
    businessName = json['businessName'];
    businessNum = json['businessNum'];
    dealTime = json['dealTime'];
    uploadTime = json['uploadTime'];
    depName = json['depName'];
    eWalletName = json['eWalletName'];
    eWalletId = json['eWalletId'];
    feeName = json['feeName'];
    feeNum = json['feeNum'];
    monCard = json['monCard'];
    monDb = json['monDb'];
    monDeal = json['monDeal'];
    monDiscount = json['monDiscount'];
    optNum = json['optNum'];
    perCode = json['perCode'];
    payWay = json['payWay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recNum'] = this.recNum;
    data['accName'] = this.accName;
    data['accNum'] = this.accNum;
    data['accAreaNum'] = this.accAreaNum;
    data['payAreaNum'] = this.payAreaNum;
    data['deviceName'] = this.deviceName;
    data['deviceNum'] = this.deviceNum;
    data['terminalNum'] = this.terminalNum;
    data['staSid'] = this.staSid;
    data['terSid'] = this.terSid;
    data['businessName'] = this.businessName;
    data['businessNum'] = this.businessNum;
    data['dealTime'] = this.dealTime;
    data['uploadTime'] = this.uploadTime;
    data['depName'] = this.depName;
    data['eWalletName'] = this.eWalletName;
    data['eWalletId'] = this.eWalletId;
    data['feeName'] = this.feeName;
    data['feeNum'] = this.feeNum;
    data['monCard'] = this.monCard;
    data['monDb'] = this.monDb;
    data['monDeal'] = this.monDeal;
    data['monDiscount'] = this.monDiscount;
    data['optNum'] = this.optNum;
    data['perCode'] = this.perCode;
    data['payWay'] = this.payWay;
    return data;
  }
}
