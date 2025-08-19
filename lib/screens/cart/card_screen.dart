import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app2/providers/cart_provider.dart';
import 'package:ecommerce_app2/providers/product_provider.dart';
import 'package:ecommerce_app2/providers/users_provider.dart';
import 'package:ecommerce_app2/screens/cart/buttom_checkout.dart';
import 'package:ecommerce_app2/screens/cart/card_widget.dart';
import 'package:ecommerce_app2/screens/loading_manager.dart';
import 'package:ecommerce_app2/utilities/app_methods.dart';
import 'package:ecommerce_app2/utilities/assets_manager.dart';
import 'package:ecommerce_app2/widgets/app_name_text.dart';
import 'package:ecommerce_app2/widgets/empty_bag_widget.dart';
import 'package:ecommerce_app2/widgets/subtitle_text.dart';
import 'package:ecommerce_app2/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
   bool isEmpty = false;
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);


    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.shoppingBasket,
              title: "Your cart is Empty",
              subtitle:
                  "Looks Like you did not added any thing yet \n            add some items to get started",
              buttonText: "Shop Now",
            ),
          )
        : LoadingManager(
            isLoading: isLoading,
          child: Scaffold(
              bottomSheet: ButtomCheckout(function: ()async{
                await placeOrder(cartProvider: cartProvider, productProvider: Provider.of<ProductProvider>(context,listen: false), userProvider: userProvider);
              }),
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: TitleText(
                  text: "Cart(${cartProvider.getCartItems.length})",
                  fontSize: 30,
                ),
                leading: Image.asset(AssetsManager.shoppingCart),
                actions: [
                  IconButton(
                    onPressed: () {
                      AppMethods.showErrorDialog(
                        context: context,
                        title: "remove all items",
                        isError: false,
                        function: () {
                          cartProvider.removeCartFirebase(context: context);
                        },
                      );
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ListView.builder(
                  itemCount: cartProvider.getCartItems.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: cartProvider.getCartItems.values
                          .toList()
                          .reversed
                          .toList()[index],
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: CardWidget(),
                      ),
                    );
                  },
                ),
              ),
            ),
        );
  }

  Future<void> placeOrder({required CartProvider cartProvider,required ProductProvider productProvider,required UserProvider userProvider}) async {
    final auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    try{
      setState(() {
        isLoading=true;
      });
      cartProvider.getCartItems.forEach((key, value) async {
        // Get the product details
        final getCurrProduct =
        productProvider.findProductById(value.productId);

        // Generate unique order id
        final orderId = const Uuid().v4();

        // Save to Firestore
        await FirebaseFirestore.instance
            .collection("ordersAdvanced")
            .doc(orderId)
            .set({
          'orderId': orderId,
          'userId': uid,
          'productId': value.productId,
          'productTitle': getCurrProduct!.productTitle,
          'price': double.parse(getCurrProduct.productPrice) * value.quantity,
          'totalPrice': cartProvider.getTotal(productProvider: productProvider),
          'quantity': value.quantity,
          'imageUrl': getCurrProduct.productImage,
          'userName': userProvider.getUserModel()!.userName,
          'orderDate': Timestamp.now(),
        });
      });
      cartProvider.removeCartFirebase(context: context);
      cartProvider.clearLocalCart();

    }catch(e){
      AppMethods.showErrorDialog(context: context, title: "error", function: (){});

    }finally{
      setState(() {
        isLoading=false;
      });
    }
  }
}
