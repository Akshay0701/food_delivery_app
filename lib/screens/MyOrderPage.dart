import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/models/Request.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/widgets/foodTitleWidget.dart';
class MyOrderPage extends StatefulWidget {
  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  List<Request> requestList=[];
  AuthMethods authMethods=AuthMethods();
  FirebaseUser currentUser;

  getuser()async{
     currentUser= await authMethods.getCurrentUser();
     DatabaseReference foodReference = FirebaseDatabase.instance.reference()
         .child("Orders")
         .child(currentUser.uid);
     await foodReference.once().then((DataSnapshot snap) {
       // ignore: non_constant_identifier_names
       var KEYS = snap.value.keys;
       // ignore: non_constant_identifier_names
       var DATA = snap.value;

       requestList.clear();
       for (var individualKey in KEYS) {
         Request request =Request(
             address: DATA[individualKey]['address'],
             name:DATA[individualKey]['name'],
             uid:DATA[individualKey]['uid'],
             status:DATA[individualKey]['status'],
             total:DATA[individualKey]['total'],
             foodList:DATA[individualKey]['foodList'],
         );
         requestList.add(request);
         print(request.uid);
       }
       setState(() {
         print("data");
       });
     });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuser();
  }

  @override
  Widget build(BuildContext context) {
 //   getuser();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 0.0,left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0,left:18.0),
                  child: Text("My Orders",style: TextStyle(color: Colors.orange,fontSize: 40.0,fontWeight: FontWeight.bold,),),
                ),
                createListOfOrder()
              ],
            ),
          ),
        ),
    );
  }

  createListOfOrder(){
    return Container(
      height: MediaQuery.of(context).size.height,
      child: requestList.length==-1 ? Center(child: CircularProgressIndicator())
          : ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: requestList.length,
          itemBuilder: (_,index){
            return OrderWidget(
              requestList[index],
            );
          }
      ),
    );
  }
}


class OrderWidget extends StatefulWidget {
  Request request;
  OrderWidget(this.request);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  List<Step> steps = [
    Step(

      content: Text('asd'),
      title: Text('Placed'),
      isActive: true,
    ),
    Step(
      title: Text('On The Way'),
      content: Text('asd'),
      isActive: true,
    ),
    Step(
      content: Text('asd'),
      title: Text('Completed'),
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(widget.request.name,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,),),
            subtitle:Text(widget.request.address,style: TextStyle(color: Colors.black38,fontWeight: FontWeight.normal,),) ,
            leading: CircleAvatar(backgroundImage: NetworkImage("https://www.pngitem.com/pimgs/m/252-2523515_delivery-clipart-delivery-order-frames-illustrations.png"),),
            trailing:Text(widget.request.total+" Rs.",style: TextStyle(color: Colors.orange,fontSize: 20.0,fontWeight: FontWeight.bold,),) ,
          ),

          createSatusBar(),
          Container(
            padding: EdgeInsets.only(left: 20.0,top: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your Food",style: TextStyle(color: Colors.black45,fontSize: 16.0,fontWeight: FontWeight.bold,),),
                createListOfFood(),
              ],
            ),
          )
        ],
      ),
    );
  }

  createSatusBar(){
    return Container(
      height: 100.0,
      child: Stepper(
        currentStep: int.parse(widget.request.status),
        steps: steps,
        type: StepperType.horizontal,
        physics: NeverScrollableScrollPhysics(),
        controlsBuilder: (BuildContext context,
            {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
            Container(height: 0.0,),
      ),
    );
  }

  createListOfFood(){
    List<Food> foodList=[];
//    foodList=Food.fromMap(widget.request.foodList) as List<Food>;
    widget.request.foodList.forEach((key, value) {
      Food food=Food(
        name: value["name"],
        image: value["image"],
        keys: value["keys"],
        price: value["price"],
        description: value["description"],
        menuId: value["menuId"],
        discount: value["discount"],
      );
      foodList.add(food);
    });

    return Container(
      height:200.0,
      child: foodList.length==-1 ? Center(child: CircularProgressIndicator())
          : ListView.builder(
          scrollDirection: Axis.horizontal,
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

