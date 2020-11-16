import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tbc/helpers/style.dart';
import 'package:tbc/provider/user.dart';
import 'package:tbc/screens/home.dart';
import 'package:tbc/screens/order.dart';
import 'package:tbc/widgets/Widget_Factory.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class Payment_Screen extends StatefulWidget {

  String custName;
  Payment_Screen(this.custName);

  @override
  State<StatefulWidget> createState() => _Paymet_Screen();
}

class _Paymet_Screen extends State<Payment_Screen> {
  //String custName;
  //_Payment_Screen(this.custName);
  final _key = GlobalKey<ScaffoldState>();
  //double totalAmount = 0;
  Razorpay razorpay;
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  void openCheckout(){
    final user = Provider.of<UserProvider>(context,listen: false);
    var options = {
      //"key" : "rzp_live_lniFtCKqALjDUY",
      "key" : "rzp_test_zPkqQnWPAgL6Bq",//test key
      "amount" : user.userModel.totalCartPrice*100,
      "name" : "Your purchase value",
      "description" : "Payment for the some random product",
      "prefill" : {
        "contact" : user.userModel.mobile,
        "email" : user.userModel.email
      },
      "external" : {
        "wallets" : ["paytm"]
      }
    };

    try{
      razorpay.open(options);

    }catch(e){
      print(e.toString());
    }

  }

  void handlerPaymentSuccess(PaymentSuccessResponse response){
    //print("Pament success" + response.orderId);
    print("Payment success"+  response.paymentId);
    var uuid = Uuid();
    String orderId = uuid.v4();
    _createOrder(response.paymentId, orderId);
    _clearCart();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OrdersScreen()));
  }

  void handlerErrorFailure(){
    print("Payment error");
    Toast.show("Payment error", context);
  }

  void handlerExternalWallet(){
    print("External Wallet");
    Toast.show("External Wallet", context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _key,
      backgroundColor: white,
      appBar: Widget_Factory().getAppBar(context, _key, "Payment Screen"),
      drawer: Widget_Factory().getNavigationDrawer(context),
      bottomNavigationBar: Widget_Factory().bottomNavigationAppBar(context),

      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            /*TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                  hintText: "amount to pay"
              ),
            ),*/
            SizedBox(height: 12,),
            RaisedButton(
              color: Colors.blue,
              child: Text("Pay Online", style: TextStyle(
                  color: Colors.white
              ),),
              onPressed: (){
                openCheckout();
              },
            ),
            Text(this.widget.custName),
            SizedBox(height: 12,),
            RaisedButton(
              color: Colors.blue,
              child: Text("Pay by Cash", style: TextStyle(
                  color: Colors.white
              ),),
              onPressed: (){
                _chashPaymentOption();
              },
            )
          ],
        ),
      ),
    );
  }

  void _createOrder(String paymentId, String orderId) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.createOrder("Cash Payment placed successfully", "SUCCESS",
        userProvider.userModel.totalCartPrice, paymentId, orderId);
  }

  void _clearCart() {

  }

  void _chashPaymentOption() {
    print("Cash Payment success");
    var uuid = Uuid();
    String orderId = uuid.v4();
    String paymentId = uuid.v4();
    _createOrder(paymentId, orderId);
    _clearCart();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OrdersScreen()));
  }



}