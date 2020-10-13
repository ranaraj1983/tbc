import 'package:tbc/models/product.dart';
import 'package:tbc/provider/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbc/provider/user.dart';
import 'package:tbc/screens/product_details.dart';
import 'package:tbc/services/DataCollection.dart';
import 'package:tbc/widgets/Widget_Factory.dart';

import 'featured_card.dart';

class FeaturedProducts extends StatefulWidget {
  @override
  _FeaturedProductsState createState() => _FeaturedProductsState();
}

class _FeaturedProductsState extends State<FeaturedProducts> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Container(
        height: 230,
        child: FutureBuilder(
            future: DataCollection().getProductsCollection(),
            builder: (_, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Loading...."),
                );
              } else {

                return GridView.builder(
                    primary: true,
                    physics: ScrollPhysics(),
                    padding: const EdgeInsets.all(5.0),
                    shrinkWrap: true,
                    gridDelegate:
                    new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var d = snapshot.data;
                      ProductModel productModel = ProductModel.fromSnapshot(snapshot.data[index]);
                      int price =  DataCollection().getProductPrice(snapshot.data[index], userProvider.userModel);
                      print(price);
                      return GestureDetector(

                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetails(product: productModel,)));
                        },
                        child: Column(
                          children: <Widget>[
                            Widget_Factory().getImageFromDatabase(context,
                                snapshot.data[index].get('picture')),
                            Expanded(
                              child:
                              Text(snapshot.data[index].documentID + " ${price}"
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
            }),

      /*ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productProvider.products.length,
            itemBuilder: (_, index) {
              return FeaturedCard(
                product: productProvider.products[index],
              );
            })*/
    );
  }
}
