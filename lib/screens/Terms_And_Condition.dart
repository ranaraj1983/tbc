import 'package:flutter/material.dart';
import 'package:tbc/helpers/style.dart';
import 'package:tbc/widgets/Widget_Factory.dart';

class Terms_And_Condition extends StatefulWidget {
  @override
  _Terms_And_Condition createState() => _Terms_And_Condition();
}

class _Terms_And_Condition extends State<Terms_And_Condition> {
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