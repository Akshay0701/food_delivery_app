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

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/resourese/databaseSQL.dart';
import 'package:food_delivery_app/resourese/firebase_helper.dart';

class FoodDetailPageBloc with ChangeNotifier {
  
  AuthMethods mAuthMethods = AuthMethods();
  FirebaseHelper mFirebaseHelper = FirebaseHelper();

  List<Food> foodList=[];

  // I dont implemented rating system,
  // so just for good UI, i am showing random value of rates from 0.00 to 5.00,
  // I been lazy here XD.
  var random = new Random();
  String rating = "1.00"; 

  // no of items add to list
  int mItemCount = 1;

  BuildContext context;

  addToCart(Food food) async{
      DatabaseSql databaseSql=DatabaseSql();
      await databaseSql.openDatabaseSql();
      await databaseSql.insertData(food);
      await databaseSql.getData();
      final snackBar = SnackBar(
        content: Text('Food Added To Cart'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      mItemCount = 1;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      notifyListeners();
      
  }

  getPopularFoodList() {
    // setted 06 id category as popular.
    mFirebaseHelper.fetchSpecifiedFoods("06").then((List<Food> list){
        foodList = list;
        notifyListeners();
    });
  }

  void increamentItems() {
    mItemCount++;
    notifyListeners();
  }

  void decreamentItems() {
    mItemCount--;
    notifyListeners();
  }

  void generateRandomRating() {
    rating = doubleInRange(random, 3.5, 5.0).toStringAsFixed(1);
  }

  double doubleInRange(Random source, num start, num end) =>source.nextDouble() * (end - start) + start;
}