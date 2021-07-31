import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/resourese/databaseSQL.dart';

class FoodDetailPageBloc with ChangeNotifier {
  AuthMethods mAuthMethods = AuthMethods();

  List<Food> foodList=[];

  // I dont implemented rating system, so just for good UI showing random value of rates from 0.00 to 5.00
  // I been lazy here.
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
    mAuthMethods.fetchSpecifiedFoods("06").then((List<Food> list){
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