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

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_delivery_app/blocs/SearchPageBloc.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:food_delivery_app/widgets/foodTitleWidget.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchPageBloc(),
      child: SearchPageContent()
    );
  }
}

class SearchPageContent extends StatefulWidget {
  @override
  _SearchPageContentState createState() => _SearchPageContentState();
}

class _SearchPageContentState extends State<SearchPageContent> {
  final TextEditingController searchCtrl = TextEditingController();
  SearchPageBloc searchPageBloc;

 @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      searchPageBloc.loadFoodList();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    searchPageBloc = Provider.of<SearchPageBloc>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: UniversalVariables.whiteLightColor,
      ),
     body: SafeArea(
       child: Container(
         child: Column(
           children: [
             createSearchBar(),
             Expanded(
               child: Container(
                color: Colors.white10,
                 child: buildSuggestions(searchPageBloc.query),
               ),
             )
           ],
         ),
       ),
     ),
    );
  }

  buildSuggestions(String query){
     final List<Food> suggestionList = searchPageBloc.searchFoodsFromList(query);
     return  Container(
         child: suggestionList.length == -1 ? Center(child: Center(child: CircularProgressIndicator()))
             : ListView.builder(
             scrollDirection: Axis.vertical,
             itemCount: suggestionList.length,
             itemBuilder: (_,index){
               return FoodTitleWidget(
                 searchPageBloc.searchedFoodList[index],
               );
             }
         ),
     );
 }


  createSearchBar(){
    return Container(
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color:  UniversalVariables.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              onChanged: (search) {
                searchPageBloc.setQuery(search);
              },
              controller: searchCtrl,
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 15),
                  hintText: "Search..."),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(icon: Icon(Icons.search,color:  UniversalVariables.orangeColor,), onPressed:()=> null),
          ),
        ],
      ),
    );
  }
}
