import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_delivery_app/models/Category.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/models/Request.dart';
import 'package:food_delivery_app/models/User.dart';

class AuthMethods {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseReference ordersReference=FirebaseDatabase.instance.reference().child("Orders");

  static final DatabaseReference _userReference = _database.reference().child(
      "Users");
  static final DatabaseReference _categoryReference = _database.reference()
      .child("Category");

  //current user getter
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  //sign in
  Future<FirebaseUser> handleSignInEmail(String email, String password) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    // final FirebaseUser user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print('signInEmail succeeded: $user');

    return user;
  }

  Future<FirebaseUser> handleSignUp(phone, email, password) async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
//    user = result.user;

    assert (user != null);
    assert (await user.getIdToken() != null);
    //enter data to firebase
    return user;
  }

  //add user data to firebase
  Future<void> addDataToDb(FirebaseUser currentUser, String username,
      String Phone, String Password) async {
    User user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        phone: Phone,
        password: Password
    );

    _userReference
        .child(currentUser.uid)
        .set(user.toMap(user));
  }


  Future<List<Food>> fetchAllFood() async {
    List<Food>foodList=List<Food>();
    //getting food list
    DatabaseReference foodReference=FirebaseDatabase.instance.reference().child("Foods");
    foodReference.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var KEYS=snap.value.keys;
      // ignore: non_constant_identifier_names
      var DATA=snap.value;

      foodList.clear();
      for(var individualKey in KEYS){
        Food food= new Food(
            description: DATA[individualKey]['description'],
            discount: DATA[individualKey]['discount'],
            image:DATA[individualKey]['image'],
            menuId:DATA[individualKey]['menuId'],
            name:DATA[individualKey]['name'],
            price:DATA[individualKey]['price'],
            keys: individualKey.toString()
        );
          foodList.add(food);
      }
     return foodList;
    });
  }

  Future<bool> PlaceOrder(Request request)async{
    await ordersReference.child(request.uid).push().set(request.toMap(request));
    return true;
  }
//
// Future<List<Category>> fetchCategory()async{
//
//   List<Category> categoryList=[];
//   _categoryReference.once().then((DataSnapshot snap) {
//     // ignore: non_constant_identifier_names
//     var KEYS=snap.value.keys;
//     // ignore: non_constant_identifier_names
//     var DATA=snap.value;
//
//     categoryList.clear();
//     for(var individualKey in KEYS){
//       Category posts= new Category(
//         DATA[individualKey]['Image'],
//         DATA[individualKey]['Name'],
//       );
//       categoryList.add(posts);
//     }
//
//   });
//   return categoryList;
// }

}