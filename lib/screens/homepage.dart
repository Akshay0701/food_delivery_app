import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Category.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/screens/CartPage.dart';
import 'package:food_delivery_app/screens/CategoryListPage.dart';
import 'package:food_delivery_app/screens/MyOrderPage.dart';
import 'package:food_delivery_app/screens/SearchPage.dart';
import 'package:food_delivery_app/widgets/categorywidget.dart';
import 'package:food_delivery_app/widgets/foodTitleWidget.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //for database
  AuthMethods _authMethods=AuthMethods();

  TextEditingController searchCtrl=TextEditingController();

  List<Category> categoryList=[];
  List<Food> foodList=[];
  List<Food> popularFoodList=[];

  //for recently added food
  Category recentlyCategory=Category(image:"https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",name: "burger",keys: "08");
  Category recentlyCategory2=Category(image:"https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/216054.jpg",name: "Pizza",keys: "04");
  Category recentlyCategory3=Category(image:"https://static.toiimg.com/thumb/54659021.cms?width=1200&height=1200",name: "french fries",keys: "07");
  Category recentlyCategory4=Category(image:"https://i.pinimg.com/originals/3b/b4/ea/3bb4ea708b73c60a11ccd4a7bdbb1524.jpg",name: "kfc chicken",keys: "09");

  FirebaseUser firebaseUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //get user data
     _authMethods.getCurrentUser().then((FirebaseUser User)  {
      setState(() {
        firebaseUser=User;
        print(firebaseUser);
      });
     });

    //getting data for category
    DatabaseReference reference=FirebaseDatabase.instance.reference().child("Category");
     reference.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var KEYS=snap.value.keys;
      // ignore: non_constant_identifier_names
      var DATA=snap.value;
      categoryList.clear();
      for(var individualKey in KEYS){
        Category posts= new Category(
          image: DATA[individualKey]['Image'],
          name:DATA[individualKey]['Name'],
          keys:individualKey.toString(),
        );

        categoryList.add(posts);
      }

    });

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
        if(food.menuId=="05"){
          popularFoodList.add(food);
        }
        if(food.menuId=="03"){
          foodList.add(food);
        }
      }
      setState(() {
        print("data");
      });
    });
  //  getData();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        elevation: 0.0,
        title: Text("Home",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30.0),),
//        bottom: createSearchBar(),
      ),
      drawer: createDrawer(),
      body: SingleChildScrollView(
          child: Container(
          //padding: EdgeInsets.symmetric(horizontal:20.0,vertical:10.0),
          width: MediaQuery.of(context).size.width,
          color:Colors.white,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              createSearchBar(),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:18.0,vertical: 5.0),
              child: Text("Recently Add",style: TextStyle(color: Colors.orange,fontSize: 30.0,fontWeight: FontWeight.bold,),),
            ),

            createListRecntlyAdd(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:18.0),
              child: Text("Food Category",style: TextStyle(color: Colors.orange,fontSize: 30.0,fontWeight: FontWeight.bold,),),
            ),

              createFoodCategory(),
              createPopularFoodList(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:18.0),
              child: Text("For You",style: TextStyle(color: Colors.black45,fontSize: 20.0,fontWeight: FontWeight.bold,),),
            ),

              createForYou(),
          ],)
        ),
      ),
    );
  }


  createDrawer(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          DrawerHeader(
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.white,),
              accountName:Text("") ,
              accountEmail: Text(firebaseUser==null?"":firebaseUser.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://i0.wp.com/images-prod.healthline.com/hlcmsresource/images/AN_images/eggs-breakfast-avocado-1296x728-header.jpg?w=1155&h=1528"
                  ,),),),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.transparent,
            ),
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios,),
            leading: Icon(Icons.home,color: Colors.orangeAccent,),
            title: Text('Home',),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios,),
            leading: Icon(Icons.shopping_basket,color: Colors.orangeAccent,),
            title: Text('Cart'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage()));
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios,),
            leading: Icon(Icons.fastfood,color: Colors.orangeAccent,),
            title: Text('My Order'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOrderPage()));
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios,),
            leading: Icon(Icons.clear,color: Colors.orangeAccent,),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  createPopularFoodList(){
    return Container(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:18.0),
            child: Text("Popular Food ",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.black45),),
          ),
          SizedBox(height: 10.0,),
          Container(
            height: 200.0,
            child: popularFoodList.length==-1 ? Center(child: Center(child: CircularProgressIndicator()))
                : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularFoodList.length,
                itemBuilder: (_,index){
                  return FoodTitleWidget(
                    popularFoodList[index],
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  createSearchBar(){
    return  Container(
      height: MediaQuery.of(context).size.height*0.08,
      child: Stack(
        children: <Widget>[
          // Replace this container with your Map widget
          Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomRight:Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 15,
            left: 15,
            child: GestureDetector(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage())),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left:18.0),
                        child: Text("Search",style: TextStyle(color: Colors.black45),),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(icon: Icon(Icons.search,color: Colors.orange,), onPressed: null)
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  gotoCateogry(Category category){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryListPage(category)));
  }

  createListRecntlyAdd(){
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector( onTap: ()=>gotoCateogry(recentlyCategory), child: CircleAvatar(radius: 35.0,backgroundImage: NetworkImage("https://www.pngitem.com/pimgs/m/398-3981213_how-to-draw-burger-burger-drawing-easy-hd.png",scale: 60.0),)),
          GestureDetector( onTap: ()=>gotoCateogry(recentlyCategory2),child: CircleAvatar(radius: 35.0,backgroundImage: NetworkImage("https://img.favpng.com/19/11/2/pizza-clip-art-vector-graphics-pepperoni-illustration-png-favpng-Mf177mM20Db6kFJa1SmMpQN5R.jpg",scale: 60.0),)),
          GestureDetector( onTap: ()=>gotoCateogry(recentlyCategory3),child: CircleAvatar(radius: 35.0,backgroundImage: NetworkImage("https://www.vippng.com/png/detail/133-1337804_french-fry-png-mcdonalds-french-fries-drawing.png",scale: 60.0),)),
          GestureDetector( onTap: ()=>gotoCateogry(recentlyCategory4),child: CircleAvatar(radius: 35.0,backgroundImage: NetworkImage("https://www.kindpng.com/picc/m/488-4883349_png-download-png-download-kfc-chicken-bowl-easy.png",scale: 60.0),)),

        ],
      ),
    );
  }

  createFoodCategory(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 300.0,
      child: categoryList.length==0 ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: categoryList.length,
          itemBuilder: (_,index){
            return CategoryWidget(
              categoryList[index],
            );
          }
      ),
    );
  }

  createForYou(){
    return Container(
      height:MediaQuery.of(context).size.height*0.5,
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: foodList.length==0 ? Center(child: CircularProgressIndicator())
          : ListView.builder(
          itemCount: foodList.length,
          itemBuilder: (_,index){
            return FoodTitleWidget(foodList[index]);
          }
      ),
    );
  }
}
