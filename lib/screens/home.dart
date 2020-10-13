import 'package:provider/provider.dart';
import 'package:tbc/provider/product.dart';
import 'package:tbc/widgets/Widget_Factory.dart';
import 'package:tbc/helpers/style.dart';
import 'package:tbc/services/product.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();

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
      //endDrawer: Widget_Factory().getRightDrawer(context),
      body: Widget_Factory().getHomePageBody(context, _key),
    );
  }
}
