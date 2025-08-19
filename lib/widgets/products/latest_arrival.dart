import 'dart:developer';
import 'dart:io';

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

class LatestArrivalProductsWidgets extends StatelessWidget {
  const LatestArrivalProductsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final ViewedProdProvider viewedProdProvider=Provider.of<ViewedProdProvider>(context);
    final ProductModel productModel=Provider.of<ProductModel>(context);
    final size=MediaQuery.of(context).size;
    final cartProvider=Provider.of<CartProvider>(context);
    return GestureDetector(
      onTap: (){
        viewedProdProvider.addProductToHistory(productId: productModel.productId);
        Navigator.pushNamed(context, ProductDetailScreen.routeName,arguments: productModel.productId);

      },
      child: SizedBox(
        width: size.width*.5,
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
           child:  Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).colorScheme.background,width: 2),
                    image:  DecorationImage(image: NetworkImage(productModel.productImage)
                        ,fit: BoxFit.cover)
                )
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(text:productModel.productTitle,maxLines: 2,),
                FittedBox(
                  child: Row(
                    children: [
                      HeartButtonWidget(productId: productModel.productId),

                      IconButton(
                          onPressed: ()async{

                            if (cartProvider.isItemInCart(productModel.productId)){
                              return;
                            }
                           await cartProvider.addToCartFirebase(
                              productId: productModel.productId,
                              qty: 1,
                              context: context,
                            );
                          },
                          icon:cartProvider.isItemInCart(productModel.productId)?Icon(Icons.check,color: Colors.blue,):
                          Icon(Icons.add_shopping_cart_outlined,color:Colors.blue ,)
                      )
                    ],
                  ),
                ),
                Spacer(),

                Flexible(child: SubtitleText(text: "${productModel.productPrice}\$",color: Colors.blue,)),





              ],
            ),
          ),

        ],),
      ),
    );
  }
}
// Row(
// children: [
// IconButton(onPressed: (){}, icon: Icon(IconlyLight.heart)),
// IconButton(
// onPressed: (){},
// icon: Icon(Icons.add_shopping_cart_outlined,color:Colors.white ,)
// )
// ],
// ),
