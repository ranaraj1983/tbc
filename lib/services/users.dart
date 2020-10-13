import 'dart:async';
import 'package:tbc/models/address.dart';
import 'package:tbc/models/cart_item.dart';
import 'package:tbc/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = "users";

  void createUser(Map data) async{
    await _firestore.collection(collection).doc(data["uid"]).set({
      'name': data["name"],
      'email': data["email"],
      'mobile': data["mobile"],
      'userType': data["userType"],
      'uid': data["uid"],
      'stripeId': '',
      'cart':[]
    });
    print(data);
  }

  Future<UserModel> getUserById(String id)=> _firestore.collection(collection).doc(id).get().then((doc){
    return UserModel.fromSnapshot(doc);
  });

  void addToCart({String userId, CartItemModel cartItem}){
    _firestore.collection(collection).doc(userId).update({
      "cart": FieldValue.arrayUnion([cartItem.toMap()])
    });
  }

  void addToAddress({String userId, AddressModel addressModel}){
    _firestore.collection(collection).doc(userId).update({
      "address": FieldValue.arrayUnion([addressModel.toMap()])
    });
  }

  void removeFromCart({String userId, CartItemModel cartItem}){
    _firestore.collection(collection).doc(userId).update({
      "cart": FieldValue.arrayRemove([cartItem.toMap()])
    });
  }
}