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
import 'package:food_delivery_app/models/User.dart';

class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseReference ordersReference=FirebaseDatabase.instance.reference().child("Orders");

  static final DatabaseReference _userReference = _database.reference().child(
      "Users");
  static final DatabaseReference _categoryReference = _database.reference()
      .child("Category");

  //current user getter
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  //sign in
  Future<FirebaseUser> handleSignInEmail(String email, String password) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    // final FirebaseUser user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print('signInEmail succeeded: $user');

    return user;
  }

  Future<FirebaseUser> handleSignUp(phone, email, password) async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
//    user = result.user;

    assert (user != null);
    assert (await user.getIdToken() != null);
    //enter data to firebase
    return user;
  }

  //add user data to firebase
  Future<void> addDataToDb(FirebaseUser currentUser, String username,
      String Phone, String Password) async {
    User user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        phone: Phone,
        password: Password
    );

    _userReference
        .child(currentUser.uid)
        .set(user.toMap(user));
  }


  Future<List<Food>> fetchAllFood() async {
    List<Food>foodList=List<Food>();
    //getting food list
    DatabaseReference foodReference=FirebaseDatabase.instance.reference().child("Foods");
   await foodReference.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var KEYS=snap.value.keys;
      // ignore: non_constant_identifier_names
      var DATA=snap.value;

      foodList.clear();
      for(var individualKey in KEYS){
        Food food= new Food(
            description: DATA[individualKey]['description'],
            discount: DATA[individualKey]['discount'],
            image:DATA[individualKey]['image'],
            menuId:DATA[individualKey]['menuId'],
            name:DATA[individualKey]['name'],
            price:DATA[individualKey]['price'],
            keys: individualKey.toString()
        );
          foodList.add(food);
      }
    });
    return foodList;
  }


  // ignore: non_constant_identifier_names
  Future<List<Food>> fetchSpecifiedFoods(String str) async {
    List<Food>foodList=List<Food>();
    //getting food list
     DatabaseReference foodReference=FirebaseDatabase.instance.reference().child("Foods");
   await foodReference.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var KEYS=snap.value.keys;
      // ignore: non_constant_identifier_names
      var DATA=snap.value;

      foodList.clear();
      for(var individualKey in KEYS){
        Food food= new Food(
            description: DATA[individualKey]['description'],
            discount: DATA[individualKey]['discount'],
            image:DATA[individualKey]['image'],
            menuId:DATA[individualKey]['menuId'],
            name:DATA[individualKey]['name'],
            price:DATA[individualKey]['price'],
            keys: individualKey.toString()
        );
        if(food.menuId==str){
          foodList.add(food);
        }
      }
//      setState(() {
//        print("data");
//      });
    });
      return foodList;
  }


  Future<bool> PlaceOrder(Request request)async{
    await ordersReference.child(request.uid).push().set(request.toMap(request));
    return true;
  }

 Future<List<Category>> fetchCategory()async{

   List<Category> categoryList=[];
   _categoryReference.once().then((DataSnapshot snap) {
     // ignore: non_constant_identifier_names
     var KEYS=snap.value.keys;
     // ignore: non_constant_identifier_names
     var DATA=snap.value;

     categoryList.clear();
     for(var individualKey in KEYS){
       Category posts= new Category(
         image: DATA[individualKey]['Image'],
         name:DATA[individualKey]['Name'],
         keys:individualKey.toString(),
       );
       categoryList.add(posts);
     }

   });
   return categoryList;
 }

 //get order from orders database


  Future<List<Request>> fetchOrders(FirebaseUser currentUser)async{

    List<Request> requestList=[];
    DatabaseReference foodReference = FirebaseDatabase.instance.reference()
        .child("Orders")
        .child(currentUser.uid);

    await foodReference.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var KEYS = snap.value.keys;
      // ignore: non_constant_identifier_names
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