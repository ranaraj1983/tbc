import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {

  static const SHIPPING_ADDRESS_NAME = "shippingAddressName";
  static const SHIPPING_ADDRESS_STREET = "shippingAddressStreet";
  static const SHIPPING_ADDRESS_PIN = "shippingAddressPin";
  static const SHIPPING_ADDRESS_CITY = "shippingAddressCity";
  static const SHIPPING_ADDRESS_STATE = "shippingAddressState";
  static const SHIPPING_ADDRESS_COUNTRY = "shippingAddressCountry";
  static const SHIPPING_ADDRESS_EMAIL = "shippingAddressEmail";
  static const SHIPPING_ADDRESS_MOBILE = "shippingAddressMobile";
  static const SHIPPING_ADDRESS_ID = "shippingAddressId";

  String _sName;
  String _sStreet;
  String _sPin;
  String _sCity;
  String _sState;
  String _sCountry;
  String _sEmail;
  String _sMobile;
  String _sId;

  String get sName => _sName;

  String get sStreet => _sStreet;

  String get sPin => _sPin;

  String get sCity => _sCity;

  String get sState => _sState;

  String get sCountry => _sCountry;

  String get sEmail => _sEmail;

  String get sMobile => _sMobile;

  String get sId => _sId;

  AddressModel.fromSnapshot(DocumentSnapshot snapshot) {
    _sName = snapshot.get(SHIPPING_ADDRESS_NAME);
    _sStreet = snapshot.get(SHIPPING_ADDRESS_STREET);
    _sStreet = snapshot.get(SHIPPING_ADDRESS_PIN);
    _sCity = snapshot.get(SHIPPING_ADDRESS_CITY);
    _sState = snapshot.get(SHIPPING_ADDRESS_STATE);
    _sCountry = snapshot.get(SHIPPING_ADDRESS_COUNTRY);
    _sEmail = snapshot.get(SHIPPING_ADDRESS_EMAIL);
    _sMobile = snapshot.get(SHIPPING_ADDRESS_MOBILE);
    _sId = snapshot.get(SHIPPING_ADDRESS_ID);
  }

  AddressModel.fromMap(Map data){
    _sName = data[SHIPPING_ADDRESS_NAME];
    _sStreet = data[SHIPPING_ADDRESS_STREET];
    _sPin =  data[SHIPPING_ADDRESS_PIN];
    _sCity =  data[SHIPPING_ADDRESS_CITY];
    _sState = data[SHIPPING_ADDRESS_STATE];
    _sCountry = data[SHIPPING_ADDRESS_COUNTRY];
    _sMobile = data[SHIPPING_ADDRESS_MOBILE];
    _sId = data[SHIPPING_ADDRESS_ID];
  }

  Map toMap() => {
    SHIPPING_ADDRESS_NAME: _sName,
    SHIPPING_ADDRESS_STREET: _sStreet,
    SHIPPING_ADDRESS_PIN: _sPin,
    SHIPPING_ADDRESS_CITY: _sCity,
    SHIPPING_ADDRESS_STATE: _sState,
    SHIPPING_ADDRESS_COUNTRY: _sCountry,
    SHIPPING_ADDRESS_MOBILE: _sMobile,
    SHIPPING_ADDRESS_ID: _sId
  };
}