import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tbc/Util/ProductForm.dart';
import 'package:tbc/Util/FormController.dart';
import 'package:tbc/helpers/style.dart';
import 'package:tbc/provider/app.dart';
import 'package:tbc/provider/user.dart';
import 'package:tbc/services/product.dart';
import 'package:tbc/widgets/Widget_Factory.dart';

class Scanner extends StatefulWidget {

  @override
  _Scanner createState() => _Scanner();
}

class _Scanner extends State<Scanner> {
  final _key = GlobalKey<ScaffoldState>();
  List<ProductForm> productItems = List<ProductForm>();
  ScanResult scanResult;
  ProductForm scanProduct;
  int price;

  final _flashOnController = TextEditingController(text: "Flash on");
  final _flashOffController = TextEditingController(text: "Flash off");
  final _cancelController = TextEditingController(text: "Cancel");

  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  var barCode = "";
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];
  TextEditingController _pincodeController = new TextEditingController();
  String _weight;
  int _value = 1;

  // Method to Submit Feedback and save it in Google Sheets

  @override
  void initState() {
    super.initState();

    FormController().getProductList().then((productItems) {
      setState(() {
        this.productItems = productItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: white,
      appBar: Widget_Factory().getAppBar(context, _key, "Home"),
      drawer: Widget_Factory().getNavigationDrawer(context),
      bottomNavigationBar: Widget_Factory().bottomNavigationAppBar(context),
      body: _getOfferPageBody(this.productItems),
    );
  }

  Widget _getOfferPageBody(List<ProductForm> product) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    //int price = ;
    return Column(
      children: [

        Text("Customer Type:- "),
        DropdownButton(
            value: _value,
            items: [
              DropdownMenuItem(
                child: Text("Customer"),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text("Local Reseller"),
                value: 2,
              ),
              DropdownMenuItem(
                  child: Text("Reseller"),
                  value: 3
              ),
              DropdownMenuItem(
                  child: Text("Member"),
                  value: 4
              ),
              DropdownMenuItem(
                  child: Text("Wholesaler"),
                  value: 5
              )
            ],
            onChanged: (value) {
              //print(value);
              setState(() {
                _value = value;
              });
            }),
        IconButton(
          icon: Icon(Icons.camera),
          tooltip: "Scan",
          onPressed: scan,
        ),
        scanProduct !=null ?Column(
          children: [

            Container(
              child: Image.network(
                scanProduct.picture,
                height:200,
                width:200,
              ),
            ),

            Text("Name :- " + scanProduct.name),
            Text("\nPrice :- " + price.toString()),
            Text("Size  : " + scanProduct.size.toString()),
            Text("Weight  : " + scanProduct.weight.toString()),
            Text("Stock  : " + scanProduct.quantity.toString()),
            RaisedButton(
              child: Text("Sell"),
              onPressed: int.parse(scanProduct.quantity) <=0 ? null : () async{
                bool success = await userProvider.addToCartGDataBase(
                    product: scanProduct,
                    color: scanProduct.colors,
                    size: scanProduct.size.toString(), price: price);
                if (success) {
                  /*_key.currentState.showSnackBar(
                                  SnackBar(content: Text("Added to Cart!")));*/
                  userProvider.reloadUserModel();
                  //appProvider.changeIsLoading();
                  return;
                } else {
                  /*_key.currentState.showSnackBar(SnackBar(
                                  content: Text("Not added to Cart!")));*/
                  appProvider.changeIsLoading();
                  return;
                }
                //DataCollection().sellProductFromApp(productModel);
                print(success);
              },
            ),
          ],

        ):Text("Image"),
        /*Container(
            height: 400,
            child: ListView.builder(
              itemCount: feedbackItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: <Widget>[

                      Image.network(

                        feedbackItems[index].picture,
                        height: 100.0,
                        width: 100.0,

                      ),

                      Icon(Icons.person),
                      Expanded(
                        child: Text(
                            "${feedbackItems[index].id} (${feedbackItems[index].name})"),
                      )
                    ],
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Icon(Icons.message),
                      Expanded(
                        child: Text(feedbackItems[index].cprice),
                      )
                    ],
                  ),
                );
              },
            ),
          ),*/
      ],

    );


  }
  int _getProductPrice(String userType, ProductForm product){
    int price = 0;
    //String userType;//String userType;
    //user == null ? price = product.cprice : userType = user.userType;

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
    userType == "LRESELLER" ?
    price = product.lprice
        :
    price = product.lprice;


    return price;
    //return TextSpan(text: '\₹ ${price} \n', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold));
  }
  Future scan() async {
    String userType;
    if(_value == 1){
      userType = "CUSTOMER";
    } else if(_value == 2){
      userType = "LRESELLER";
    }else if(_value == 3){
      userType = "RESELLER";
    }else if(_value == 4){
      userType = "EMP";
    }else if(_value == 5){
      userType = "WHOLESALER";
    }
    try {
      var options = ScanOptions(
        strings: {
          "cancel": _cancelController.text,
          "flash_on": _flashOnController.text,
          "flash_off": _flashOffController.text,
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);

      setState(() => scanResult = result);
      print(result.rawContent);
      if(scanResult !=null) {
        ProductForm product =  _getProductById(scanResult.rawContent);

        setState(() => scanProduct = product);
        if(product !=null)
          setState(() => price = _getProductPrice(userType, product));
        //print(product.name);

      }
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }
      setState(() {
        scanResult = result;
      });
    }
  }

  ProductForm _getProductById(String rawContent) {
    ProductForm productForm = null;
    productItems.forEach((product) {
      if(product.id == rawContent) {
        productForm = product;
        print(product.name);
      }
    });
    return productForm;
  }


}