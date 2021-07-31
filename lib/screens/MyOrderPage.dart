import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_delivery_app/models/Request.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:food_delivery_app/widgets/orderwidget.dart';
class MyOrderPage extends StatefulWidget {
  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  List<Request> requestList=[];
  AuthMethods authMethods=AuthMethods();
  FirebaseUser currentUser;

  getuser()async{
     

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuser();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      currentUser= await authMethods.getCurrentUser();
      authMethods.fetchOrders(currentUser).then((List<Request> list){
        setState(() {
          requestList = list;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text("My Orders",
                    style: TextStyle(
                      color: UniversalVariables.orangeAccentColor, 
                      fontSize: 40.0, 
                      fontWeight: FontWeight.bold,
                      ),
                  ),
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



