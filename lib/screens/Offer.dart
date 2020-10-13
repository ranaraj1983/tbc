import 'package:flutter/material.dart';
import 'package:tbc/helpers/style.dart';
import 'package:tbc/widgets/Widget_Factory.dart';

class Offer extends StatefulWidget {
  @override
  _Offer createState() => _Offer();
}

class _Offer extends State<Offer> {
  final _key = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _key,
      backgroundColor: white,
      appBar: Widget_Factory().getAppBar(context, _key, "Home"),
      drawer: Widget_Factory().getNavigationDrawer(context),
      bottomNavigationBar: Widget_Factory().bottomNavigationAppBar(context),
      //endDrawer: Widget_Factory().getRightDrawer(context),
      body: Widget_Factory().getProfilePageBody(context, _key),
    );
  }
}