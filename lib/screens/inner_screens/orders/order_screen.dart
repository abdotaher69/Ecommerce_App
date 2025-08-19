import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app2/models/order_model.dart';
import 'package:ecommerce_app2/providers/orders_provider.dart';
import 'package:ecommerce_app2/screens/inner_screens/orders/order_widget.dart';
import 'package:ecommerce_app2/utilities/assets_manager.dart';
import 'package:ecommerce_app2/widgets/empty_bag_widget.dart';
import 'package:flutter/material.dart';
import '../../../widgets/title_text.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreenFree({Key? key}) : super(key: key);

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  final OrderProvider ordersProvider = OrderProvider();
  bool isEmptyOrders = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TitleText(text: 'Placed orders')),
      body: FutureBuilder <List<OrdersModelAdvanced>>(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: SelectableText("An error has occurred: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(child: Text("No orders found."));
          } else {
            final orders = snapshot.data as List;
            return ListView.separated(
              itemCount: orders.length, // snapshot.data length
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                  child: OrdersWidgetFree(order: ordersProvider.getOrders[index]), // pass order if needed
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            );
          }
        },
      ),
    );
  }
}

// isEmptyOrders
// ? EmptyBagWidget(
// imagePath: AssetsManager.orderBag,
// title: "No orders has been placed yet",
// subtitle: "",
// buttonText: "Shop now")
//     : ListView.separated(
// itemCount: 15,
// itemBuilder: (ctx, index) {
// return const Padding(
// padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
// child: OrdersWidgetFree(),
// );
// },
// separatorBuilder: (BuildContext context, int index) {
// return const Divider();
// },
// ));
// }
