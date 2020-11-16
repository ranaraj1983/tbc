import 'package:cloud_firestore/cloud_firestore.dart';


class ProductModel {
  static const ID = "id";
  static const NAME = "name";
  static const PICTURE = "picture";
  static const PRICE = "price";
  static const RPRICE = "rprice";
  static const WPRICE = "wprice";
  static const CPRICE = "cprice";
  static const MPRICE = "mprice";
  static const LPRICE = "lprice";
  static const DESCRIPTION = "description";
  static const CATEGORY = "category";
  static const FEATURED = "featured";
  static const QUANTITY = "quantity";
  static const BRAND = "brand";
  static const SALE = "sale";
  static const SIZES = "size";
  static const COLORS = "colors";
  static const VNAME = "vName";
  static const VID = "vid";
  static const WEIGHT = "weight";

  String _weight;
  String _id;
  String _name;
  String _picture;
  String _description;
  String _category;
  String _brand;
  int _quantity;
  int price;
  int _rprice;
  int _wprice;
  int _cprice;
  int _mprice;
  int _lprice;
  String _sale;
  String _featured;
  String _colors;
  double _sizes;
  String _vName;
  String _vId;


  String get weight => _weight;

  String get id => _id;

  String get name => _name;

  String get picture => _picture;

  String get brand => _brand;

  String get category => _category;

  String get description => _description;

  int get quantity => _quantity;

  String get vName => _vName;
  String get vId => _vId;

  int get rprice => _rprice;
  int get wprice => _wprice;
  int get cprice => _cprice;
  int get lprice => _lprice;
  int get mprice => _mprice;

  String get featured => _featured;

  String get sale => _sale;

  String get colors => _colors;

  double get sizes => _sizes;

  String userType;
  int actPrice;


  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {

    print(snapshot.get(NAME));
    _id = snapshot.get(ID);
    _weight = snapshot.get(WEIGHT);
    _brand = snapshot.get(BRAND);
    _sale = snapshot.get(SALE);
    _description = snapshot.get(DESCRIPTION) ?? " ";
    _featured = snapshot.get(FEATURED);
    _cprice = snapshot.get(CPRICE);
    _rprice = snapshot.get(RPRICE);
    _wprice = snapshot.get(WPRICE);
    _mprice = snapshot.get(MPRICE);
    _lprice = snapshot.get(LPRICE);
    _category = snapshot.get(CATEGORY);
    _colors = snapshot.get(COLORS);
    _sizes = snapshot.get(SIZES);
    _name = snapshot.get(NAME);
    _picture = snapshot.get(PICTURE);
    _quantity = int.parse(snapshot.get(QUANTITY));
    //_vName = snapshot.get(VNAME);
    //_vId = snapshot.get(VID);
  }
}
