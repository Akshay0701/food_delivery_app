import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/screens/FoodDetailPage.dart';
import 'package:food_delivery_app/utils/UniversalVariables.dart';


class FoodTitleWidget extends StatelessWidget {
  final Food foodData;
  FoodTitleWidget(this.foodData);
  
  @override
  Widget build(BuildContext context) {
    var random = Random();
    goToFoodDetails() {
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>FoodDetailPage(foodData)));
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => FoodDetailPage(food: foodData)
        )
      );
    }
    return GestureDetector(
      onTap: () => goToFoodDetails(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        child: Row(
          children: [
            Container(
              height: 120.0,
              width: 120.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Hero(tag: 'avatar_${foodData.keys.toString()}',
                child: Image.network(foodData.image, fit: BoxFit.cover))
              )
            ),
            SizedBox(width: 10.0),
            Wrap(
              spacing: 20.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              direction: Axis.vertical,
              children: [
                Text('${foodData.name}\$', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black54)),
                Row(
                  children: [
                    SizedBox(height: 10.0),
                    Icon(Icons.star, color:  UniversalVariables.orangeAccentColor,),
                    Text(doubleInRange(random, 3.5, 5.0).toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.bold, color: UniversalVariables.orangeAccentColor)),
                    SizedBox(width: 5.0),
                    Text('Cafe Western Food', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45))
                  ]
                ),
                Text('${foodData.price}\$', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black54))
              ]
            )
          ]
        )
      )
    );
  }

  //we are generating random rating for now
  double doubleInRange(Random source, num start, num end) => source.nextDouble() * (end - start) + start;
}
