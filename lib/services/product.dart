import 'package:tbc/Util/ProductForm.dart';
import 'package:tbc/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'DataCollection.dart';

class ProductServices {
  String collection = "products";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProducts(
      String name, String categoryName, String des, bool isFeaturedProduct, int quantity,
      String id, String imageUrlList, int price, String brandName, bool isSale,
      double size, String color) async{
    //var id = Uuid();
    //String categoryId = id.v1();
    List<String> colors = new List();
    colors.add(color);

    List<double> sizes = new List();
    sizes.add(size);
    _firestore.collection(collection).doc(id).set(
        {
          'name': name,
          'category' : categoryName,
          //'createdDate' : new DateTime.now(),
          'id': id,
          "picture" : imageUrlList,
          "price" : price,
          "description" : des,
          "featured" : isFeaturedProduct,
          "quantity" : quantity,
          "brand" : brandName,
          "sale" : isSale,
          "sizes": sizes,
          "colors" : colors,

        }
        );
  }

  Future<void> addProductsFromGDatabase(
      ProductForm product) async{
    print(product);
    _firestore.collection(collection).doc(product.name).set(
        {
          'id': product.id,
          'name': product.name,
          'cprice': product.cprice,
          'picture': product.picture,
          "sale" : false,
          "featured" : false,
          "vendorName":product.vendorName,
          "artisanImage":product.artisanImage,
          "artisanName":product.artisanName,
          "brand":product.brand,
          "colors":product.colors,
          "weight":product.weight,
          "size":product.size,
          "quantity":product.quantity,
          "vprice":product.vprice,
          "wprice":product.wprice,
          "lprice":product.lprice,
          "mprice":product.mprice,
          "rprice":product.rprice,
          "description":product.description,
          "category":product.category.toUpperCase()

        }
    );
  }


  Future<List<ProductModel>> getProducts() async =>
      _firestore.collection(collection).get().then((result) async{
        List<ProductModel> products = [];
        String userType = await DataCollection().getUserType();
        for (DocumentSnapshot product in result.docs) {
          ProductModel productModel = ProductModel.fromSnapshot(product);
          print(userType);
          productModel.userType = userType;
          if(userType == null){
            productModel.price = productModel.cprice;
          } else if(productModel.userType == "EMP"){
            //productModel.
            productModel.price = productModel.mprice;
          } else if(productModel.userType == "RESELLER"){
            productModel.price = productModel.rprice;
          }
          print(productModel.toString());
          print(productModel.price.toString());
          //products.add(productModel);
          //productModel.userType = "EMP";
          products.add(productModel);
          //return products;
        }

        return products;
      });

  Future<ProductModel> getProductById(String id) async =>
      _firestore
          .collection("products").where("id", isEqualTo: id).get().then((result) {
        ProductModel product ;
        for (DocumentSnapshot product in result.docs) {
          ProductModel.fromSnapshot(product);

        }
        return product;
      });


  Future<List<ProductModel>> searchProducts({String productName}) {
    // code to convert the first character to uppercase
    String searchKey = productName[0].toUpperCase() + productName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .get()
        .then((result) {
      List<ProductModel> products = [];
      for (DocumentSnapshot product in result.docs) {
        products.add(ProductModel.fromSnapshot(product));
      }
      return products;
    });
  }


}
