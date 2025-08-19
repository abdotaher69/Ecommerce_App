import 'package:ecommerce_app2/constants/app_constants.dart';
import 'package:ecommerce_app2/models/product_model.dart';
import 'package:ecommerce_app2/providers/cart_provider.dart';
import 'package:ecommerce_app2/providers/product_provider.dart';
import 'package:ecommerce_app2/providers/veiwed_recently_provider.dart';
import 'package:ecommerce_app2/screens/inner_screens/product_detail_screen.dart';
import 'package:ecommerce_app2/widgets/products/heart_btn.dart';
import 'package:ecommerce_app2/widgets/subtitle_text.dart';
import 'package:ecommerce_app2/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({super.key, required this.productId});
  final String productId;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final getCurrentProduct = productProvider.findProductById(widget.productId);
    final size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(3.0),
            child: InkWell(
              onTap: () {
                print("=================================");

                viewedProdProvider.addProductToHistory(
                  productId: getCurrentProduct.productId,
                );
                print("=================================");
                print(viewedProdProvider.getviewedProdItems);
                Navigator.pushNamed(
                  context,
                  ProductDetailScreen.routeName,
                  arguments: getCurrentProduct.productId,
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FancyShimmerImage(
                      imageUrl: getCurrentProduct.productImage,
                      height: size.height * .22,
                      width: double.infinity,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TitleText(
                          text: getCurrentProduct.productTitle,
                          maxLines: 2,
                        ),
                      ),
                      HeartButtonWidget(productId: getCurrentProduct.productId),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Flexible(
                        child: SubtitleText(
                          text: "${getCurrentProduct.productPrice}\$",
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Material(
                          color: Colors.lightBlue,
                          child: IconButton(
                            onPressed: () async{
                              // cartProvider.addToCart(
                              //   productId: getCurrentProduct.productId,
                              // );
                              if (cartProvider.isItemInCart(getCurrentProduct.productId)){
                                return;
                              }
                              await cartProvider.addToCartFirebase(
                                productId: getCurrentProduct.productId,
                                qty: 1,
                                context: context,
                              );
                            },
                            icon:
                                cartProvider.isItemInCart(
                                  getCurrentProduct.productId,
                                )
                                ? Icon(Icons.check, color: Colors.white)
                                : Icon(
                                    Icons.add_shopping_cart_outlined,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
