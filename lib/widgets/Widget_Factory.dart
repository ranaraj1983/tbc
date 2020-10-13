import 'dart:math';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_drawer/curved_drawer.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tbc/Admin_Screen.dart';
import 'package:tbc/helpers/CategoryCard.dart';
import 'package:tbc/helpers/Product.dart';
import 'package:tbc/helpers/SectionTitle.dart';
import 'package:tbc/helpers/SizeConfig.dart';
import 'package:tbc/helpers/SpecialOfferCard.dart';
import 'package:tbc/helpers/TBCSearchDelegate.dart';
import 'package:tbc/helpers/common.dart';
import 'package:tbc/helpers/style.dart';
import 'package:tbc/models/product.dart';
import 'package:tbc/models/user.dart';
import 'package:tbc/provider/app.dart';
import 'package:tbc/provider/product.dart';
import 'package:tbc/provider/user.dart';
import 'package:tbc/screens/Category.dart';
import 'package:tbc/screens/Offer.dart';
import 'package:tbc/screens/Payment_Screen.dart';
import 'package:tbc/screens/ProductList.dart';
import 'package:tbc/screens/Support.dart';
import 'package:tbc/screens/Terms_And_Condition.dart';
import 'package:tbc/screens/add_address.dart';
import 'package:tbc/screens/cart.dart';
import 'package:tbc/screens/home.dart';
import 'package:tbc/screens/login.dart';
import 'package:tbc/screens/order.dart';
import 'package:tbc/screens/product_details.dart';
import 'package:tbc/screens/product_search.dart';
import 'package:tbc/screens/profile.dart';
import 'package:tbc/services/DataCollection.dart';
import 'package:tbc/widgets/custom_text.dart';
import 'package:tbc/widgets/featured_products.dart';
import 'package:tbc/widgets/loading.dart';
import 'package:tbc/widgets/product_card.dart';
import 'package:tbc/widgets/scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:uuid/uuid.dart';

class Widget_Factory{

  Widget getAppBar(BuildContext context, GlobalKey<ScaffoldState> _key, String titleText){
    //final CartItemModel = Provider.of<>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return AppBar(
      title: Text(titleText, style: TextStyle(fontSize: 18, color: Colors.white70),),
      elevation: 10,
      backgroundColor: Colors.lightGreen,
      actions: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: (){
                showSearch(
                  context: context,
                  delegate: TBCSearchDelegate(),
                );

              },
            child: Icon(Icons.search),
          ),


          //Icon(Icons.search),
        ),
        userProvider.userModel != null ? userProvider.userModel.userType == "EMP" ?
        Padding(
          padding: EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){

              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScannerWidget()));

            },
            child: Icon(Icons.qr_code_scanner_sharp),
          ),


          //Icon(Icons.search),
        )
        : Text("")
        : Text(""),

        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.notifications),
        ),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                changeScreen(context, CartScreen()
              );
            },
              child:  Badge(
                badgeColor: Colors.blue,
                badgeContent: userProvider.userModel != null ? Text(
                  userProvider.userModel.cart != null ? userProvider.userModel.cart.length.toString() : 0.toString(),
                  style: TextStyle(color: Colors.white),
                ) : Text(0.toString()),
                child: Icon(Icons.shopping_cart, color: Colors.black),
              ),
            )),
    //Icon(Icons.shopping_cart))),

        Padding(
          padding: EdgeInsets.all(8.0),
          child: GestureDetector(
              child:Icon(Icons.more_vert),
              onTap: (){
                _key.currentState.openEndDrawer();
                print("more");
              }),

        ),
      ],
    );
  }
  Widget getRightDrawer(BuildContext context){
    final userProvider = Provider.of<UserProvider>(context);
    if(userProvider.status == Status.Authenticated){

    } else if(userProvider.status == Status.Uninitialized){

    }else{

    }
    return Drawer(
      child: userProvider.status == Status.Authenticated ? ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            accountName: CustomText(
              text: userProvider.userModel?.name ?? "username lading...",
              color: Colors.white,
              weight: FontWeight.bold,
              size: 18,
            ),
            accountEmail: CustomText(
              text: userProvider.userModel?.email ?? "email loading...",
              color: Colors.white,
            ),
          ),
          ListTile(
            onTap: () async{
              await userProvider.getOrders();
              changeScreen(context, OrdersScreen());
            },
            leading: Icon(Icons.bookmark_border),
            title: CustomText(text: "My orders"),
          ),

          ListTile(
            onTap: () {
                userProvider.signOut();
                changeScreen(context, HomePage());
            },
            leading: Icon(Icons.exit_to_app),
            title: CustomText(text: "Log out"),
          ),

          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Admin()));
              print("admin");
            },
            leading: Icon(Icons.exit_to_app),
            title: CustomText(text: "Admin"),
          ),
        ],
      ) : ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()));
            },
            leading: Icon(Icons.exit_to_app),
            title: CustomText(text: "Log in"),
          ),

          ListTile(
            onTap: () {
              userProvider.signOut();
            },
            leading: Icon(Icons.exit_to_app),
            title: CustomText(text: "Admin"),
          ),
        ],
      ),
    );
  }
  Widget getNavigationDrawer(BuildContext context){
    int index = 0;
    double leftWidth = 75.0;
    int leftTextColor = 1;
    int leftBackgroundColor = 0;
    double rightWidth = 75.0;
    int rightTextColor = 1;
    int rightBackgroundColor = 0;
    final List<Color> colorPallete = <Color>[
      Colors.white, Colors.black, Colors.blue, Colors.blueAccent, Colors.red,
      Colors.redAccent, Colors.teal, Colors.orange, Colors.pink, Colors.purple,
      Colors.lime, Colors.green
    ];
    final user = Provider.of<UserProvider>(context);
    //UserModel user =
    return Drawer(
      child: new ListView(
        children: <Widget>[
           UserAccountsDrawerHeader(
             accountName: user.userModel !=null ? Text(user.userModel.name) : Text(""),
             accountEmail: user.userModel !=null ? Text(user.userModel.email) : Text(""),
             currentAccountPicture: CircleAvatar(
               backgroundColor: Colors.yellowAccent,
             ),
           ),
          ListTile(
            title: new Text("Home"),
            trailing: new Icon(Icons.home_sharp),
            onTap: () {

              changeScreen(context, HomePage());
            },
          ),
          user.userModel != null ?ListTile(
            title: new Text("Profile"),
            trailing: new Icon(Icons.local_offer_sharp),
            onTap: () {

              changeScreen(context, Profile());
            },
          ) : Text(""),
           ListTile(
            title: new Text("Category"),
            trailing: new Icon(Icons.category),
             onTap: () {

               changeScreen(context, Category());
             },
          ),
           ListTile(
            title: new Text("Offer"),
            trailing: new Icon(Icons.local_offer_sharp),
             onTap: () {

               changeScreen(context, Offer());
             },
          ),


          ListTile(
            title: new Text("Wish list"),
            trailing: new Icon(Icons.transfer_within_a_station_sharp),
            onTap: () {

              changeScreen(context, CartScreen());
            },
          ),
          user.userModel != null ?
          ListTile(
            onTap: () async{
              await user.getOrders();
              changeScreen(context, OrdersScreen());
            },
            trailing: Icon(Icons.bookmark_border),
            title: CustomText(text: "My orders"),
          )
          : Text(""),
          user.userModel != null ? ListTile(
            onTap: () {
              user.signOut();
              changeScreen(context, HomePage());
            },
            trailing: Icon(Icons.exit_to_app),
            title: CustomText(text: "Log out"),
          )
          : ListTile(
            onTap: () {
              user.signOut();
              changeScreen(context, Login());
            },
            trailing: Icon(Icons.login),
            title: CustomText(text: "Log in"),
          ),
          ListTile(
            title: new Text("Terms"),
            trailing: new Icon(Icons.privacy_tip_rounded),
            onTap: () {

              changeScreen(context, Terms_And_Condition());
            },
          ),
          ListTile(
            title: new Text("Support"),
            trailing: new Icon(Icons.support_agent),
            onTap: () {

              changeScreen(context, Support());
            },
          ),

          user.userModel == null ? Text("") :
          user.userModel.userType == "EMP" ? ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Admin()));
              print("admin");
            },
            trailing: Icon(Icons.exit_to_app),
            title: CustomText(text: "Admin"),
          )
          : Text(""),
        ],
      ),
    );
    List<DrawerItem> _drawerItems = <DrawerItem>[
     // DrawerItem(icon: personIcon),
      DrawerItem(icon: Icon(Icons.people), label: "People"),
      DrawerItem(icon: Icon(Icons.trending_up), label: "Trending"),
      //DrawerItem(icon: Icon(Icons.tv)),
      //DrawerItem(icon: Icon(Icons.work), label: "Work"),
      //DrawerItem(icon: Icon(Icons.web)),
      //DrawerItem(icon: Icon(Icons.videogame_asset)),
      //DrawerItem(icon: Icon(Icons.book), label: "Book"),
     // DrawerItem(icon: Icon(Icons.call), label: "Telephone")
    ];
    //return Drawer();

      /*CurvedDrawer(
      index: index,
      width: leftWidth,
      color: colorPallete[leftBackgroundColor],
      buttonBackgroundColor: colorPallete[leftBackgroundColor],
      labelColor: colorPallete[leftTextColor],
      items: _drawerItems,
      onTap: (newIndex){
        *//*setState(() {
          index = newIndex;
        });*//*
      },
    );*/
  }


  Widget bottomNavigationAppBar(BuildContext context){
    GlobalKey _bottomNavigationKey = GlobalKey();
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      color: Colors.white,
      buttonBackgroundColor: Colors.white,
      backgroundColor: Colors.deepOrange,
      animationCurve: Curves.easeInExpo,
      animationDuration: Duration(milliseconds: 60),
      items: <Widget>[

        GestureDetector(
            child:Icon(Icons.account_circle, size: 30,),
            onTap: (){

              print("more");
            }),
        GestureDetector(
            child:Icon(Icons.local_offer_sharp, size: 30,),
            onTap: (){

              print("more");
            }),
        GestureDetector(
              child:Icon(Icons.home, size: 30,),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              }),


        //Icon(Icons.home, size: 30),
      ],
      onTap: (index) {

      },
    );
  }

  Widget getBannerCarousel(BuildContext context) {
    final List<String> imgList = [
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
    ];
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        pauseAutoPlayOnTouch: true,
        aspectRatio: 2.0,
      ),
      items: imgList.map((item) => Container(
        child: Container(
            height: MediaQuery.of(context).size.height*0.30,
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Image.network(item, fit: BoxFit.cover,),
            )
        ),
      )).toList(),
    );

  }

  Widget getCategoryGridList(BuildContext context) {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(10, (index) {
        return Center(
          child: Card(
            child: Text(
              'getCategoryGridList $index',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        );
      }),
    );
  }

  Widget getOfferProductList(BuildContext context) {

    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(10, (index) {
        return Center(
          child: Card(
            child: Text(
              'getOfferProductList $index',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        );
      }),
    );

  }

  Widget getTopProductList(BuildContext context) {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(10, (index) {
        return Center(
          child: Card(
            child: Text(
              'getTopProductList $index',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        );
      }),
    );
  }

  int getProductPrice(UserModel user, ProductModel product){
    int price = 0;
    String userType;
    user == null ? price = product.cprice : userType = user.userType;

    userType == "EMP" ?
        price = product.mprice
        :
    userType == "RESELLER" ?
      price = product.rprice
        :
    userType == "WHOLESALER" ?
      price = product.wprice
        :
    userType == "CUSTOMER" ?
      price = product.cprice
        :
     price = product.cprice;

    return price;
    //return TextSpan(text: '\₹ ${price} \n', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold));
  }

  Widget getProfilePageBody(BuildContext context, GlobalKey<ScaffoldState> _key){
    final userProvider = Provider.of<UserProvider>(context);
    return new Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: Colors.black.withOpacity(0.8)),
          clipper: getClipper(),
        ),
        Positioned(
            width: MediaQuery.of(context).size.width,
            right: MediaQuery.of(context).size.width / 5,
            //top: MediaQuery.of(context).size.height / 20,
            child: Column(
              children: <Widget>[

                   Column(
                    children: [
                      Text(
                        userProvider.userModel.name,
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Colors.white
                        ),
                      ),
                      Text(
                        userProvider.userModel.mobile,
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Colors.white
                        ),
                      ),
                      Text(
                        userProvider.userModel.userType,
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Colors.white
                        ),
                      ),
                      Text(
                        userProvider.userModel.email,
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),


                Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ])),
                SizedBox(height: 90.0),

                SizedBox(height: 15.0),
                Text(
                  'Address',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 25.0),
                Container(
                    height: 30.0,
                    width: 95.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.greenAccent,
                      color: Colors.green,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () {
                          changeScreen(context, AddAddress());
                        },
                        child: Center(
                          child: Text(
                            'View Address',
                            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    )),
                SizedBox(height: 25.0),
                Container(
                    height: 30.0,
                    width: 95.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.redAccent,
                      color: Colors.red,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () {
                          userProvider.signOut();
                          changeScreen(context, HomePage());
                        },
                        child: Center(
                          child: Text(
                            'Log out',
                            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ))
              ],
            ))
      ],
    );
  }


  Widget getHomePageBody(BuildContext context, GlobalKey<ScaffoldState> _key) {


    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenWidth(10)),
            _discountBanner(),
            _categories(context),
            _specialOffers(),
            SizedBox(height: getProportionateScreenWidth(30)),
            _popularProducts(context),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),



      /*ListView(
        children: <Widget>[
//           Custom App bar
      *//*    Stack(
            children: <Widget>[
              Positioned(
                top: 10,
                right: 20,

                child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                        onTap: () {
                          _key.currentState.openEndDrawer();
                        },
                        child: Icon(Icons.menu))),
              ),
              Positioned(
                top: 10,
                right: 60,
                child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                        onTap: (){
                          changeScreen(context, CartScreen());
                        },
                        child: Icon(Icons.shopping_cart))),
              ),
              Positioned(
                top: 10,
                right: 100,
                child: Align(
                    alignment: Alignment.topRight, child: GestureDetector(
                    onTap: (){
                      _key.currentState.showSnackBar(SnackBar(
                          content: Text("User profile")));
                    },
                    child: Icon(Icons.person))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'What are\nyou Shopping for?',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),*//*

//          Search Text field
//            Search(),

          *//*Container(
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 8, right: 8, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  title: TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (pattern)async{
                      await productProvider.search(productName: pattern);

                      changeScreen(context, ProductSearchScreen());
                    },
                    decoration: InputDecoration(
                      hintText: "blazer, dress...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),*//*

//
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: new Text('Products')),
              ),
            ],
          ),
//            featured products
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: new Text('Featured products')),
              ),
            ],
          ),
          FeaturedProducts(),

//          recent products
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: new Text('Recent products')),
              ),
            ],
          ),

          Column(
            children: [
              FutureBuilder(
                  future: DataCollection().getProductsCollection(),
                  builder: (_, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text("Loading...."),
                      );
                    } else {

                      return GridView.builder(
                          primary: true,
                          physics: ScrollPhysics(),
                          padding: const EdgeInsets.all(5.0),
                          shrinkWrap: true,
                          gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            ProductModel productModel = ProductModel.fromSnapshot(snapshot.data[index]);
                            var d = snapshot.data;
                            int price =  DataCollection().getProductPrice(snapshot.data[index], userProvider.userModel);
                            print(price);
                            return GestureDetector(

                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetails(product: productModel,)));
                              },
                              child: Column(
                                children: <Widget>[
                                  Widget_Factory().getImageFromDatabase(context,
                                      snapshot.data[index].get('picture')),
                                  Expanded(
                                    child:
                                    Text(snapshot.data[index].documentID + " ${price}"
                                        ),
                                  ),
                                ],
                              ),
                            );
                          });
                    }
                  }),
            ],
          ),
          *//*Column(
            children: productProvider.products
                .map((item) => GestureDetector(
              child: ProductCard(
                product: item,
              ),
            ))
                .toList(),
          )*//*
        ],
      ),*/
    );
  }
  Widget getSearchListView(
      BuildContext context, var categorySnapshot, var itemSnapshot) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        SingleChildScrollView(
          child: Card(
            color: Colors.indigo,
            child: GestureDetector(
              onTap: () {
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Item_Details(
                              toolbarname: itemSnapshot.data['itemName'],
                              dataSource: itemSnapshot,
                            )
                    )
                );*/
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _populateSearchList(
                            context, categorySnapshot, itemSnapshot),
                      ),
                      Expanded(
                        child: getImageFromDatabase(
                            context, itemSnapshot.data['imageUrl']),
                      ),
                      Expanded(
                        child: addToCartButton(itemSnapshot),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _populateSearchList(BuildContext context, var categorySnapshot,
      var itemSnapshot) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Wrap(
            children: [
              Text(
                itemSnapshot.data['itemName'],
                style: GoogleFonts.roboto(
                  //textStyle: Theme.of(context).textTheme.headline5,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  //fontStyle: FontStyle.normal,
                  color: Colors.yellowAccent,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Wrap(
            children: [
              Text(
                "\₹" + itemSnapshot.data['price'],
                style: GoogleFonts.roboto(
                  //textStyle: Theme.of(context).textTheme.headline5,
                  fontSize: 25,
                  color: Colors.yellowAccent,
                  //fontWeight: FontWeight.w400,
                  //fontStyle: FontStyle.normal,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ]);
  }

  Widget addToCartButton(itemSnapshot) {
    int quantity = 1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        alignment: Alignment.center,
        child: RaisedButton(
            color: Colors.yellowAccent,
            child: const Text('Add'),
            textColor: Colors.black,
            onPressed: () {
              int random = new Random().nextInt(1000);
              if (quantity <= 0) quantity = 1;
              /*Custom_AppBar().addItemToCart(
                  itemSnapshot.data['itemId'],
                  itemSnapshot.data['itemName'],
                  itemSnapshot.data['imageUrl'],
                  itemSnapshot.data['description'],
                  quantity.toString(),
                  (int.parse(itemSnapshot.data['price']) * quantity).toString(),
                  random.toString() + "_" + itemSnapshot.data['itemName']);*/
            },
            shape: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            )),
      ),
    );
  }
  Widget getImageFromDatabase(BuildContext context, String imageUrl) {
    return (imageUrl == null
        ? Container(
        height: 100,
        width: 100,
        child: Image.asset("images/noprofileimage.png")
    )
        : FutureBuilder(
        future: DataCollection()
            .getImageFromStorage(context, imageUrl, 100, 100),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Stack(
                children: <Widget>[
                  snapshot.data == null
                      ? Container(
                      height: 100,
                      width: 100,
                      child: Image.asset("images/noprofileimage.png"))

                  /*Image.network(
                          'https://www.fakenamegenerator.com/images/sil-female.png')*/
                      : snapshot.data,
                  //snapshot.data,
                ],
              ),
            );
          } else {
            return Container(
              child: CircularProgressIndicator(),
            );
          }
        }
    )
    );
  }

  Widget getCartPageBOdy(BuildContext context, GlobalKey<ScaffoldState> _key) {

    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    return userProvider.userModel.cart == null ? Text("") : SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child:  ListView.builder(

                shrinkWrap: true,
                itemCount: userProvider.userModel.cart.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                                color: red.withOpacity(0.2),
                                offset: Offset(3, 2),
                                blurRadius: 30)
                          ]),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                            child: Image.network(
                              userProvider.userModel.cart[index].image,
                              height: 120,
                              width: 140,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: userProvider
                                              .userModel.cart[index].name +
                                              "\n",
                                          style: TextStyle(
                                              color: black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text:
                                          "\₹ ${userProvider.userModel.cart[index].price } \n\n",
                                          style: TextStyle(
                                              color: black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300)),
                                    ]),
                                  ),
                                ),

                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: red,
                                    ),
                                    onPressed: () async {
                                      appProvider.changeIsLoading();
                                      bool success =
                                      await userProvider.removeFromCart(
                                          cartItem: userProvider
                                              .userModel.cart[index]);
                                      if (success) {
                                        userProvider.reloadUserModel();
                                        print("Item added to cart");
                                        _key.currentState.showSnackBar(SnackBar(
                                            content: Text("Removed from Cart!")));
                                        appProvider.changeIsLoading();
                                        return;
                                      } else {
                                        appProvider.changeIsLoading();
                                      }
                                    })
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),



          Container(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Total: ",
                          style: TextStyle(
                              color: grey,
                              fontSize: 22,
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: " \₹ ${userProvider.userModel.totalCartPrice }",
                          style: TextStyle(
                              color: black,
                              fontSize: 22,
                              fontWeight: FontWeight.normal)),
                    ]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), color: black),
                    child: FlatButton(
                        onPressed: () {
                          if (userProvider.userModel.totalCartPrice == 0) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0)),
                                    //this right here
                                    child: Container(
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Your cart is empty',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                            return;
                          }
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)),
                                  //this right here
                                  child: Container(
                                    height: 200,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'You will be charged \₹ ${userProvider.userModel.totalCartPrice} ',
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 320.0,
                                            child: RaisedButton(
                                              onPressed: () async {
                                                var uuid = Uuid();
                                                String id = uuid.v4();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Payment_Screen()));
                                                /*_orderServices.createOrder(
                                                userId: userProvider.user.uid,
                                                id: id,
                                                description:
                                                    "Some random description",
                                                status: "complete",
                                                totalPrice: userProvider
                                                    .userModel.totalCartPrice,
                                                cart: userProvider
                                                    .userModel.cart);
                                            for (CartItemModel cartItem
                                                in userProvider
                                                    .userModel.cart) {
                                              bool value = await userProvider
                                                  .removeFromCart(
                                                      cartItem: cartItem);
                                              if (value) {
                                                userProvider.reloadUserModel();
                                                print("Item added to cart");
                                                _key.currentState.showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "Removed from Cart!")));
                                              } else {
                                                print("ITEM WAS NOT REMOVED");
                                              }
                                            }
                                            _key.currentState.showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Order created!")));
                                            Navigator.pop(context);*/
                                              },
                                              child: Text(
                                                "Accept",
                                                style:
                                                TextStyle(color: Colors.white),
                                              ),
                                              color: const Color(0xFF1BC0C5),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 320.0,
                                            child: RaisedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Reject",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: red),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: CustomText(
                          text: "Check out",
                          size: 20,
                          color: white,
                          weight: FontWeight.normal,
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }

  Widget getProductDetailsPage(BuildContext context,
      GlobalKey<ScaffoldState> _key, ProductDetails widget, String _color,
      double _size) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    int price = Widget_Factory().getProductPrice(userProvider.userModel, widget.product);
    return SafeArea(
        child: Container(
          color: Colors.black.withOpacity(0.9),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Loading(),
                      )),
                  Center(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.product.picture,
                      fit: BoxFit.fill,
                      height: 400,
                      width: double.infinity,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          // Box decoration takes a gradient
                          gradient: LinearGradient(
                            // Where the linear gradient begins and ends
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            colors: [
                              // Colors are easy thanks to Flutter's Colors class.
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.07),
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.025),
                            ],
                          ),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container())),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 400,
                        decoration: BoxDecoration(
                          // Box decoration takes a gradient
                          gradient: LinearGradient(
                            // Where the linear gradient begins and ends
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            colors: [
                              // Colors are easy thanks to Flutter's Colors class.
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.6),
                              Colors.black.withOpacity(0.6),
                              Colors.black.withOpacity(0.4),
                              Colors.black.withOpacity(0.07),
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.025),
                            ],
                          ),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container())),
                  ),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                widget.product.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '\₹ ${price}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                    right: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          changeScreen(context, CartScreen());
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.shopping_cart),
                              ),
                            )),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          //print("CLICKED");
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: red,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(35))),
                          child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(2, 5),
                            blurRadius: 10)
                      ]),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: CustomText(
                                text: "Select a Color",
                                color: white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(widget.product.colors),
                              /*DropdownButton<String>(
                                value: _color,
                                style: TextStyle(color: white),
                                items: widget.product.colors
                                    .map<DropdownMenuItem<String>>(
                                        (value) => DropdownMenuItem(
                                            value: value,
                                            child: CustomText(
                                              text: value,
                                              color: red,
                                            )))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _color = value;
                                  });
                                }),*/
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: CustomText(
                                text: "Select a Size",
                                color: white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(widget.product.sizes.toString()),
                              /*DropdownButton<String>(
                                value: _size.toString(),
                                style: TextStyle(color: white),
                                items: widget.product.sizes
                                    .map<DropdownMenuItem<String>>(
                                        (value) => DropdownMenuItem(
                                            value: value.toString(),
                                            child: CustomText(
                                              text: value.toString(),
                                              color: red,
                                            )))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _size = double.parse(value);
                                  });
                                }),*/
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              widget.product.description,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(9),
                        child: Material(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                            elevation: 0.0,
                            child: MaterialButton(
                              onPressed: () async {
                                appProvider.changeIsLoading();
                                bool success = await userProvider.addToCart(
                                    product: widget.product,
                                    color: _color,
                                    size: _size.toString(), price: price);
                                if (success) {
                                  _key.currentState.showSnackBar(
                                      SnackBar(content: Text("Added to Cart!")));
                                  userProvider.reloadUserModel();
                                  appProvider.changeIsLoading();
                                  return;
                                } else {
                                  _key.currentState.showSnackBar(SnackBar(
                                      content: Text("Not added to Cart!")));
                                  appProvider.changeIsLoading();
                                  return;
                                }
                              },
                              minWidth: MediaQuery.of(context).size.width,
                              child: appProvider.isLoading
                                  ? Loading()
                                  : Text(
                                "Add to cart",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget getOrderPageBody(BuildContext context) {
    return FutureBuilder(
        future: DataCollection().getOrderCollection(),
        builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
                  child: Text("Loading...."),
          );
          } else {
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (_, index){
                //OrderModel _order = userProvider.orders[index];
                return ListTile(
                  leading: CustomText(
                    text: "\₹" + snapshot.data.docs[index].get("total").toString(),
                    weight: FontWeight.bold,
                  ),
                  title: Text(snapshot.data.docs[index].get("description")),
                  subtitle: Text(DateTime.fromMillisecondsSinceEpoch(snapshot.data.docs[index].get("createdAt")).toString()),
                  trailing: CustomText(text: snapshot.data.docs[index].get("status"), color: green,),
                );
              });
          }
        }
    );

  }

  Widget getAddressPageBody(BuildContext context, GlobalKey<ScaffoldState> key) {
    TextEditingController _sName = TextEditingController();
    TextEditingController _sStreet = TextEditingController();
    TextEditingController _sPin = TextEditingController();
    TextEditingController _sCity = TextEditingController();
    TextEditingController _sState = TextEditingController();
    TextEditingController _sCountry = TextEditingController();
    TextEditingController _sEmail = TextEditingController();
    TextEditingController _sMobile = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final _key = GlobalKey<ScaffoldState>();
    final user = Provider.of<UserProvider>(context);

    return Container(
       child: ListView(
                   shrinkWrap: true,
                   physics: const ScrollPhysics(),
                   scrollDirection: Axis.vertical,
                   children: <Widget>[
                     SizedBox(height: 40,),
                     new ListTile(
                       leading: const Icon(Icons.person),
                       title: new TextField(
                         enabled: true,
                         decoration: new InputDecoration(
                           hintText: "Name",
                         ),
                       ),
                     ),
                     Padding(
                       padding:
                       const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                       child: Material(
                         borderRadius: BorderRadius.circular(10.0),
                         color: Colors.grey.withOpacity(0.3),
                         elevation: 0.0,
                         child: Padding(
                           padding: const EdgeInsets.only(left: 12.0),
                           child: ListTile(
                             title: TextFormField(
                               controller: _sName,

                               decoration: InputDecoration(
                                   hintText: "Full name",
                                   //icon: Icon(Icons.person_outline),
                                   border: InputBorder.none),
                               validator: (value) {
                                 if (value.isEmpty) {
                                   return "The name field cannot be empty";
                                 }
                                 return null;
                               },
                             ),
                           ),
                         ),
                       ),
                     ),
                     Padding(
                       padding:
                       const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                       child: Material(
                         borderRadius: BorderRadius.circular(10.0),
                         color: Colors.grey.withOpacity(0.3),
                         elevation: 0.0,
                         child: Padding(
                           padding: const EdgeInsets.only(left: 12.0),
                           child: ListTile(
                             title: TextFormField(
                               controller: _sStreet,
                               decoration: InputDecoration(
                                   hintText: "Street Address",
                                   icon: Icon(Icons.person_outline),
                                   border: InputBorder.none),
                               validator: (value) {
                                 if (value.isEmpty) {
                                   return "The name field cannot be empty";
                                 }
                                 return null;
                               },
                             ),
                           ),
                         ),
                       ),
                     ),
                     Padding(
                       padding:
                       const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                       child: Material(
                         borderRadius: BorderRadius.circular(10.0),
                         color: Colors.grey.withOpacity(0.3),
                         elevation: 0.0,
                         child: Padding(
                           padding: const EdgeInsets.only(left: 12.0),
                           child: ListTile(
                             title: TextFormField(
                               controller: _sCity,
                               decoration: InputDecoration(
                                   hintText: "City",
                                   icon: Icon(Icons.person_outline),
                                   border: InputBorder.none),
                               validator: (value) {
                                 if (value.isEmpty) {
                                   return "The name field cannot be empty";
                                 }
                                 return null;
                               },
                             ),
                           ),
                         ),
                       ),
                     ),
                     Padding(
                       padding:
                       const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                       child: Material(
                         borderRadius: BorderRadius.circular(10.0),
                         color: Colors.grey.withOpacity(0.3),
                         elevation: 0.0,
                         child: Padding(
                           padding: const EdgeInsets.only(left: 12.0),
                           child: ListTile(
                             title: TextFormField(
                               controller: _sCountry,
                               decoration: InputDecoration(
                                   hintText: "Country",
                                   icon: Icon(Icons.person_outline),
                                   border: InputBorder.none),
                               validator: (value) {
                                 if (value.isEmpty) {
                                   return "The name field cannot be empty";
                                 }
                                 return null;
                               },
                             ),
                           ),
                         ),
                       ),
                     ),
                     Padding(
                       padding:
                       const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                       child: Material(
                         borderRadius: BorderRadius.circular(10.0),
                         color: Colors.grey.withOpacity(0.3),
                         elevation: 0.0,
                         child: Padding(
                           padding: const EdgeInsets.only(left: 12.0),
                           child: ListTile(
                             title: TextFormField(
                               controller: _sState,
                               decoration: InputDecoration(
                                   hintText: "State",
                                   icon: Icon(Icons.person_outline),
                                   border: InputBorder.none),
                               validator: (value) {
                                 if (value.isEmpty) {
                                   return "The name field cannot be empty";
                                 }
                                 return null;
                               },
                             ),
                           ),
                         ),
                       ),
                     ),
                     Padding(
                       padding:
                       const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                       child: Material(
                         borderRadius: BorderRadius.circular(10.0),
                         color: Colors.grey.withOpacity(0.3),
                         elevation: 0.0,
                         child: Padding(
                           padding: const EdgeInsets.only(left: 12.0),
                           child: ListTile(
                             title: TextFormField(
                               controller: _sPin,
                               //keyboardType: TextInputType.number,
                               decoration: InputDecoration(
                                   hintText: "Pin",
                                   icon: Icon(Icons.person_outline),
                                   border: InputBorder.none),
                               validator: (value) {
                                 if (value.isEmpty) {
                                   return "The name field cannot be empty";
                                 }
                                 return null;
                               },
                             ),
                           ),
                         ),
                       ),
                     ),
                     Padding(
                       padding:
                       const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                       child: Material(
                         borderRadius: BorderRadius.circular(10.0),
                         color: Colors.grey.withOpacity(0.3),
                         elevation: 0.0,
                         child: Padding(
                           padding: const EdgeInsets.only(left: 12.0),
                           child: ListTile(
                             title: TextFormField(
                               controller: _sMobile,
                               //keyboardType: TextInputType.number,
                               decoration: InputDecoration(
                                   hintText: "Mobile",
                                   icon: Icon(Icons.person_outline),
                                   border: InputBorder.none),
                               validator: (value) {
                                 if (value.isEmpty) {
                                   return "The name field cannot be empty";
                                 }
                                 return null;
                               },
                             ),
                           ),
                         ),
                       ),
                     ),
                     Padding(
                       padding:
                       const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                       child: Material(
                           borderRadius: BorderRadius.circular(20.0),
                           color: Colors.black,
                           elevation: 0.0,
                           child: MaterialButton(
                             onPressed: () async{
                              /* await user.addAddress(_sName.text ,_sStreet.text,
                                   _sCountry.text,_sState.text, _sCity.text, _sPin.text, _sMobile.text);*/
                               //if(_formKey.currentState.validate()){
                                 if(!await user.addAddress(_sName.text ,_sStreet.text,
                                     _sCountry.text,_sState.text, _sCity.text, _sPin.text, _sMobile.text)){
                                   _key.currentState.showSnackBar(SnackBar(content: Text("Sign up failed")));
                                   return;
                                 }
                                 //changeScreenReplacement(context, HomePage());
                               //}
                             },
                             minWidth: MediaQuery.of(context).size.width,
                             child: Text(
                               "Add Address",
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                   color: white,
                                   fontWeight: FontWeight.bold,
                                   fontSize: 20.0),
                             ),
                           )),
                     ),
                   ]
               )

            /*Row(
             children: [
                 FutureBuilder(
                 future: DataCollection().getListOfAddress(),
                   builder: (_, AsyncSnapshot snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting) {
                       return Center(
                         child: Text("Loading...."),
                       );
                     } else {
                       return ListView.builder(
                           itemCount: snapshot.data.docs.length,
                           itemBuilder: (_, index){
                             //OrderModel _order = userProvider.orders[index];
                             return ListTile(
                               leading: CustomText(
                                 text: "\₹" + snapshot.data.docs[index].get("total").toString(),
                                 weight: FontWeight.bold,
                               ),
                               title: Text(snapshot.data.docs[index].get("description")),
                               subtitle: Text(DateTime.fromMillisecondsSinceEpoch(snapshot.data.docs[index].get("createdAt")).toString()),
                               trailing: CustomText(text: snapshot.data.docs[index].get("status"), color: green,),
                             );
                           });
                     }
                   }
               )
             ],
           ),*/


     );


  }

  Widget _discountBanner() {
    return Container(
      // height: 90,
      width: double.infinity,
      margin: EdgeInsets.all(getProportionateScreenWidth(20)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenWidth(15),
      ),
      decoration: BoxDecoration(
        color: Color(0xFF4A3298),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(text: "A Summer Surpise\n"),
            TextSpan(
              text: "Cashback 20%",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(24),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categories(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/icons/Flash Icon.svg", "text": "Linen"},
      {"icon": "assets/icons/Bill Icon.svg", "text": "Cotton"},
      {"icon": "assets/icons/Game Icon.svg", "text": "Tushar"},
      {"icon": "assets/icons/Gift Icon.svg", "text": "Resham"},
      {"icon": "assets/icons/Discover.svg", "text": "Natural"},
    ];
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
              (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press: () {
              changeScreen(context, ProductList(categories[index]["text"]));
              print(categories[index]["text"]);
            },
          ),
        ),
      ),
    );
  }

  Widget _specialOffers() {
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "Special for you",
            press: () {},
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SpecialOfferCard(
                image: "assets/images/Image Banner 2.png",
                category: "Smartphone",
                numOfBrands: 18,
                press: () {},
              ),
              SpecialOfferCard(
                image: "assets/images/Image Banner 3.png",
                category: "Fashion",
                numOfBrands: 24,
                press: () {},
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        ),
      ],
    );

  }

  Widget _popularProducts(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Popular Products", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(

            children: [

              FutureBuilder(
                  future: DataCollection().getProductsCollection(),
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
                              crossAxisCount: 3),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            ProductModel productModel = ProductModel.fromSnapshot(snapshot.data[index]);
                            var d = snapshot.data;
                            int price =  DataCollection().getProductPrice(snapshot.data[index], userProvider.userModel);
                            print(price);
                            return GestureDetector(

                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetails(product: productModel,)));
                              },
                              child: Column(
                                children: <Widget>[
                                  Widget_Factory().getImageFromDatabase(context,
                                      snapshot.data[index].get('picture')),
                                  Expanded(
                                    child:
                                    Text(snapshot.data[index].documentID + " ${price}"
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    }
                  }),
              /*...List.generate(
                demoProducts.length,
                    (index) {
                  //if (demoProducts[index].isPopular)
                    //return ProductCard(product: demoProducts[index]);

                  return SizedBox
                      .shrink(); // here by default width and height is 0
                },
              ),*/
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        )
      ],
    );
  }

  Widget getProductListPageBody(BuildContext context, GlobalKey<ScaffoldState> key, String categoryName) {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          FutureBuilder(
              future: DataCollection().getProductsCollectionByCategory(categoryName.toUpperCase()),
              builder: (_, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text("Loading...."),
                  );
                } else {

                  return GridView.builder(
                      primary: true,
                      physics: ScrollPhysics(),
                      padding: const EdgeInsets.all(5.0),
                      shrinkWrap: true,
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        ProductModel productModel = ProductModel.fromSnapshot(snapshot.data.docs[index]);
                        var d = snapshot.data.docs;
                        int price =  DataCollection().getProductPrice(snapshot.data.docs[index], userProvider.userModel);
                        print(price);
                        return GestureDetector(

                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetails(product: productModel,)));
                          },
                          child: Column(
                            children: <Widget>[
                              Widget_Factory().getImageFromDatabase(context,
                                  snapshot.data.docs[index].get('picture')),
                              Expanded(
                                child:
                                Text(snapshot.data.docs[index].documentID + " ${price}"
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }
              }),
        ],
      ),
    );
  }

  Widget getCategoryPageBody(BuildContext context, GlobalKey<ScaffoldState> key) {

  }

}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}