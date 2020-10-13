import 'package:tbc/widgets/Widget_Factory.dart';
import 'package:tbc/models/product.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({Key key, this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _key = GlobalKey<ScaffoldState>();
  String _color = "";
  double _size = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _color = widget.product.colors[0];
    _size = widget.product.sizes;
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: _key,
      appBar: Widget_Factory().getAppBar(context, _key, "Product"),
      drawer: Widget_Factory().getNavigationDrawer(context),
      bottomNavigationBar: Widget_Factory().bottomNavigationAppBar(context),
      //endDrawer: Widget_Factory().getRightDrawer(context),
      body: Widget_Factory().getProductDetailsPage(context,_key,widget, _color, _size),
    );
  }
}
