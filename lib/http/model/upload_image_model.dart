/// name : ''
/// url : 720
class UploadImageModel {
  List<ImageModel>? data;
  int? code;
  String? msg;

  UploadImageModel.fromJson(dynamic json) {
    var list = json['data'] as List;
    List<ImageModel> rowsList =
        list.map((i) => ImageModel.fromJson(i)).toList();
    data = rowsList;
    code = json['code'];
    msg = json['msg'];
  }
}

///用户数据返回
class ImageModel {
  ImageModel({
    this.name,
    this.url,
  });

  ImageModel.fromJson(Map<String, dynamic>? json) {
    name = json?['name'];
    url = json?['url'];
  }

  String? name;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['url'] = url;
    return map;
  }
}
