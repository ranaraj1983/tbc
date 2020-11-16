
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tbc/models/address.dart';
import 'package:tbc/models/product.dart';
import 'package:tbc/models/user.dart';

class DataCollection{

  final firestoreInstance = FirebaseFirestore.instance;

  Future getListOfProductItem() async {

    QuerySnapshot qs =
    await firestoreInstance.collection("categories").get();
    return qs.docs;
  }

  Future getCategoryList() async {
    QuerySnapshot qs =
    await firestoreInstance.collection("categories").get();
    return qs.docs;
  }

  Future<Widget> getImageFromStorage(BuildContext context,
      String imageUrl) async {
    return await _getImageFromStorage(imageUrl);
  }

  Future<Widget> _getImageFromStorage(String imageUrl) async {
    //CachedNetworkImage m;
    StorageReference storageReference = await FirebaseStorage.instance
        .getReferenceFromUrl(imageUrl);

    return await storageReference.getDownloadURL().then((value) {
      return CachedNetworkImage(
        //height: height,
        //width: width,
        fit: BoxFit.cover,
        imageUrl: value.toString(),
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );

    });
  }

  Future getProductsCollectionWithLimit(int limit) async {
    QuerySnapshot qs = await firestoreInstance
        .collection("products").limit(limit)
        .get();
    return qs.docs;
  }

  Future getProductsCollection() async {
    QuerySnapshot qs = await firestoreInstance
        .collection("products")
        .get();
    return qs.docs;
  }

  Future getSubCollectionWithSearchKey(String documentId,
      String searchKey) async {
    QuerySnapshot qs = await firestoreInstance
        .collection("products")

    //.where("itemName", searchKey)
        .get();


    return qs.docs;
  }

/*  Future<QuerySnapshot> getProductById(String id) async {
    return await firestoreInstance
        .collection("products").where("id", isEqualTo: id).get();*//*.then((result) {
      ProductModel product;
      for (DocumentSnapshot product in result.docs) {
        ProductModel.fromSnapshot(product);
      }
      return product;
    });*//*
  }*/

  getProductById(String searchId) async{
     return await firestoreInstance
        .collection("products").where("id", isEqualTo: searchId).get();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

   Future<String> getUserType() =>
       _auth.currentUser == null ?  null : firestoreInstance
          .collection("users").where("uid", isEqualTo: _auth.currentUser.uid).get().then(
              (value) {
                String userType;
                for(DocumentSnapshot ds in value.docs){
                  userType = ds.get("userType");
                   //print()
                }
                return userType;
                //print(value.docs.),
              });

  getUserDetails(String uid) {
    return firestoreInstance
        .collection("users").where("uid", isEqualTo: uid).get();
  }


  int getProductPrice(ProductModel data, UserModel user) {

    int price = 0;
    String userType;

    user == null ? price = data.cprice: userType = user.userType;

    userType == "EMP" ?
    price = data.mprice
        :
    userType == "RESELLER" ?
    price = data.rprice
        :
    userType == "WHOLESALER" ?
    price = data.wprice
        :
    userType == "CUSTOMER" ?
    price = data.cprice
        :
    userType == "ADMIN" ?
    price = data.mprice
        :
    userType == "LRESELLER" ?
    price = data.lprice
        :
    price = data.cprice;

    return price;
  }

  Future getOrderCollection() async{
    return _auth.currentUser == null ?  null : await firestoreInstance
        .collection("orders").where("userId", isEqualTo: _auth.currentUser.uid).get();
  }

  Future getListOfAddress() async{
    return  _auth.currentUser == null ?  null : await firestoreInstance
        .collection("orders").where("userId", isEqualTo: _auth.currentUser.uid).get();
  }

  Future getProductsCollectionByCategory(String categoryName, String filterType) async{

    QuerySnapshot qs =  await firestoreInstance
        .collection("products").where("${filterType}", isEqualTo: categoryName).get();
    return qs;
  }

  void sellProductFromApp(ProductModel productModel) {
    
  }

  Future getCustomerList() async{
    return await firestoreInstance
        .collection("users").where("userType", isEqualTo: "CUSTOMER").get();
  }

  int getNumberOfUser() {}
  int getNumberOfOrder(){}
  Future<int> getNumberOfCategory() async{
    int size = 0;
    QuerySnapshot qs = await firestoreInstance
        .collection("categories")
        .get();
    qs.docs.forEach((element) {
      size = element.data()['Category'].length;
    });
    return size;
  }
  Future<int> getNumberOProduct() async{
    QuerySnapshot qs = await firestoreInstance
        .collection("products")
        .get();
    return qs.docs.length;
  }
  int getNumberOfOrderReturned(){}

  Future getProductsCollectionByOfferType(String offer) async{
     QuerySnapshot qs = await firestoreInstance
        .collection("products").where("discount", isEqualTo: int.parse(offer)).get();
    return qs;
  }

  Future getProductsCollectionByFestiveType(String festiveName) async{
    QuerySnapshot qs = await firestoreInstance
        .collection("products").where("festive", isEqualTo: int.parse(festiveName)).get();
    return qs;
  }

  Future getProductsCollectionBySeasonType(String seasonName) async{
    QuerySnapshot qs = await firestoreInstance
        .collection("products").where("season", isEqualTo: int.parse(seasonName)).get();
    return qs;
  }
}
