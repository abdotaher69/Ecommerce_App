import 'package:ecommerce_app2/models/cart_model.dart';
import 'package:ecommerce_app2/providers/cart_provider.dart';
import 'package:ecommerce_app2/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuantityButtomSheet extends StatelessWidget {
  const QuantityButtomSheet({super.key,required this.cartModel});
  final CartModel cartModel ;

  @override
  Widget build(BuildContext context) {
    final cartProvider=Provider.of<CartProvider>(context);
    return Column(
      children: [
        SizedBox(height: 10,),
        Container(
          height: 6,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 10,),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
              itemBuilder: (context,index){
            return InkWell(
              onTap: (){
                cartProvider.updateQuantity(
                  productId: cartModel.productId,
                  quantity: (index+1).toString(),
                );
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: SubtitleText(text: " ${index+1}")),
              ),
            );
          }),
        ),
      ],
    ) ;
  }
}
