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


class Request{
  String address;
  Map foodList;
  String name;
  String uid;
  String status;
  String total;

  Request({
    this.address,
    this.foodList,
    this.name,
    this.uid,
    this.status,
    this.total
  });

  Map toMap(Request request) {
    var data = Map<String, dynamic>();
    data['address'] = request.address;
    data['foodList'] = request.foodList;
    data['name'] = request.name;
    data['uid'] = request.uid;
    data['status'] = request.status;
    data['total'] = request.total;
    return data;
  }

  Request.fromMap(Map<dynamic, dynamic> mapData) {
    this.address = mapData['address'];
    this.foodList = mapData['foodList'];
    this.name=mapData['name'];
    this.uid=mapData["uid"];
    this.status=mapData["status"];
    this.total=mapData["total"];
  }
}