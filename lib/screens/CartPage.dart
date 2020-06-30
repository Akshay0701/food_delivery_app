import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/models/Request.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/resourese/databaseSQL.dart';
import 'package:food_delivery_app/screens/homepage.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  AuthMethods _authMethods=AuthMethods();

  final TextEditingController nametextcontroller=TextEditingController();
  final TextEditingController addresstextcontroller=TextEditingController();

  List<Food> foodList=[];
  String totalPrice="0";
  DatabaseSql databaseSql;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatabaseValue();
  }
  getDatabaseValue()async{
     databaseSql=DatabaseSql();
    await databaseSql.openDatabaseSql();
    foodList= await databaseSql.getData();
    //calculating total price
    int price =0;
    foodList.forEach((food) {
      int foodItemPrice=int.parse(food.price);
      price +=foodItemPrice;
    });
    setState(() {
      totalPrice=price.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0,backgroundColor: Colors.transparent,),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 30.0,top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My Order",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 35.0),),
              Padding(
                padding: const EdgeInsets.only(right:25.0),
                child: Divider(thickness: 2.0,),
              ),
              createListCart(),
              createTotalPriceWidget(),
            ],
          ),
        ),
      ),
    );
  }
  createTotalPriceWidget(){
    return Container(
      color: Colors.white30,
      padding: EdgeInsets.only(right: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total :",style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black,fontSize: 25.0),),
              Text("$totalPrice Rs.",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 30.0),),
            ],
          ),
          Divider(thickness: 2.0,),
          SizedBox(height: 20.0,),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.width*0.14,
              width: MediaQuery.of(context).size.width*0.9,
              child: FlatButton(
                color: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: ()=>_showDialog(),
                child: Text("Place Order",style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold,color: Colors.white),),
              ),
            ),
          ),
        ],
      ),
    );
  }
  set(){
    setState(() {

    });
  }
  createListCart(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 400,
      child: foodList.length==0 ? Center(child: CircularProgressIndicator())
          : ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: foodList.length,
          itemBuilder: (_,index){
            return CartItems(
             foodList[index],
            );
          }
      ),
    );
  }
  _showDialog() async {
    await showDialog<String>(
      context: context,
      child:handleOrderPlacement(),
    );
  }

  handleOrderPlacement() {
    //check if card is empty
    if(totalPrice=="0"){
      print("not order");
      return AlertDialog(
        title: Text('Abe Kuch Add Toh Kar'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Card Is Empty !'),
              Text('Add Some Product on Card First'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
    else{
      print("order");
      return AlertDialog(
        title: Text('OO Bhai Bohot Paise HAi haa..'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Fill Details'),
              new Expanded(
                child: new TextField(
                  controller: nametextcontroller,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Name', hintText: 'eg. Akshay'),
                ),
              ) ,
              new Expanded(
                child: new TextField(
                  controller: addresstextcontroller,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Address', hintText: 'eg. st road west chembur'),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Order'),
            onPressed: () {
//              Navigator.of(context).pop(); code for ordering
            OrderPlaceToFirebase();
            },
          ),
        ],
      );
    }

  }

  // ignore: non_constant_identifier_names
  OrderPlaceToFirebase()async{
    //getter user details
    String nametxt=nametextcontroller.text;
    String addresstxt=addresstextcontroller.text;
    FirebaseUser user= await _authMethods.getCurrentUser();
    String uidtxt =user.uid;
    String statustxt="0";
    String totaltxt=totalPrice;
    //creating model

    Map aux = new Map<String,dynamic>();
    foodList.forEach((food){
      //Here you can set the key of the map to whatever you like
      aux[food.keys] = food.toMap(food);
    });

    Request request =Request(
      address:addresstxt,
      name:nametxt,
      uid:uidtxt,
      status:statustxt,
      total:totaltxt,
      foodList:aux
    );
    print(request.toString());
//    bool isDone= await _authMethods.PlaceOrder(request);

    //add order 
    DatabaseReference ordersReference=FirebaseDatabase.instance.reference().child("Orders");
    await ordersReference.child(request.uid).push().set(request.toMap(request));

    DatabaseSql databaseSql=DatabaseSql();
    await databaseSql.openDatabaseSql();
    bool isDeleted =await databaseSql.deleteAllData();
    if(isDeleted){
      setState(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => HomePage()));
      });
    }
  }

}



class CartItems extends StatefulWidget {
  final Food fooddata;
  CartItems(this.fooddata);

  @override
  _CartItemsState createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
//      onLongPress: ()=>deleteItem(),
      child: Container(
        color: Colors.white10,
        padding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 10.0),
        child:ListTile(
          leading: Container(child: ClipRRect(borderRadius: BorderRadius.circular(5.0),
          child: Image.network(widget.fooddata.image,fit: BoxFit.cover,)),height: 80.0,width: 80.0,),
          title: Text(widget.fooddata.name,style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold,color: Colors.black),),
          subtitle: Text("${widget.fooddata.price}\$",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54),),
          trailing: IconButton(icon:  Icon(Icons.delete,size: 20.0,), onPressed:()=>deleteFoodFromCart(widget.fooddata.keys) ,),
        )
      ),
    );
  }

  deleteFoodFromCart(String keys) async{
    print(keys);
    DatabaseSql databaseSql=DatabaseSql();
    await databaseSql.openDatabaseSql();
    bool isDeleted =await databaseSql.deleteData(keys);
    if(isDeleted){
      final snackBar= SnackBar(
        content: Text('Removed Food Item'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CartPage()));
      });
    }
  }
}

