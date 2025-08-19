import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app2/models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {
  List<OrdersModelAdvanced>orders=[];
  List<OrdersModelAdvanced>get getOrders{
    return orders;
  }

  final orderDB=FirebaseFirestore.instance.collection('ordersAdvanced');
  Future<List<OrdersModelAdvanced>>fetchOrders()async{
    final user=FirebaseAuth.instance.currentUser;

    final uid=user!.uid;

    try {
      await orderDB.get().then((value) {
        orders.clear();
        for (var element in value.docs) {
          orders.insert(
            0,
            OrdersModelAdvanced(
              orderId: element.get('orderId'),
              productId: element.get('productId'),
              userId: element.get('userId'),
              price: element.get('price').toString(),
              productTitle: element.get('productTitle').toString(),
              quantity: element.get('quantity').toString(),
              imageUrl: element.get('imageUrl'),
              userName: element.get('userName'),
              orderDate: element.get('orderDate'),
            ),
          );
        }
      });
      return orders;
    }catch(e){
  rethrow;
    }


  }

}