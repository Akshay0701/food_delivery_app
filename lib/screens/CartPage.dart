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
import 'package:food_delivery_app/blocs/CartPageBloc.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:food_delivery_app/widgets/cartitemswidget.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartPageBloc(),
      child: CartPageContent()
    );
  }
}

class CartPageContent extends StatefulWidget {
  const CartPageContent() : super();

  @override
  _CartPageContentState createState() => _CartPageContentState();
}

class _CartPageContentState extends State<CartPageContent> {
  
  CartPageBloc cartPageBloc;
  TextEditingController nametextcontroller = TextEditingController();
  TextEditingController addresstextcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await cartPageBloc.getDatabaseValue();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    cartPageBloc = Provider.of<CartPageBloc>(context);
    cartPageBloc.context = context;
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
              Text("${cartPageBloc.totalPrice} Rs.",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 30.0),),
            ],
          ),
          Divider(thickness: 2.0,),
          SizedBox(height: 20.0,),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.width*0.14,
              width: MediaQuery.of(context).size.width*0.9,
              child: TextButton(
               style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(UniversalVariables.orangeColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),)
                  ),
                ),
                onPressed: () => _showDialog(),
                child: Text("Place Order",style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold,color: UniversalVariables.whiteColor),),
              ),
            ),
          ),
        ],
      ),
    );
  }

  createListCart(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 400,
      child: cartPageBloc.foodList.length==0 ? Center(child: CircularProgressIndicator())
          : ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: cartPageBloc.foodList.length,
          itemBuilder: (_,index){
            return CartItems(
             cartPageBloc.foodList[index],
            );
          }
      ),
    );
  }
  
  _showDialog() async {
    await showDialog<String>(
      context: context,
      builder:(BuildContext context) {
        return handleOrderPlacement();
      },
    );
  }

  handleOrderPlacement() {
    //check if card is empty
    if(cartPageBloc.totalPrice == 0){
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
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
    else{
      return AlertDialog(
        title: Text('OO Bhai Bohot Paise Hai haa..'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Fill Details'),
              TextField(
                controller: nametextcontroller,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: 'Name', hintText: 'eg. Akshay'),
              ),
              TextField(
                controller: addresstextcontroller,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: 'Address', hintText: 'eg. st road west chembur'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Order'),
            onPressed: () {
             cartPageBloc.orderPlaceToFirebase(nametextcontroller.text, addresstextcontroller.text);
            },
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    nametextcontroller.dispose();
    addresstextcontroller.dispose();
  }
}
