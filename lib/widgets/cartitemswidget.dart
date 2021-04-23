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
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/resourese/databaseSQL.dart';
import 'package:food_delivery_app/screens/CartPage.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';

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
      child: Container(
        color: UniversalVariables.whiteLightColor,
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
    DatabaseSql databaseSql=DatabaseSql();
    await databaseSql.openDatabaseSql();
    bool isDeleted = await databaseSql.deleteData(keys);
    if(isDeleted){
      final snackBar= SnackBar(
        content: Text('Removed Food Item'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // todo code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartPage()));
    }
  }
}
