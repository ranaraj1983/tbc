import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbc/helpers/style.dart';
import 'package:tbc/models/product.dart';
import 'package:tbc/provider/user.dart';
import 'package:tbc/services/DataCollection.dart';
import 'package:tbc/widgets/Widget_Factory.dart';

class Festive extends StatefulWidget {
  final String festiveName;
  const Festive({Key key, this.festiveName}) : super(key: key);
  @override
  _Festive createState() => _Festive();
}

class _Festive extends State<Festive> {
  final _key = GlobalKey<ScaffoldState>();


  // Method to Submit Feedback and save it in Google Sheets

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: white,
      appBar: Widget_Factory().getAppBar(context, _key, "Home"),
      drawer: Widget_Factory().getNavigationDrawer(context),
      bottomNavigationBar: Widget_Factory().bottomNavigationAppBar(context),
      body: _getOfferPageBody(context, widget.festiveName),
    );
  }

  Widget _getOfferPageBody(BuildContext context, String offer) {
    final userProvider = Provider.of<UserProvider>(context);
    return FutureBuilder(
        future: DataCollection().getProductsCollectionByFestiveType(offer),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading...."),
            );
          } else {
            return GridView.builder(
                primary: true,
                physics: ScrollPhysics(),
                //padding: const EdgeInsets.all(5.0),
                shrinkWrap: true,
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  ProductModel productModel = ProductModel.fromSnapshot(
                      snapshot.data.docs[index]);
                  DocumentSnapshot data = snapshot.data.docs[index];
                  ProductModel product = ProductModel.fromSnapshot(data);
                  int price = DataCollection().getProductPrice(
                      product, userProvider.userModel);
                  return Widget_Factory().commonProductCard(
                      context, data.get('picture'), data.get('name'), price,
                      productModel);
                  //return _getPopularProducts(price, productModel, data, context);
                });
          }
        });
/*    return Container(
      //height: 300,
      child:

      Text(offer == null ? "0":offer),
    );*/

  }
}