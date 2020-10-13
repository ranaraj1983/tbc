import 'package:tbc/helpers/style.dart';
import 'package:tbc/models/order.dart';
import 'package:tbc/provider/app.dart';
import 'package:tbc/provider/user.dart';
import 'package:tbc/widgets/Widget_Factory.dart';
import 'package:tbc/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //Provider.of<UserProvider>(context).reloadUserModel();
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _key,
      backgroundColor: white,
      appBar: Widget_Factory().getAppBar(context, _key, "Home"),
      drawer: Widget_Factory().getNavigationDrawer(context),
      bottomNavigationBar: Widget_Factory().bottomNavigationAppBar(context),
      //endDrawer: Widget_Factory().getRightDrawer(context),
      body: Widget_Factory().getOrderPageBody(context),
    );
  }
}
