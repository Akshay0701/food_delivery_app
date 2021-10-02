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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery_app/blocs/FoodDetailPageBloc.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:food_delivery_app/widgets/foodTitleWidget.dart';
import 'package:provider/provider.dart';

class FoodDetailPage extends StatelessWidget {
  final Food food;
  FoodDetailPage({this.food});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FoodDetailPageBloc(),
      child: FoodDetailPageContent(food,)
    );
  }
}

class FoodDetailPageContent extends StatefulWidget {
  final Food fooddata;
  FoodDetailPageContent(this.fooddata);
  @override
  _FoodDetailPageContentState createState() => _FoodDetailPageContentState();
}

class _FoodDetailPageContentState extends State<FoodDetailPageContent> {
  
  FoodDetailPageBloc foodDetailPageBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // sample discription for food details
  String sampleDescription = "The existence of the Positioned forces the Container to the left, instead of centering. Removing the Positioned, however, puts the Container in the middle-center";


  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      foodDetailPageBloc.getPopularFoodList();
      foodDetailPageBloc.generateRandomRating();
    });
  
  }

  @override
  Widget build(BuildContext context) {
    foodDetailPageBloc = Provider.of<FoodDetailPageBloc>(context);
    foodDetailPageBloc.context = context;
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color:  UniversalVariables.whiteColor,
        ),
        backgroundColor: Colors.transparent,
      ),
      body:SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
                Hero(tag:"avatar_${widget.fooddata.keys.toString()}",
                child: Container(
                padding: EdgeInsets.all(0.0),
                child: Stack(
                  children: [
                   Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(80.0)
                          ),
                          gradient: LinearGradient(colors: [Colors.black45,Colors.transparent],begin: Alignment.bottomCenter,end: Alignment.topCenter
                          ),),
                        ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(color:Colors.transparent, 
                              child: Text(foodDetailPageBloc.rating + " ★", style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: UniversalVariables.whiteColor),)
                            ),
                    ),
                  ],),
                alignment: Alignment.bottomLeft,
                height: MediaQuery.of(context).size.height*0.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(80.0)
                  ),
                  image:DecorationImage(image: NetworkImage(widget.fooddata.image),fit: BoxFit.cover),
                ),
              )),
              createdetails(),
              createPopularFoodList(),
            ],
          ),
        ),
      )
    );
  }

  createdetails(){
    return  Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 10.0,),
          Text(widget.fooddata.name,style: TextStyle(fontSize: 27.0,fontWeight: FontWeight.bold,color: UniversalVariables.orangeColor),),
          SizedBox(height: 20.0,),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:18.0,top: 10.0,bottom: 10.0),
                child: Text("₹" + widget.fooddata.price,style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color:UniversalVariables.orangeColor),),
              ),
              SizedBox(width: 10.0,),
              // widget of counter
              Container(
                margin: EdgeInsets.only(right: 18.0),
                decoration: BoxDecoration(
                  color: UniversalVariables.orangeColor,
                  borderRadius: BorderRadius.all(Radius.circular(50.0))
                ),
                child: Row(
                  children: <Widget>[
                    // check and show decreament button
                    foodDetailPageBloc.mItemCount != 1 ? 
                    new  IconButton(icon: new Icon(Icons.remove,color: UniversalVariables.whiteColor,size: 30.0,), onPressed: ()=> foodDetailPageBloc.decreamentItems(),)
                    :new  IconButton(icon: new Icon(Icons.remove,color: Colors.white,size: 30.0,),onPressed: ()=>null),
                    new Text(foodDetailPageBloc.mItemCount.toString(),style: TextStyle(color:  UniversalVariables.whiteColor,fontSize: 20.0,fontWeight: FontWeight.bold),),
                    new IconButton(icon: new Icon(Icons.add,color:  UniversalVariables.whiteColor,size: 30.0,),onPressed: ()=> foodDetailPageBloc.increamentItems())
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0,),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(sampleDescription,style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.black38),)
          ),
          SizedBox(height: 30.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0),
            child: RatingBar(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: UniversalVariables.amberColor,
              ),
              onRatingUpdate: (rating) {
                // do nothing XD
              },
            ),
          ),
          SizedBox(height: 30.0,),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(UniversalVariables.orangeColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),)
                ),
              ),
              onPressed: () => foodDetailPageBloc.addToCart(widget.fooddata),
              child: Text("Add To Cart",style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.w500,color: UniversalVariables.whiteColor),),
            ),
          ),
          SizedBox(height: 20.0,),
        ],
      ),
    );
  }

  createPopularFoodList(){
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Text("Popular Food ",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.black45),),
          ),
          SizedBox(height: 10.0,),
          Container(
              height: 200.0,
              child:foodDetailPageBloc.foodList.length==-1 ? Center(child: Center(child: CircularProgressIndicator()))
              : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foodDetailPageBloc.foodList.length,
              itemBuilder: (_,index){
                return FoodTitleWidget(
                  foodDetailPageBloc.foodList[index],
                 );
               }
             ),
          ),
        ],
      ),
    );
  }
}

