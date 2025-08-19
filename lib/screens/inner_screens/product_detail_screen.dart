import 'package:ecommerce_app2/constants/app_constants.dart';
import 'package:ecommerce_app2/providers/cart_provider.dart';
import 'package:ecommerce_app2/providers/product_provider.dart';
import 'package:ecommerce_app2/utilities/assets_manager.dart';
import 'package:ecommerce_app2/widgets/app_name_text.dart';
import 'package:ecommerce_app2/widgets/products/heart_btn.dart';
import 'package:ecommerce_app2/widgets/subtitle_text.dart';
import 'package:ecommerce_app2/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});
  static const String routeName = 'product_detail_screen';

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProvider.findProductById(productId);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: AppNameText(),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FancyShimmerImage(
              imageUrl: getCurrentProduct!.productImage,
              height: size.height * .34,
              width: double.infinity,
              boxFit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SubtitleText(text: getCurrentProduct.productTitle),
                  ),

                  Flexible(
                    child: SubtitleText(
                      text: "${getCurrentProduct.productPrice}\$",
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeartButtonWidget(
                  color: Colors.blue.withOpacity(0.7),
                  size: 30,
                  productId: getCurrentProduct.productId,
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async{

                    if (cartProvider.isItemInCart(getCurrentProduct.productId)){
                      return;
                    }
                   await cartProvider.addToCartFirebase(
                      productId: getCurrentProduct.productId,
                      qty: 1,
                      context: context,
                    );
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Added to cart")));
                  },
                  label: Text(
                    cartProvider.isItemInCart(getCurrentProduct.productId)?"Added Cart":"Add to cart",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: cartProvider.isItemInCart(getCurrentProduct.productId)
                      ? Icon(Icons.check, color: Colors.white)
                      : Icon(
                          Icons.add_shopping_cart_outlined,
                          color: Colors.white,
                        ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: TitleText(text: "About this item")),
                SizedBox(width: 30),
                SubtitleText(text: getCurrentProduct.productCategory),
              ],
            ),
            SizedBox(height: 20),

            SubtitleText(text: getCurrentProduct.productDescription),
          ],
        ),
      ),
    );
  }
}
