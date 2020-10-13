import 'package:tbc/models/product.dart';
import 'package:tbc/services/product.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{
  ProductServices _productServices = ProductServices();
  List<ProductModel> products = [];
  List<ProductModel> productsSearched = [];
  ProductModel product ;


  ProductProvider.initialize(){
    loadProducts();
  }

  loadProducts()async{
    products = await _productServices.getProducts();
    //products = await _productServices.getProducts();
    notifyListeners();
  }

  getProductById(String id)async{
    product = await _productServices.getProductById(id);
    notifyListeners();
  }

  Future search({String productName})async{
    productsSearched = await _productServices.searchProducts(productName: productName);
    notifyListeners();
  }


}