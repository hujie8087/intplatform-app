class BookModel {
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  String? startQueryTime;
  String? endQueryTime;
  int? id;
  String? code;
  String? bookName;
  String? bookNo;
  String? author;
  String? publisher;
  String? publicationDate;
  String? edition;
  String? size;
  double? discountedPrice;
  double? originalPrice;
  String? museumDate;
  String? typeNo;
  String? rcode;
  String? batch;
  int? status;
  String? delFlag;
  String? deleteBy;
  String? deleteTime;

  BookModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.startQueryTime,
    this.endQueryTime,
    this.id,
    this.code,
    this.bookName,
    this.bookNo,
    this.author,
    this.publisher,
    this.publicationDate,
    this.edition,
    this.size,
    this.discountedPrice,
    this.originalPrice,
    this.museumDate,
    this.typeNo,
    this.rcode,
    this.batch,
    this.status,
    this.delFlag,
    this.deleteBy,
    this.deleteTime,
  });

  BookModel.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    startQueryTime = json['startQueryTime'];
    endQueryTime = json['endQueryTime'];
    id = json['id'];
    code = json['code'];
    bookName = json['bookName'];
    bookNo = json['bookNo'];
    author = json['author'];
    publisher = json['publisher'];
    publicationDate = json['publicationDate'];
    edition = json['edition'];
    size = json['size'];
    discountedPrice = json['discountedPrice'];
    originalPrice = json['originalPrice'];
    museumDate = json['museumDate'];
    typeNo = json['typeNo'];
    rcode = json['rcode'];
    batch = json['batch'];
    status = json['status'];
    delFlag = json['delFlag'];
    deleteBy = json['deleteBy'];
    deleteTime = json['deleteTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['startQueryTime'] = this.startQueryTime;
    data['endQueryTime'] = this.endQueryTime;
    data['id'] = this.id;
    data['code'] = this.code;
    data['bookName'] = this.bookName;
    data['bookNo'] = this.bookNo;
    data['author'] = this.author;
    data['publisher'] = this.publisher;
    data['publicationDate'] = this.publicationDate;
    data['edition'] = this.edition;
    data['size'] = this.size;
    data['discountedPrice'] = this.discountedPrice;
    data['originalPrice'] = this.originalPrice;
    data['museumDate'] = this.museumDate;
    data['typeNo'] = this.typeNo;
    data['rcode'] = this.rcode;
    data['batch'] = this.batch;
    data['status'] = this.status;
    data['delFlag'] = this.delFlag;
    data['deleteBy'] = this.deleteBy;
    data['deleteTime'] = this.deleteTime;
    return data;
  }
}
