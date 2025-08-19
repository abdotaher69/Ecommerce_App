import 'package:flutter/material.dart';

class SubtitleText extends StatelessWidget {
  const SubtitleText({super.key,required this.text, this.fontSize=18,this.color,this.fontWeight,this.fontStyle= FontStyle.normal,this.textDecoration=TextDecoration.none});
final String text;
final double fontSize;
final Color? color;
final FontWeight? fontWeight;
final FontStyle fontStyle;
final TextDecoration textDecoration;
  @override
  Widget build(BuildContext context) {
    return  Text(
      text,style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight
        ,fontStyle: fontStyle,
        decoration: textDecoration,
        color: color),);
  }
}
