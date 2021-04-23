/*
 * Copyright (c) 2021 Akshay Jadhav <jadhavakshay0701@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_delivery_app/models/Category.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/models/Request.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/resourese/databaseSQL.dart';

class FirebaseHelper{

  // Firebase Database, will use to get reference.
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  static final DatabaseReference _ordersReference = _database.reference().child("Orders");
  static final DatabaseReference _categoryReference = _database.reference().child("Category");
  static final DatabaseReference _foodReference = _database.reference().child("Foods");

  // fetch all foods list from food reference
  Future<List<Food>> fetchAllFood() async {
    List<Food>foodList = <Food>[];
    DatabaseReference foodReference= _database.reference().child("Foods");
    await foodReference.once().then((DataSnapshot snap) {
        var keys = snap.value.keys;
        var data = snap.value;
        foodList.clear();
        for(var individualKey in keys){
          Food food = new Food(
              description: data[individualKey]['description'],
              discount: data[individualKey]['discount'],
              image:data[individualKey]['image'],
              menuId:data[individualKey]['menuId'],
              name:data[individualKey]['name'],
              price:data[individualKey]['price'],
              keys: individualKey.toString()
          );
          foodList.add(food);
        }
      });
      return foodList;
  }

  // fetch food list with query string 
  Future<List<Food>> fetchSpecifiedFoods(String queryStr) async {
    List<Food>foodList = <Food>[];
    
    await _foodReference.once().then((DataSnapshot snap) {
        var keys = snap.value.keys;
        var data = snap.value;
        foodList.clear();
        for(var individualKey in keys){
          Food food = new Food(
              description: data[individualKey]['description'],
              discount: data[individualKey]['discount'],
              image: data[individualKey]['image'],
              menuId: data[individualKey]['menuId'],
              name: data[individualKey]['name'],
              price: data[individualKey]['price'],
              keys: individualKey.toString()
          );
          if(food.menuId == queryStr){
            foodList.add(food);
          }
        }
      });
      return foodList;
  }


  Future<bool> placeOrder(Request request)async{
    await _ordersReference.child(request.uid).push().set(request.toMap(request));
    return true;
  }

 Future<List<Category>> fetchCategory() async {
   List<Category> categoryList=[];
   await _categoryReference.once().then((DataSnapshot snap) {
     var keys = snap.value.keys;
     var data = snap.value;

     categoryList.clear();
     for(var individualKey in keys){
       Category posts= new Category(
         image: data[individualKey]['Image'],
         name: data[individualKey]['Name'],
         keys:individualKey.toString(),
       );
       categoryList.add(posts);
     }
   });
   return categoryList;
 }

  Future<List<Request>> fetchOrders(FirebaseUser currentUser)async{
    List<Request> requestList=[];
    DatabaseReference foodReference = _ordersReference.child(currentUser.uid);

    await foodReference.once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;

      requestList.clear();
      for (var individualKey in keys) {
        Request request =Request(
          address:data[individualKey]['address'],
          name:data[individualKey]['name'],
          uid:data[individualKey]['uid'],
          status:data[individualKey]['status'],
          total:data[individualKey]['total'],
          foodList:data[individualKey]['foodList'],
        );
        requestList.add(request);
      }

    });
    return requestList;
  }

  Future<void> addOrder(String totalPrice, List<Food> orderedFoodList, String name, String address) async {
    // getter user details
    FirebaseUser user = await AuthMethods().getCurrentUser();
    String uidtxt = user.uid;
    String statustxt = "0";
    String totaltxt = totalPrice.toString();

    // creating model of list of ordered foods
    Map aux = new Map<String,dynamic>();
    orderedFoodList.forEach((food){
      aux[food.keys] = food.toMap(food);
    });

    Request request = new Request(
      address:address,
      name:name,
      uid:uidtxt,
      status:statustxt,
      total:totaltxt,
      foodList:aux
    );

    // add order to database
    await _ordersReference.child(request.uid).push().set(request.toMap(request)).then((value) async {
      // delete cart data 
      DatabaseSql databaseSql = DatabaseSql();
      await databaseSql.openDatabaseSql();
      await databaseSql.deleteAllData();
    });
  }
}