import 'package:ecommerce_app2/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppNameText extends StatelessWidget {
  const AppNameText({super.key,this.fontSize=20});
   final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: Duration(seconds: 4),
        baseColor: Colors.purple,
         highlightColor: Colors.red,
    child: TitleText(text:"shop smart" ,fontSize: fontSize,));
  }
}
