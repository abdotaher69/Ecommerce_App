import 'package:ecommerce_app2/providers/cart_provider.dart';
import 'package:ecommerce_app2/providers/product_provider.dart';
import 'package:ecommerce_app2/widgets/subtitle_text.dart';
import 'package:ecommerce_app2/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtomCheckout extends StatelessWidget {
  const ButtomCheckout({super.key,required this.function});
  final Function function;


  @override
  Widget build(BuildContext context) {
    final cartProvider=Provider.of<CartProvider>(context);
    final ProductProvider productProvider=Provider.of<ProductProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(top: BorderSide(color: Colors.grey,width: 1))
      ),
      child: SizedBox(
        height: kBottomNavigationBarHeight+20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(text: "Total:products(${cartProvider.getCartItems.length})/items(${cartProvider.getQty()})"),
                    SubtitleText(
                      text:
                      "${cartProvider.getTotal(  productProvider: productProvider)}\$",color: Colors.blue,),

                  ],
                ),
              ),
            ElevatedButton(onPressed: ()async{
              await function();
            }, child: Text("checkout"))
            ],
          ),
        ),
      ),
    );
  }
}
