import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key,required this.text, this.fontSize=18,this.color,this.maxLines=1});
  final String text;
  final double fontSize;
  final Color? color;
  final int maxLines;


  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxLines,
      text,style: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      overflow: TextOverflow.ellipsis,
    )
    );
  }
}
