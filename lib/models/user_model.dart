
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
