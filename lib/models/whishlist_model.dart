import 'package:flutter/cupertino.dart';

class WishListModel with ChangeNotifier {
  final String Id;
  final String productId;


  WishListModel({
    required this.Id,
    required this.productId,
  });
}