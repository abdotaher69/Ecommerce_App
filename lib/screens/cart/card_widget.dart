import 'package:ecommerce_app2/models/cart_model.dart';
import 'package:ecommerce_app2/providers/cart_provider.dart';
import 'package:ecommerce_app2/providers/product_provider.dart';
import 'package:ecommerce_app2/screens/cart/quantity_buttom_sheet.dart';
import 'package:ecommerce_app2/widgets/products/heart_btn.dart';
import 'package:ecommerce_app2/widgets/subtitle_text.dart';
import 'package:ecommerce_app2/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModelProvider=Provider.of<CartModel>(context);
    final productProvider=Provider.of<ProductProvider>(context);
    final getCurrentProduct=productProvider.findProductById(cartModelProvider.productId);
    final cartProvider=Provider.of<CartProvider>(context);

    final size=MediaQuery.of(context).size;
    return getCurrentProduct==null?SizedBox.shrink(): Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FancyShimmerImage(
            height: size.height*0.2,
            width: size.width*0.3,
            boxFit: BoxFit.cover,
            imageUrl: getCurrentProduct.productImage,
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(text: getCurrentProduct.productTitle,maxLines: 2,),
              SizedBox(height: 20,),
              SubtitleText(text: "${getCurrentProduct.productPrice}\$",fontSize: 20,color: Colors.blue,)
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              IconButton(onPressed: ()async{
                cartProvider.removeCartItemFirebase(context: context, productId: getCurrentProduct.productId, qty:cartModelProvider.quantity , cartId: cartModelProvider.cartId);
              }, icon: Icon(Icons.remove_circle_outline,color: Colors.red,)),
               HeartButtonWidget(productId: getCurrentProduct.productId,)  ,
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.blue,
                  )
                ),
                onPressed: ()async{
                 await showModalBottomSheet(
                   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                   shape: RoundedRectangleBorder(

                       borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
                     context: context, builder: (context){
                    return QuantityButtomSheet(cartModel: cartModelProvider,);
                  });
                },
                  label:Text(cartModelProvider.quantity.toString()),
                icon: Icon(IconlyBold.arrowDown2),

              )
            ],
          ),
        )
      ],
    );
  }
}
