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

import 'dart:async';
import 'package:food_delivery_app/models/Food.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSql {

  Database database;
  int count;

  Future<void> openDatabaseSql() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'cart.db');

    // open the database
    database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
          "CREATE TABLE cartTable(keys TEXT PRIMARY KEY, name TEXT, price TEXT,menuId TEXT,image TEXT,discount TEXT,description TEXT)",
        );
      },
    );
  }

  Future<bool> insertData(Food food) async {
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO cartTable(keys, name, price,menuId,image,discount,description) VALUES("${food
              .keys}","${food.name}","${food.price}","${food.menuId}","${food
              .image}","${food.discount}","${food.description}")');
      print('inserted1: $id1');
    });
    return true;
  }

  Future<int> countData() async {
    count = Sqflite
        .firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM cartTable'));
    assert(count == 2);
    return count;
  }

  Future<bool> deleteData(String id) async {
    count = await database
        .rawDelete('DELETE FROM cartTable WHERE keys = ?', [id]);
    print(id);
    return true;
  }


  Future<bool> deleteAllData() async {
    count = await database
        .rawDelete('DELETE FROM cartTable ');
    return true;
  }


  Future<List<Food>> getData() async {
    List<Food> foodList=[];
    List<Map> list = await database.rawQuery('SELECT * FROM cartTable');
    // convert to list food
    list.forEach((map) {
      foodList.add(Food.fromMap(map));
    });
    return foodList;
  }

}