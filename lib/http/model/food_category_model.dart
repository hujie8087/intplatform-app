import 'package:logistics_app/http/model/food_model.dart';

class FoodCategoryModel {
  final int id;
  final String name;
  final List<FoodModel> foodCommodityList;

  FoodCategoryModel({
    required this.id,
    required this.name,
    required this.foodCommodityList,
  });

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) {
    var list = json['foodCommodityList'] as List;
    List<FoodModel> foodList = list.map((i) => FoodModel.fromJson(i)).toList();

    return FoodCategoryModel(
      id: json['id'],
      name: json['name'],
      foodCommodityList: foodList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'foodCommodityList': foodCommodityList.map((e) => e.toJson()).toList(),
    };
  }
}
