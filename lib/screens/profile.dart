import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tbc/helpers/style.dart';
import 'package:tbc/screens/add_address.dart';
import 'package:tbc/widgets/Widget_Factory.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
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