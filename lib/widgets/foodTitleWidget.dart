import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/screens/FoodDetailPage.dart';


class FoodTitleWidget extends StatelessWidget {
  final Food fooddata;
  FoodTitleWidget(this.fooddata);
  @override
  Widget build(BuildContext context) {
    var random = new Random();
    gotoFoodDetails(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>FoodDetailPage(fooddata)));
    }
    return GestureDetector(
      onTap: ()=>gotoFoodDetails(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        child:Row(
          children: [
            Container(
              height: 120.0,
              width: 120.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(fooddata.image,fit: BoxFit.cover,),
              ),
            ),
            SizedBox(width: 10.0,),
            Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              direction: Axis.vertical,
              children: [
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: StrutStyle(fontSize: 20.0),
                    text: TextSpan(
                        style: TextStyle(fontSize: 16.0,color: Colors.black54,fontWeight: FontWeight.bold),
                        text: fooddata.name),
                  ),
                ),
              //  Text(fooddata.name,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.black),),
                Row(
                  children: [
                    SizedBox(height: 10.0,),
                    Icon(Icons.star,color: Colors.orangeAccent,),
                    Text(doubleInRange(random, 3.5, 5.0).toStringAsFixed(1),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orangeAccent),),
                    SizedBox(width: 5.0,),
                    Text("Cafe Western Food",overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black45),),
                  ],
                ),
                Text("${fooddata.price}\$",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold,color: Colors.black54),),
              ],
            )
          ],
        )
      ),
    );
  }

  //we are generating random rating for now
  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;
}
