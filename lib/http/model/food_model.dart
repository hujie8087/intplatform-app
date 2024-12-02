class FoodModel {
  int? id;
  String name;
  String image;
  double price;
  int stock;
  int? num; // 购物车中的数量

  FoodModel({
    this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.stock,
    this.num,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      num: json['num'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'stock': stock,
      'num': num,
    };
  }
}
