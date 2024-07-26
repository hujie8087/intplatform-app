class BuildingModel {
  int? id;
  String? title;
  List<BuildingModel>? children;

  BuildingModel({this.id, this.title, this.children});

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    var childrenList = json['children'] as List<dynamic>?;
    List<BuildingModel>? children =
        childrenList?.map((i) => BuildingModel.fromJson(i)).toList();
    return BuildingModel(
      id: json['id'],
      title: json['title'],
      children: children,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'children': children?.map((e) => e.toJson()).toList(),
    };
  }
}
