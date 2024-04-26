

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_delivery_app/models/category_model.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/request_model.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/resourese/databaseSQL.dart';

class FirebaseHelper {
  // Firebase Database, will use to get reference.
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  static final DatabaseReference _ordersReference =
      _database.reference().child("Orders");
  static final DatabaseReference _categoryReference =
      _database.reference().child("Category");
  static final DatabaseReference _foodReference =
      _database.reference().child("Foods");

  // fetch all foods list from food reference
  Future<List<FoodModel>> fetchAllFood() async {
    List<FoodModel> foodList = <FoodModel>[];
    DatabaseReference foodReference = _database.ref().child("Foods");
    DatabaseEvent event = await foodReference.once();
    event.snapshot.children.forEach((DataSnapshot element) {
      if (element.value is Map) {
        FoodModel food =
            FoodModel.fromMap(element.value as Map<dynamic, dynamic>);
        foodList.add(food);
      }
    });
    return foodList;
  }

  // fetch food list with query string
  Future<List<FoodModel>> fetchSpecifiedFoods(String queryStr) async {
    List<FoodModel> foodList = <FoodModel>[];

    DatabaseReference foodReference = _database.ref().child("Foods");
    DatabaseEvent event = await foodReference.once();
    event.snapshot.children.forEach((DataSnapshot element) {
      if (element.value is Map) {
        FoodModel food =
            FoodModel.fromMap(element.value as Map<dynamic, dynamic>);
        if (food.menuId == queryStr) {
          foodList.add(food);
        }
      }
    });
    return foodList;
  }

  Future<bool> placeOrder(RequestModel request) async {
    await _ordersReference
        .child(request.uid)
        .push()
        .set(request.toMap(request));
    return true;
  }

  Future<List<CategoryModel>> fetchCategory() async {
    List<CategoryModel> categoryList = [];
    DatabaseEvent event = await _categoryReference.once();
    event.snapshot.children.forEach((DataSnapshot element) {
      if (element.value is Map) {
        Map e = element.value as Map<dynamic, dynamic>;
        // TODO: use keyname in lowercase
        CategoryModel category =
            CategoryModel(image: e['Image'], name: e['Name'], keys: e['keys']);
        categoryList.add(category);
      }
    });

    return categoryList;
  }

  Future<List<RequestModel>> fetchOrders(User currentUser) async {
    List<RequestModel> requestList = [];
    DatabaseReference foodReference = _ordersReference.child(currentUser.uid);

    DatabaseEvent event = await foodReference.once();
    event.snapshot.children.forEach((DataSnapshot element) {
      if (element.value is Map) {
        Map e = element.value as Map<dynamic, dynamic>;
        // TODO: can use fromMap() method
        RequestModel request = RequestModel(
            address: e['address'],
            name: e['name'],
            uid: e['uid'],
            status: e['status'],
            total: e['total'],
            foodList: e['foodList']);
        requestList.add(request);
      }
    });

    return requestList;
  }

  Future<void> addOrder(String totalPrice, List<FoodModel> orderedFoodList,
      String name, String address) async {
    // getter user details
    User? user = await AuthMethods().getCurrentUser();
    if (user == null) {
      return;
    }
    String uidtxt = user.uid;
    String statustxt = "0";
    String totaltxt = totalPrice.toString();

    // creating model of list of ordered foods
    Map aux = new Map<String, dynamic>();
    orderedFoodList.forEach((food) {
      aux[food.keys] = food.toMap(food);
    });

    RequestModel request = new RequestModel(
        address: address,
        name: name,
        uid: uidtxt,
        status: statustxt,
        total: totaltxt,
        foodList: aux);

    // add order to database
    await _ordersReference
        .child(request.uid)
        .push()
        .set(request.toMap(request))
        .then((value) async {
      // delete cart data
      DatabaseSql databaseSql = DatabaseSql();
      await databaseSql.openDatabaseSql();
      await databaseSql.deleteAllData();
    });
  }
}
