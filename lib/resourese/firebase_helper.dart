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

 Future<List<Category>> fetchCategory()async{

   List<Category> categoryList=[];
   _categoryReference.once().then((DataSnapshot snap) {
     var KEYS = snap.value.keys;
     var DATA = snap.value;

     categoryList.clear();
     for(var individualKey in KEYS){
       Category posts= new Category(
         image: DATA[individualKey]['Image'],
         name: DATA[individualKey]['Name'],
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
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      requestList.clear();
      for (var individualKey in KEYS) {
        Request request =Request(
          address: DATA[individualKey]['address'],
          name:DATA[individualKey]['name'],
          uid:DATA[individualKey]['uid'],
          status:DATA[individualKey]['status'],
          total:DATA[individualKey]['total'],
          foodList:DATA[individualKey]['foodList'],
        );
        requestList.add(request);
      }

    });
    return requestList;
  }
}