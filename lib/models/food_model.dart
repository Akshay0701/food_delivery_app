

class FoodModel {
  final String description;
  final String discount;
  final String image;
  final String menuId;
  final String name;
  final String price;
  final String keys;

  FoodModel(
      {required this.description,
      required this.discount,
      required this.image,
      required this.menuId,
      required this.name,
      required this.price,
      required this.keys});

  Map toMap(FoodModel food) {
    var data = Map<String, dynamic>();
    data['description'] = food.description;
    data['discount'] = food.discount;
    data['image'] = food.image;
    data['menuId'] = food.menuId;
    data['name'] = food.name;
    data['price'] = food.price;
    data['keys'] = food.keys;
    return data;
  }

  factory FoodModel.fromMap(
    Map<dynamic, dynamic> mapData,
  ) {
    return FoodModel(
      description: mapData['description'],
      discount: mapData['discount'],
      image: mapData['image'],
      menuId: mapData['menuId'],
      name: mapData['name'],
      price: mapData['price'],
      keys: mapData['keys'],
    );
  }
}
