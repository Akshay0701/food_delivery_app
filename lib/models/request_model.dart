

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
