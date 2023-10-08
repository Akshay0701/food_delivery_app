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

class UserModel {
  final String uid;
  final String phone;
  final String? email;
  final String password;

  UserModel(
      {required this.uid,
      required this.email,
      required this.password,
      required this.phone});

  Map toMap(UserModel user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['email'] = user.email;
    data['phone'] = user.phone;
    data['password'] = user.password;
    return data;
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> mapData) {
    return UserModel(
      uid: mapData['uid'],
      email: mapData['email'],
      phone: mapData['phone'],
      password: mapData['password'],
    );
  }
}
