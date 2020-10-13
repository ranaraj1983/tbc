import 'package:tbc/widgets/Widget_Factory.dart';
import 'package:tbc/helpers/style.dart';
import 'package:tbc/models/cart_item.dart';
import 'package:tbc/provider/app.dart';
import 'package:tbc/provider/user.dart';
import 'package:tbc/screens/Payment_Screen.dart';
import 'package:tbc/services/order.dart';
import 'package:tbc/widgets/custom_text.dart';
import 'package:tbc/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: Widget_Factory().getAppBar(context, _key, "Cart Page"),
      drawer: Widget_Factory().getNavigationDrawer(context),
      //endDrawer: Widget_Factory().getRightDrawer(context),
      body: appProvider.isLoading
          ? Loading()
          : Widget_Factory().getCartPageBOdy(context, _key),
      bottomNavigationBar: Widget_Factory().bottomNavigationAppBar(context),
      //bottomNavigationBar:
    );
  }
}
