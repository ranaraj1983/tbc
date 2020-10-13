import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tbc/Database_Service.dart';
import 'package:tbc/widgets/Widget_Factory.dart';

class Home_Page extends StatefulWidget {
  Home_Page({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home_Page> {
  Database_Service dbService = new Database_Service();
  final _key = GlobalKey<ScaffoldState>();

  void _incrementCounter() async{
    dbService.login();

  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = 0.0;//MediaQuery().data.size.width;
    final height = 0.0;//MediaQuery().data.size.height;
    return Scaffold(
      appBar: Widget_Factory().getAppBar(context, _key, "Home"),
      drawer: Widget_Factory().getNavigationDrawer(context),
      bottomNavigationBar: Widget_Factory().bottomNavigationAppBar(context),
      body: Container(
        //shrinkWrap: true,
        //physics: ScrollPhysics(),
        //width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              height: 300,
              child:
              Widget_Factory().getBannerCarousel(context),

            ),
            Container(
              height: 300,
              child:
              Widget_Factory().getCategoryGridList(context),

            ),
            Container(
              height: 300,
              child:
              Widget_Factory().getOfferProductList(context),

            ),

          ],
        ),


      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Login',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
