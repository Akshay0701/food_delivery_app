import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/resourese/firebase_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoPageBloc with ChangeNotifier {
  // youtube api AIzaSyDgH9Oz5tCLAcrv2rcR0To9zy38i6pDA0Y
  List<Map<String, dynamic>> searchResults = [];

  FirebaseHelper mFirebaseHelper = FirebaseHelper();

  List<FoodModel> searchedFoodList = [];

  // searched text by user
  String query = "video";



  Future<void> searchVideos(String query) async {
    final String apiKey = 'AIzaSyDgH9Oz5tCLAcrv2rcR0To9zy38i6pDA0Y';
    final String apiUrl =
        'https://www.googleapis.com/youtube/v3/search?key=$apiKey&q=$query&type=video';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> videos = data['items'];
      print(videos);
      searchResults = videos
            .map((video) => {
          'id': video['id']['videoId'],
        }).toList();
     notifyListeners();
    } else {
      throw Exception('Failed to load videos');
    }
  }


  setQuery(String q) {
    query = q;
    notifyListeners();
  }
}
