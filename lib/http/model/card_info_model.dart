class CardInfoModel {
  String? accName;
  String? accNum;
  String? sexNum;
  String? accStatusNum;
  String? cardAccNum;
  String? accType;
  String? campusId;
  String? birthday;
  String? idNo;
  String? idTypeNum;
  String? clsName;
  String? clsNum;
  String? accDepFullPathName;
  String? accDepName;
  String? accDepNum;
  String? email;
  String? joinDate;
  String? disableDate;
  String? phoneNo;
  String? isFreezed;
  String? nativePlace;
  String? zkPerCode;
  String? qq;
  String? rechargeable;
  String? rechargeableAmount;
  String? cardAlias;
  String? cardSid;
  String? cardStatusNum;
  String? balance;
  String? eWalletId;
  String? eWalletName;
  String? idZipPhoto;
  String? faceOriPhoto;
  String? perCode;
  String? mainOrViceNum;
  String? sign;

  CardInfoModel(
      {this.accName,
      this.accNum,
      this.sexNum,
      this.accStatusNum,
      this.cardAccNum,
      this.accType,
      this.campusId,
      this.birthday,
      this.idNo,
      this.idTypeNum,
      this.clsName,
      this.clsNum,
      this.accDepFullPathName,
      this.accDepName,
      this.accDepNum,
      this.email,
      this.joinDate,
      this.disableDate,
      this.phoneNo,
      this.isFreezed,
      this.nativePlace,
      this.zkPerCode,
      this.qq,
      this.rechargeable,
      this.rechargeableAmount,
      this.cardAlias,
      this.cardSid,
      this.cardStatusNum,
      this.balance,
      this.eWalletId,
      this.eWalletName,
      this.idZipPhoto,
      this.faceOriPhoto,
      this.perCode,
      this.mainOrViceNum,
      this.sign});

  CardInfoModel.fromJson(Map<String, dynamic> json) {
    accName = json['accName'];
    accNum = json['accNum'];
    sexNum = json['sexNum'];
    accStatusNum = json['accStatusNum'];
    cardAccNum = json['cardAccNum'];
    accType = json['accType'];
    campusId = json['campusId'];
    birthday = json['birthday'];
    idNo = json['idNo'];
    idTypeNum = json['idTypeNum'];
    clsName = json['clsName'];
    clsNum = json['clsNum'];
    accDepFullPathName = json['accDepFullPathName'];
    accDepName = json['accDepName'];
    accDepNum = json['accDepNum'];
    email = json['email'];
    joinDate = json['joinDate'];
    disableDate = json['disableDate'];
    phoneNo = json['phoneNo'];
    isFreezed = json['isFreezed'];
    nativePlace = json['nativePlace'];
    zkPerCode = json['zkPerCode'];
    qq = json['qq'];
    rechargeable = json['rechargeable'];
    rechargeableAmount = json['rechargeableAmount'];
    cardAlias = json['cardAlias'];
    cardSid = json['cardSid'];
    cardStatusNum = json['cardStatusNum'];
    balance = json['balance'];
    eWalletId = json['eWalletId'];
    eWalletName = json['eWalletName'];
    idZipPhoto = json['idZipPhoto'];
    faceOriPhoto = json['faceOriPhoto'];
    perCode = json['perCode'];
    mainOrViceNum = json['mainOrViceNum'];
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accName'] = this.accName;
    data['accNum'] = this.accNum;
    data['sexNum'] = this.sexNum;
    data['accStatusNum'] = this.accStatusNum;
    data['cardAccNum'] = this.cardAccNum;
    data['accType'] = this.accType;
    data['campusId'] = this.campusId;
    data['birthday'] = this.birthday;
    data['idNo'] = this.idNo;
    data['idTypeNum'] = this.idTypeNum;
    data['clsName'] = this.clsName;
    data['clsNum'] = this.clsNum;
    data['accDepFullPathName'] = this.accDepFullPathName;
    data['accDepName'] = this.accDepName;
    data['accDepNum'] = this.accDepNum;
    data['email'] = this.email;
    data['joinDate'] = this.joinDate;
    data['disableDate'] = this.disableDate;
    data['phoneNo'] = this.phoneNo;
    data['isFreezed'] = this.isFreezed;
    data['nativePlace'] = this.nativePlace;
    data['zkPerCode'] = this.zkPerCode;
    data['qq'] = this.qq;
    data['rechargeable'] = this.rechargeable;
    data['rechargeableAmount'] = this.rechargeableAmount;
    data['cardAlias'] = this.cardAlias;
    data['cardSid'] = this.cardSid;
    data['cardStatusNum'] = this.cardStatusNum;
    data['balance'] = this.balance;
    data['eWalletId'] = this.eWalletId;
    data['eWalletName'] = this.eWalletName;
    data['idZipPhoto'] = this.idZipPhoto;
    data['faceOriPhoto'] = this.faceOriPhoto;
    data['perCode'] = this.perCode;
    data['mainOrViceNum'] = this.mainOrViceNum;
    data['sign'] = this.sign;
    return data;
  }
}

class BillModel {
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

  BillModel(
      {this.recNum,
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
      this.payWay});

  BillModel.fromJson(Map<String, dynamic> json) {
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
