import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app2/models/cart_model.dart';
import 'package:ecommerce_app2/models/product_model.dart';
import 'package:ecommerce_app2/providers/product_provider.dart';
import 'package:ecommerce_app2/utilities/app_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> cartItems = {};
  Map<String, CartModel> get getCartItems {
    return cartItems;
  }

  void addToCart({required String productId}) {
    cartItems.putIfAbsent(
      productId,
      () => CartModel(cartId: Uuid().v4(), productId: productId, quantity: 1),
    );
    notifyListeners();
  }

  bool isItemInCart(String productId) {
    return cartItems.containsKey(productId);
  }

  void updateQuantity({required String productId, required String quantity}) {
    cartItems.update(
      productId,
      (value) => CartModel(
        cartId: value.cartId,
        productId: value.productId,
        quantity: int.parse(quantity),
      ),
    );
    notifyListeners();
  }

  double getTotal({required ProductProvider productProvider}) {
    double total = 0.0;
    cartItems.forEach((key, value) {
      final ProductModel? getCurrProduct = productProvider.findProductById(
        value.productId,
      );
      if (getCurrProduct == null) {
        total += 0;
      } else {
        total += double.parse(getCurrProduct.productPrice) * value.quantity;
      }
    });

    return total;
  }

  void removeOneItem({required String productId}) {
    cartItems.remove(productId);
    notifyListeners();
  }

  void clearLocalCart() {
    cartItems.clear();
    notifyListeners();
  }

  int getQty() {
    int total = 0;
    cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  final usersDB = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;
  Future<void> addToCartFirebase({
    required String productId,
    required int qty,
    required BuildContext context,
  }) async {
    final User? user = auth.currentUser;
    if (user == null) {
      AppMethods.showErrorDialog(
        context: context,
        title: "No user found",
        function: () {},
      );
      return;
    }
    final uid = user.uid;
    final cartId = const Uuid().v4();
    try {
      usersDB.doc(uid).update({
        'userCart': FieldValue.arrayUnion([
          {"cartId": cartId, "productId": productId, "quantity": qty},
        ]),
      });
      Fluttertoast.showToast(
        msg: "Product has been added",
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
      );
      fetCartFirebase(context: context);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetCartFirebase({required BuildContext context}) async {
    final User? user = auth.currentUser;
    if (user == null) {
      cartItems.clear();
      AppMethods.showErrorDialog(
        context: context,
        title: "No user found",
        function: () {},
      );
      return;
    }
    try {
      final userDoc = await usersDB.doc(user.uid).get();
      final userData = userDoc.data();
      if (userData == null || !userData.containsKey('userCart')) {
        return;
      }
      final leng = userDoc.get("userCart").length;
      for (int index = 0; index < leng; index++) {
        cartItems.putIfAbsent(
          userDoc.get('userCart')[index]['productId'],
          () => CartModel(
            cartId: userDoc.get('userCart')[index]['cartId'],
            productId: userDoc.get('userCart')[index]['productId'],
            quantity: userDoc.get('userCart')[index]['quantity'],
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeCartFirebase({required BuildContext context}) async {
    final User? user = auth.currentUser;
    usersDB.doc(user!.uid).update({'userCart': []});
    cartItems.clear();
    notifyListeners();
  }

  Future<void> removeCartItemFirebase({
    required BuildContext context,
    required String productId,
    required int qty,
    required String cartId,
  }) async {
    final User? user = auth.currentUser;
    usersDB.doc(user!.uid).update({'userCart': FieldValue.arrayRemove([
      {"cartId": cartId, "productId": productId, "quantity": qty},
    ])});
    cartItems.remove(productId);
    fetCartFirebase(context: context);
    notifyListeners();
  }
}
