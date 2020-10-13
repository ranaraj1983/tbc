import 'package:tbc/models/cart_item.dart';
import 'package:tbc/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderServices{
  String collection = "orders";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createOrder({String userId ,String id,String description,String status ,List<CartItemModel> cart, int totalPrice}) {
    List<Map> convertedCart = [];

    for(CartItemModel item in cart){
      convertedCart.add(item.toMap());
      _updateQuantity(item);
    }

    _firestore.collection(collection).doc(id).set({
      "userId": userId,
      "id": id,
      "cart": convertedCart,
      "total": totalPrice,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "description": description,
      "status": status
    });

  }

  Future<List<OrderModel>> getUserOrders({String userId}) async =>
      _firestore
          .collection(collection)
          .where("userId", isEqualTo: userId)
          .get()
          .then((result) {
        List<OrderModel> orders = [];
        for (DocumentSnapshot order in result.docs) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });

  void _updateQuantity(CartItemModel item) async  {
    DocumentSnapshot quantity;
    quantity  = await _firestore.collection("products").doc(item.name).get();
    int quan = int.parse(quantity.get("quantity")) - 1;
     await _firestore.collection("products").doc(item.name). set ({

    "quantity": quan.toString(),

    }, SetOptions(merge : true));
  }

}