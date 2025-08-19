import 'package:ecommerce_app2/providers/wishlist_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({super.key, this.size=22, this.color=Colors.transparent, required this.productId});
  final double size;
  final Color color;
  final String productId;

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final WishListProvider wishListProvider=Provider.of<WishListProvider>(context);
    return Material(
        color: widget.color,
        shape: CircleBorder(),
        child: IconButton(onPressed: (){
          wishListProvider.addOrRemoveFromWishlist(productId:widget.productId );
        }, icon:wishListProvider.isItemInWishList(widget.productId)?
    Icon(IconlyBold.heart,color: Colors.red):
    Icon(IconlyBold.heart,color: Colors.grey)));
  }
}
