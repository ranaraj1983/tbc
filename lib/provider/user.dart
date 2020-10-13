import 'dart:async';

import 'package:tbc/models/address.dart';
import 'package:tbc/models/cart_item.dart';
import 'package:tbc/models/order.dart';
import 'package:tbc/models/product.dart';
import 'package:tbc/models/user.dart';
import 'package:tbc/provider/product.dart';
import 'package:tbc/services/order.dart';
import 'package:tbc/services/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;
  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();

  UserModel _userModel;

//  getter
  UserModel get userModel => _userModel;

  Status get status => _status;

  User get user => _user;

  // public variables
  List<OrderModel> orders = [];

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth..authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _onStateChanged(user);
      _status = Status.Authenticated;

      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password, String mobile) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        _userServices.createUser({
          'name': name,
          'email': email,
          'uid': user.user.uid,
          'stripeId': '',
          'mobile':mobile,
          'userType': "CUSTOMER",
          'cart':[]
        });
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    removeUserData();
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onStateChanged(User user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _userModel = await _userServices.getUserById(user.uid);
      _status = Status.Authenticated;
    }

    notifyListeners();
  }

  Future<bool> addToCart(
      {ProductModel product, String size, String color, int price}) async {
    try {
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List<CartItemModel> cart = _userModel.cart;

      Map cartItem = {
        "id": cartItemId,
        "name": product.name,
        "image": product.picture,
        "productId": product.id,
        "price": price,
        "size": size,
        "color": color
      };

      CartItemModel item = CartItemModel.fromMap(cartItem);
//      if(!itemExists){
      //print("CART ITEMS ARE: ${cart.toString()}");
      _userServices.addToCart(userId: _user.uid, cartItem: item);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromCart({CartItemModel cartItem})async{
    print("THE PRODUC IS: ${cartItem.toString()}");

    try{
      _userServices.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }
  createOrder(String description, String status,
      int totalPrice, String paymentId, String orderId) async {
    var uuid = Uuid();
    String cartItemId = uuid.v4();
    List<CartItemModel> cart = _userModel.cart;

     _orderServices.createOrder(
       userId:_user.uid ,id: cartItemId, description:description, status: status,
         cart: cart,  totalPrice:totalPrice
    );

    for(CartItemModel item in cart){
      removeFromCart(cartItem:item);
      notifyListeners();
    }
    _userModel.cart = null;
    notifyListeners();
  }
  getOrders()async{
    orders = await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }

  Future<void> reloadUserModel()async{
    _userModel = await _userServices.getUserById(user.uid);
    notifyListeners();
  }

  void removeUserData() {
    _userModel = null;
    notifyListeners();
  }

   bool addAddress(String name, String street, String country, String state,
      String city, String pin, String mobile) {
    try{
      var uuid = Uuid();
      String addressId = uuid.v4();
      List<CartItemModel> cart = _userModel.cart;

      Map address = {
        "shippingAddressId": addressId,
        "shippingAddressName": name,
        "shippingAddressStreet": street,
        "shippingAddressCountry": country,
        "shippingAddressCity": city,
        "shippingAddressPin": pin,
        "shippingAddressMobile": mobile,
        "shippingAddressState":state
      };

      AddressModel addressModel = AddressModel.fromMap(address);
//      if(!itemExists){
      //print("CART ITEMS ARE: ${cart.toString()}");
      _userServices.addToAddress(userId: _user.uid, addressModel: addressModel);
      return true;
    }catch(e){
      return false;
    }


  }
}
