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


class Food{
  String description;
  String discount;
  String image;
  String menuId;
  String name;
  String price;
  String keys;


  Food({
    this.description,
    this.discount,
    this.image,
    this.menuId,
    this.name,
    this.price,
    this.keys
  });

  Map toMap(Food food) {
    var data = Map<String, dynamic>();
    data['description'] = food.description;
    data['discount'] = food.discount;
    data['image'] = food.image;
    data['menuId'] = food.menuId;
    data['name'] = food.name;
    data['price'] = food.price;
    data['keys'] = food.keys;
    return data;
  }

  Food.fromMap(Map<dynamic, dynamic> mapData) {
    this.description = mapData['description'];
    this.discount = mapData['discount'];
    this.image = mapData['image'];
    this.menuId = mapData['menuId'];
    this.name = mapData['name'];
    this.price = mapData['price'];
    this.keys = mapData['keys'];
  }
}