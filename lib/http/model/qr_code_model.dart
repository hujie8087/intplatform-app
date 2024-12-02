class QrCodeModel {
  String? qrCode;
  String? sign;

  QrCodeModel({this.qrCode, this.sign});

  QrCodeModel.fromJson(Map<String, dynamic> json) {
    qrCode = json['qrCode'];
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qrCode'] = this.qrCode;
    data['sign'] = this.sign;
    return data;
  }
}
