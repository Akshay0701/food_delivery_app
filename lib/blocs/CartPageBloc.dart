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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/models/Request.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/resourese/databaseSQL.dart';
import 'package:food_delivery_app/screens/homepage.dart';

class CartPageBloc with ChangeNotifier {
  
  AuthMethods mAuthMethods = AuthMethods();
  
  List<Food> foodList=[];
  int totalPrice = 0;
  DatabaseSql databaseSql;

  BuildContext context;

  getDatabaseValue() async{
    databaseSql=DatabaseSql();
    await databaseSql.openDatabaseSql();
    foodList= await databaseSql.getData();
    //calculating total price
    foodList.forEach((food) {
      int foodItemPrice = int.parse(food.price);
      totalPrice += foodItemPrice;
    });
    notifyListeners();
  }


   // ignore: non_constant_identifier_names
  orderPlaceToFirebase(String name, String address)async{
    //getter user details
    FirebaseUser user = await mAuthMethods.getCurrentUser();
    String uidtxt =user.uid;
    String statustxt="0";
    String totaltxt = totalPrice.toString();
    //creating model

    Map aux = new Map<String,dynamic>();
    foodList.forEach((food){
      //Here you can set the key of the map to whatever you like
      aux[food.keys] = food.toMap(food);
    });

    Request request =Request(
      address:address,
      name:name,
      uid:uidtxt,
      status:statustxt,
      total:totaltxt,
      foodList:aux
    );

    //add order 
    DatabaseReference ordersReference=FirebaseDatabase.instance.reference().child("Orders");
    await ordersReference.child(request.uid).push().set(request.toMap(request)).then((value) async {
      // delete cart data 
      DatabaseSql databaseSql = DatabaseSql();
      await databaseSql.openDatabaseSql();
      bool isDeleted =await databaseSql.deleteAllData();
      if (isDeleted) {
        notifyListeners();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => HomePage()));
      }
    });

  }
}