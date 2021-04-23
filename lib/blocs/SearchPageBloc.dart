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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/resourese/firebase_helper.dart';

class SearchPageBloc with ChangeNotifier {

  FirebaseHelper mFirebaseHelper = FirebaseHelper();

  List<Food> searchedFoodList = [];

  // searched text by user
  String query = "";

  List<Food> searchFoodsFromList(String query){
     final List<Food> suggestionList = query.isEmpty
         ?searchedFoodList // show all foods
         :searchedFoodList.where((Food food) {
           String _foodName= food.name.toLowerCase();
           String _query=query.toLowerCase();

           bool isMatch=_foodName.contains(_query);
           return (isMatch);
          }).toList();
    return suggestionList;
  }

  void loadFoodList() {
    mFirebaseHelper.fetchAllFood().then((List<Food> foods) {
      searchedFoodList = foods;
      notifyListeners();
    });
  }

  setQuery(String q) {
    query = q;
    notifyListeners();
  }
}