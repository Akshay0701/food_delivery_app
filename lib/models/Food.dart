class Food{
  String description;
  String discount;
  String image;
  String menuId;
  String name;
  String price;
  String keys;


  Food({
    this.description,
    this.discount,
    this.image,
    this.menuId,
    this.name,
    this.price,
    this.keys
  });

  Map toMap(Food food) {
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

  Food.fromMap(Map<dynamic, dynamic> mapData) {
    this.description =mapData['description'];
    this.discount=mapData['discount'];
    this.image=mapData['image'];
    this.menuId=mapData['menuId'];
    this.name=mapData['name'];
    this.price=mapData['price'];
    this.keys=mapData['keys'];
  }


}