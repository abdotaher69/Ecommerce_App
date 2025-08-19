import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecommerce_app2/providers/wishlist_provider.dart';
import 'package:ecommerce_app2/screens/cart/buttom_checkout.dart';
import 'package:ecommerce_app2/screens/cart/card_widget.dart';
import 'package:ecommerce_app2/utilities/app_methods.dart';
import 'package:ecommerce_app2/utilities/assets_manager.dart';
import 'package:ecommerce_app2/widgets/app_name_text.dart';
import 'package:ecommerce_app2/widgets/empty_bag_widget.dart';
import 'package:ecommerce_app2/widgets/products/product_widget.dart';
import 'package:ecommerce_app2/widgets/subtitle_text.dart';
import 'package:ecommerce_app2/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatelessWidget {
  static const String routeName = 'wish_list_screen';
  const WishListScreen({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    final WishListProvider wishListProvider = Provider.of<WishListProvider>(
      context,
    );
    return wishListProvider.getWishListItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.shoppingBasket,
              title: "Your Wish List is Empty",
              subtitle:
                  "Looks Like you did not Liked any thing yet \n            add some items to get started",
              buttonText: "Shop Now",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TitleText(text: "Your wish list", fontSize: 30),
              leading: Image.asset(AssetsManager.wishlistSvg),
              actions: [
                IconButton(
                  onPressed: () {
                    AppMethods.showErrorDialog(
                      context: context,
                      title: "remove all items",
                      isError: false,
                      function: () {
                        wishListProvider.clearLocalCart();
                      },
                    );
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),

            body: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: DynamicHeightGridView(
                builder: (context, index) {
                  return ProductWidget(
                    productId: wishListProvider.getWishListItems.values
                        .toList()[index]
                        .productId,
                  );
                },
                itemCount: wishListProvider.getWishListItems.length,
                crossAxisCount: 2,
              ),
            ),
          );
  }
}
