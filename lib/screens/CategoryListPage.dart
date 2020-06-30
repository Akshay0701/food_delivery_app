import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Category.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/widgets/foodTitleWidget.dart';


class CategoryListPage extends StatefulWidget {
  final Category category;
  CategoryListPage(this.category);
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {

  List<Food> foodList=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getting food list
    DatabaseReference foodReference=FirebaseDatabase.instance.reference().child("Foods");
    foodReference.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var KEYS=snap.value.keys;
      // ignore: non_constant_identifier_names
      var DATA=snap.value;

      foodList.clear();
      for(var individualKey in KEYS){
        Food food= new Food(
            description: DATA[individualKey]['description'],
            discount: DATA[individualKey]['discount'],
            image:DATA[individualKey]['image'],
            menuId:DATA[individualKey]['menuId'],
            name:DATA[individualKey]['name'],
            price:DATA[individualKey]['price'],
            keys: individualKey.toString()
        );
        if(food.menuId==widget.category.keys){
          foodList.add(food);
        }
      }
      setState(() {
        print("data");
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
//      appBar: AppBar(
//        elevation: 0.0,
//        iconTheme: IconThemeData(
//            color: Colors.white,
//        ),
//        backgroundColor: Colors.transparent,
////        title: Text("",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//      ),
      body: SingleChildScrollView(
        child:
           Column(
            children: [
              Container(
                  alignment: Alignment.bottomLeft,
                  height: MediaQuery.of(context).size.height*0.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(80.0)
                    ),
                    image:DecorationImage(image: NetworkImage(widget.category.image),fit: BoxFit.cover),
                  ),
                  child: Stack(
                    children: [
                      Container(height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(80.0)
                          ),
                          gradient: LinearGradient(colors: [Colors.black45,Colors.transparent],begin: Alignment.bottomCenter,end: Alignment.topCenter
                          ),),),
                      Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.category.name,style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.bold,color: Colors.white),),
                    ),
                  ],),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("12 restaurants",style: TextStyle(color: Colors.black45),),
                        IconButton(
                          icon: Icon(Icons.menu,color: Colors.orange,),
                          onPressed: ()=>null,
                        )
                      ],
                    ),
                     createFoodList(),
                  ],
                ),
              )
            ],
          ),
      ),
    );
  }
  createFoodList(){
    return Container(
      height: MediaQuery.of(context).size.height,
      child: foodList.length==-1 ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: foodList.length,
          itemBuilder: (_,index){
            return FoodTitleWidget(
              foodList[index],
            );
          }
      ),
    );
  }
}
