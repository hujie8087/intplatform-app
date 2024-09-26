class FoodModel {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String code;
  final String image;

  FoodModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.code,
    required this.image,
  });

  // Factory constructor to create a FoodModel object from JSON
  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(), // Cast price to double
      stock: json['stock'],
      code: json['code'],
      image: json['image'],
    );
  }
}

class FoodCategoryModel {
  final int id;
  final String name;
  final List<FoodModel> foodCommodityList;

  FoodCategoryModel({
    required this.id,
    required this.name,
    required this.foodCommodityList,
  });

  // Factory constructor to create a Category object from JSON
  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) {
    return FoodCategoryModel(
      id: json['id'],
      name: json['name'],
      foodCommodityList: (json['foodCommodityList'] as List)
          .map((item) => FoodModel.fromJson(item))
          .toList(),
    );
  }
}
