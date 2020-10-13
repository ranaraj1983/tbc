import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item.dart';

class UserModel {
  static const ID = "uid";
  static const NAME = "name";
  static const EMAIL = "email";
  static const STRIPE_ID = "stripeId";
  static const CART = "cart";
  static const USERTYPE = "userType";
  static const MOBILE = "mobile";


  String _name;
  String _email;
  //String _mobile;
  String _id;
  String _stripeId;
  int _priceSum = 0;
  String _userType;
  String _mobile;


//  getters
  String get name => _name;

  String get email => _email;

  String get id => _id;

  String get userType => _userType;

  String get stripeId => _stripeId;

  String get mobile => _mobile;

  // public variables
  List<CartItemModel> cart;
  int totalCartPrice;



  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.get(NAME);
    _email = snapshot.get(EMAIL);
    _mobile = snapshot.get(MOBILE);
    _id = snapshot.get(ID);
    _userType = snapshot.get(USERTYPE);

    //_stripeId = snapshot.get(STRIPE_ID) ?? "";
    cart = _convertCartItems(snapshot.get(CART)?? []);
    totalCartPrice = snapshot.get(CART) == null ? 0 :getTotalPrice(cart: snapshot.get(CART));

  }

  List<CartItemModel> _convertCartItems(List cart){
    List<CartItemModel> convertedCart = [];
    for(Map cartItem in cart){
      convertedCart.add(CartItemModel.fromMap(cartItem));
    }
    return convertedCart;
  }

  int getTotalPrice({List cart}){
    if(cart == null){
      return 0;
    }
    for(Map cartItem in cart){
      _priceSum += cartItem["price"];
    }

    int total = _priceSum;
    return total;
  }
}
