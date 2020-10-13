import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";
  static const SHIPPING_ADDRESS_NAME = "shippingAddressName";
  static const SHIPPING_ADDRESS_STREET = "shippingAddressStreet";
  static const SHIPPING_ADDRESS_PIN = "shippingAddressPin";
  static const SHIPPING_ADDRESS_CITY = "shippingAddressCity";
  static const SHIPPING_ADDRESS_STATE = "shippingAddressState";
  static const SHIPPING_ADDRESS_COUNTRY = "shippingAddressCountry";
  static const SHIPPING_ADDRESS_EMAIL = "shippingAddressEmail";
  static const SHIPPING_ADDRESS_MOBILE = "shippingAddressMobile";

  String _id;
  String _description;
  String _userId;
  String _status;
  String _sName;
  String _sStreet;
  String _sPin;
  String _sCity;
  String _sState;
  String _sCountry;
  String _sEmail;
  String _sMobile;
  int _createdAt;
  int _total;

//  getters
  String get id => _id;

  String get description => _description;

  String get userId => _userId;

  String get status => _status;

  String get sName => _sName;

  String get sStreet => _sStreet;

  String get sPin => _sPin;

  String get sCity => _sCity;

  String get sState => _sState;

  String get sCountry => _sCountry;

  String get sEmail => _sEmail;

  String get sMobile => _sMobile;

  int get total => _total;

  int get createdAt => _createdAt;

  // public variable
  List cart;

  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.get(ID);
    _description = snapshot.get(DESCRIPTION);
    _total = snapshot.get(TOTAL);
    _status = snapshot.get(STATUS);
    _userId = snapshot.get(USER_ID);
    _createdAt = snapshot.get(CREATED_AT);
    cart = snapshot.get(CART);
  }
}
