import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';

class SearchPageBloc with ChangeNotifier {
  final AuthMethods authMethods = AuthMethods();

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
    authMethods.fetchAllFood().then((List<Food> foods) {
      searchedFoodList = foods;
      notifyListeners();
    });
  }

  setQuery(String q) {
    query = q;
    notifyListeners();
  }
}