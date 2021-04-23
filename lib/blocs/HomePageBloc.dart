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
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Food.dart';

import 'package:food_delivery_app/models/Category.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/resourese/firebase_helper.dart';

class HomePageBloc with ChangeNotifier {

  FirebaseHelper mFirebaseHelper = FirebaseHelper();
  AuthMethods mAuthMethods = AuthMethods();

  List<Category> categoryList = [];
  List<Food> foodList = [];
  List<Food> popularFoodList = [];
  List<Food> bannerFoodList = [];
  
  //for sliding view 
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];


  //for recently added food
  Category recentlyCategory = Category(image:"https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",name: "burger",keys: "08");
  Category recentlyCategory2 = Category(image:"https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/216054.jpg",name: "Pizza",keys: "04");
  Category recentlyCategory3 = Category(image:"https://static.toiimg.com/thumb/54659021.cms?width=1200&height=1200",name: "french fries",keys: "07");
  Category recentlyCategory4 = Category(image:"https://i.pinimg.com/originals/3b/b4/ea/3bb4ea708b73c60a11ccd4a7bdbb1524.jpg",name: "kfc chicken",keys: "09");

  FirebaseUser mFirebaseUser;

  getCurrentUser() {
    mAuthMethods.getCurrentUser().then((FirebaseUser currentUser)  {
      mFirebaseUser = currentUser;
      notifyListeners();
    });
  }

  getCategoryFoodList() {
    categoryList.clear();
    mFirebaseHelper.fetchCategory().then((List<Category> cList) {
      categoryList = cList;
      notifyListeners();
    });
  }

  getRecommendedFoodList() {
    mFirebaseHelper.fetchAllFood().then((List<Food> fList) {
      fList.forEach((Food food) {
        // we are fetching 3 types of foods who's menu id is 05 03 and 07.
        if(food.menuId=="05"){
          popularFoodList.add(food);
        }
        else if(food.menuId=="03"){
          foodList.add(food);
        }
        else if(food.menuId=="07"){
          bannerFoodList.add(food);
        }
        notifyListeners();
      });
    });
  }

}