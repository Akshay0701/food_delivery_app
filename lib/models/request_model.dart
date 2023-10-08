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

class RequestModel {
  final String address;
  final Map foodList;
  final String name;
  final String uid;
  final String status;
  final String total;

  RequestModel({
    required this.address,
    required this.foodList,
    required this.name,
    required this.uid,
    required this.status,
    required this.total,
  });

  Map toMap(RequestModel request) {
    var data = Map<String, dynamic>();
    data['address'] = request.address;
    data['foodList'] = request.foodList;
    data['name'] = request.name;
    data['uid'] = request.uid;
    data['status'] = request.status;
    data['total'] = request.total;
    return data;
  }

  factory RequestModel.fromMap(Map<dynamic, dynamic> mapData) {
    return RequestModel(
      address: mapData['address'],
      foodList: mapData['foodList'],
      name: mapData['name'],
      uid: mapData['uid'],
      status: mapData['status'],
      total: mapData['total'],
    );
  }
}
