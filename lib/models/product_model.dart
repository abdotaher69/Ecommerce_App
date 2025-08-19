

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class ProductModel  with ChangeNotifier{
  final String productId,
      productTitle,
      productPrice,
      productCategory,
      productDescription,
      productImage,
      productQuantity;
  Timestamp? createdAt ;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
     this.createdAt,
  });
  factory ProductModel.fromFirestore(DocumentSnapshot doc){
     Map<String,dynamic> snapshot=doc.data() as Map<String,dynamic>;
     return ProductModel(
       productId: snapshot['productId'],
       productTitle: snapshot['productTitle'],
       productPrice: snapshot['productPrice'],
       productCategory: snapshot['productCategory'],
       productDescription: snapshot['productDescription'],
       productImage: snapshot['productImage'],
       productQuantity: snapshot['productQuantity'],
       createdAt: snapshot['createdAt'],
     );
  }

}
