import 'package:firebase_core/firebase_core.dart';
import 'package:tbc/helpers/SizeConfig.dart';
import 'package:tbc/provider/app.dart';
import 'package:tbc/provider/product.dart';
import 'package:tbc/provider/user.dart';
import 'package:tbc/screens/home.dart';
import 'package:tbc/screens/login.dart';
import 'package:tbc/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider.value(value: UserProvider.initialize()),
        ChangeNotifierProvider.value(value: ProductProvider.initialize()),
        ChangeNotifierProvider.value(value: AppProvider()),


      ], child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.white
            ),
            home: ScreensController(),
        ),
      )
  );
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return HomePage();
/*    switch(user.status){
      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return Login();
      case Status.Authenticated:
        return HomePage();
      default: return Login();
    }*/
  }
}




