import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Category.dart';
import 'package:food_delivery_app/screens/CategoryListPage.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;
  CategoryWidget(this.category);


  @override
  Widget build(BuildContext context) {

    gotoCategoryList(){
      Navigator.push(context, MaterialPageRoute(builder:(context)=>CategoryListPage(category)));
    }

    return GestureDetector(
      onTap: ()=>gotoCategoryList(),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.0, 0.0,0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Container(
                 height: 200.0,
                 child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(category.image,fit: BoxFit.cover,),
                  ),
               ),
            Text(category.name,style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.black),),
            Row(
              children: [
                SizedBox(height: 10.0,),
                Icon(Icons.star,color: UniversalVariables.orangeAccentColor,),
                Text("4.0",style: TextStyle(fontWeight: FontWeight.bold,color:  UniversalVariables.orangeAccentColor),),
                SizedBox(width: 5.0,),
                Text("Cafe Western Food",style: TextStyle(color: Colors.black45),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

