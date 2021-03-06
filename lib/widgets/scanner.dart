import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tbc/helpers/style.dart';
import 'package:tbc/models/product.dart';
import 'package:tbc/models/user.dart';
import 'package:tbc/provider/app.dart';
import 'package:tbc/provider/user.dart';
import 'package:tbc/services/DataCollection.dart';
import 'package:tbc/widgets/Widget_Factory.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ScannerWidget extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ScannerWidget> {
  ScanResult scanResult;
  final _key = GlobalKey<ScaffoldState>();

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
  @override
  // ignore: type_annotate_public_apis
  initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    var contentList = <Widget>[
      if (scanResult != null)

        Card(
          child: Column(
            children: <Widget>[
              /*ListTile(
                title: Text("Result Type"),
                subtitle: Text(scanResult.type?.toString() ?? ""),
              ),
              ListTile(
                title: Text("Raw Content"),
                subtitle: Text(scanResult.rawContent ?? ""),
              ),
              ListTile(
                title: Text("Format"),
                subtitle: Text(scanResult.format?.toString() ?? ""),
              ),
              ListTile(
                title: Text("Format note"),
                subtitle: Text(scanResult.formatNote ?? ""),
              ),*/

              FutureBuilder(
                future: DataCollection().getProductById(scanResult.rawContent),
                builder: (_, AsyncSnapshot snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Text("Loading...."),
                    );
                  } else {
                    _weight = snapshot.data.docs[0].data()['weight'].toString();
                    ProductModel productModel = ProductModel.fromSnapshot(snapshot.data.docs[0]);
                    print(_value);
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

                    int price = Widget_Factory().getProductPrice(userType, productModel);
                    return snapshot.data.docs.length !=0 ? Column(
                      children: [
                        FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: snapshot.data.docs[0].data()['picture'],
                          fit: BoxFit.cover,
                          height: 140,
                          width: 120,
                        ),
                        Text("saree name : " + productModel.name),
                        Text("customer price : " + productModel.cprice.toString()),
                        Text("Reseller price : " + productModel.rprice.toString()),
                        Text("Wholesaler price : " + productModel.wprice.toString()),
                        Text("Member price : " + productModel.mprice.toString()),
                        Text("Local reseller price : " + productModel.lprice.toString()),

                        Text("Size  : " + productModel.sizes.toString()),
                        Text("Weight  : " + productModel.weight.toString()),
                        Text("Stock  : " + productModel.quantity.toString()),
                        RaisedButton(
                          child: Text("Sell"),
                          onPressed: productModel.quantity <=0 ? null : () async{
                            bool success = await userProvider.addToCart(
                                product: productModel,
                                color: productModel.colors,
                                size: productModel.sizes.toString(), price: price);
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
                    ) : Text("No Product Found");
                    /*return GridView.builder(
                        primary: true,
                        physics: ScrollPhysics(),
                        padding: const EdgeInsets.all(5.0),
                        shrinkWrap: true,
                        gridDelegate:
                        new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          var d = snapshot.data;
                          return Text(d.toString());
                          //print(snapshot.data[index].documentID);
                         });*/

                  }
                }
              ),
            ],
          ),
        ),
      IconButton(
        icon: Icon(Icons.camera),
        tooltip: "Scan",
        onPressed: scan,
      ),
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
      ListTile(
        title: Text("Courier Charge"),
        dense: true,
        enabled: false,
      ),

      TextField(
        controller: _pincodeController,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Pin Code',
        ),
      ),
      RaisedButton(
        onPressed: () {
          print( _weight + " clicked " + _pincodeController.text);
          _getCourierCharge(_weight, _pincodeController.text);
        },
        child: const Text('Get Price', style: TextStyle(fontSize: 20)),
      ),
     /* RadioListTile(
        onChanged: (v) => setState(() => _selectedCamera = -1),
        value: -1,
        title: Text("Default camera"),
        groupValue: _selectedCamera,
      ),*/
    ];

   /* for (var i = 0; i < _numberOfCameras; i++) {
      contentList.add(RadioListTile(
        onChanged: (v) => setState(() => _selectedCamera = i),
        value: i,
        title: Text("Camera ${i + 1}"),
        groupValue: _selectedCamera,
      ));
    }*/

    /*contentList.addAll([
      ListTile(
        title: Text("Button Texts"),
        dense: true,
        enabled: false,
      ),
      ListTile(
        title: TextField(
          decoration: InputDecoration(
            hasFloatingPlaceholder: true,
            labelText: "Flash On",
          ),
          controller: _flashOnController,
        ),
      ),
      ListTile(
        title: TextField(
          decoration: InputDecoration(
            hasFloatingPlaceholder: true,
            labelText: "Flash Off",
          ),
          controller: _flashOffController,
        ),
      ),
      ListTile(
        title: TextField(
          decoration: InputDecoration(
            hasFloatingPlaceholder: true,
            labelText: "Cancel",
          ),
          controller: _cancelController,
        ),
      ),
    ]);*/

    /*if (Platform.isAndroid) {
      contentList.addAll([
        ListTile(
          title: Text("Android specific options"),
          dense: true,
          enabled: false,
        ),
        ListTile(
          title:
          Text("Aspect tolerance (${_aspectTolerance.toStringAsFixed(2)})"),
          subtitle: Slider(
            min: -1.0,
            max: 1.0,
            value: _aspectTolerance,
            onChanged: (value) {
              setState(() {
                _aspectTolerance = value;
              });
            },
          ),
        ),
        CheckboxListTile(
          title: Text("Use autofocus"),
          value: _useAutoFocus,
          onChanged: (checked) {
            setState(() {
              _useAutoFocus = checked;
            });
          },
        )
      ]);
    }*/

   /* contentList.addAll([
      ListTile(
        title: Text("Other options"),
        dense: true,
        enabled: false,
      ),
      CheckboxListTile(
        title: Text("Start with flash"),
        value: _autoEnableFlash,
        onChanged: (checked) {
          setState(() {
            _autoEnableFlash = checked;
          });
        },
      )
    ]);*/

   /* contentList.addAll([
      ListTile(
        title: Text("Barcode formats"),
        dense: true,
        enabled: false,
      ),
      ListTile(
        trailing: Checkbox(
          tristate: true,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: selectedFormats.length == _possibleFormats.length
              ? true
              : selectedFormats.length == 0 ? false : null,
          onChanged: (checked) {
            setState(() {
              selectedFormats = [
                if (checked ?? false) ..._possibleFormats,
              ];
            });
          },
        ),
        dense: true,
        enabled: false,
        title: Text("Detect barcode formats"),
        subtitle: Text(
          'If all are unselected, all possible platform formats will be used',
        ),
      ),
    ]);
*/


    return  Scaffold(
      key: _key,
      backgroundColor: white,
      appBar: Widget_Factory().getAppBar(context, _key, "Home"),
      drawer: Widget_Factory().getNavigationDrawer(context),
      bottomNavigationBar: Widget_Factory().bottomNavigationAppBar(context),
      //endDrawer: Widget_Factory().getRightDrawer(context),
      body: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: contentList,
            ),
    );

    /*MaterialApp(
        key: _key,
        backgroundColor: white,
        appBar: Widget_Factory().getAppBar(context, _key, "Home"),
        drawer: Widget_Factory().getNavigationDrawer(context),
        bottomNavigationBar: Widget_Factory().bottomNavigationAppBar(context),
        //endDrawer: Widget_Factory().getRightDrawer(context),
        body: Widget_Factory().getHomePageBody(context, _key),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Barcode Scanner '),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.camera),
              tooltip: "Scan",
              onPressed: scan,
            )
          ],
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: contentList,
        ),
      ),
    );*/
  }

  Future scan() async {
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

      if(scanResult !=null) {
        //ProductModel product =  await DataCollection().getProductById(scanResult.rawContent);
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


  void _getCourierCharge(String weight, String text) async{

    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text('Hello World!'),
        ),
      ),
    );

    final file = File('example.pdf');
    file.writeAsBytesSync(doc.save());
    /*final response = await http.post('https://api.shyplite.com/pricecalculator', headers:
    {
      "x-appid": "4957",
      "x-sellerid":"33549",
      "x-timestamp: $timestamp",
      "x-version:3", // for auth version 3.0 only
      "Authorization: $authtoken",
      "Content-Type: application/json",
      "Content-Length: ".strlen($data_json)
    }
        { "sourcePin": "110062",
          "destinationPin": "208019",
          "orderType": "1",
          "modeType": "1",    // Optional, if you are using the auth v3
          "length": "12",
          "width": "14",
          "height": "3",
          "weight": "0.5",
          "invoiceValue": "2"
      }
    );*/

    /*if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return null;//Album.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }*/
  }

}