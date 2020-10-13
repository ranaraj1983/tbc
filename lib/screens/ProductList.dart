import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tbc/helpers/style.dart';
import 'package:tbc/screens/add_address.dart';
import 'package:tbc/widgets/Widget_Factory.dart';

class ProductList extends StatefulWidget {
  ProductList(this.category);
  String category;

  @override
  _ProductList createState() => _ProductList();
}

class _ProductList extends State<ProductList> {

  final _key = GlobalKey<ScaffoldState>();
  //String category;

  //_ProductList(category);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _key,
      backgroundColor: white,
      appBar: Widget_Factory().getAppBar(context, _key, widget.category),
      drawer: Widget_Factory().getNavigationDrawer(context),
      bottomNavigationBar: Widget_Factory().bottomNavigationAppBar(context),
      //endDrawer: Widget_Factory().getRightDrawer(context),
      body: Widget_Factory().getProductListPageBody(context, _key, widget.category),
    );
  }
}