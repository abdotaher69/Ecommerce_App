import 'package:ecommerce_app2/models/cart_model.dart';
import 'package:ecommerce_app2/models/product_model.dart';
import 'package:ecommerce_app2/models/whishlist_model.dart';
import 'package:ecommerce_app2/providers/product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class WishListProvider with ChangeNotifier {
  final Map<String, WishListModel> wishListItems = {};
  Map<String, WishListModel> get getWishListItems{
    return wishListItems;
  }
  bool isItemInWishList(String productId) {
    return wishListItems.containsKey(productId);
  }

  void addOrRemoveFromWishlist({required String productId}) {
    if (wishListItems.containsKey(productId)) {
      wishListItems.remove(productId);
      notifyListeners();
    } else {
      wishListItems.putIfAbsent(
        productId,
            () =>
                WishListModel(Id: Uuid().v4(), productId: productId),
      );
      notifyListeners();
    }
  }




  void clearLocalCart() {
    wishListItems.clear();
    notifyListeners();
  }

}
