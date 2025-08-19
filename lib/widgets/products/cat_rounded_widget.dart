import 'package:ecommerce_app2/models/cart_model.dart';
import 'package:ecommerce_app2/screens/search_screen.dart';
import 'package:ecommerce_app2/widgets/subtitle_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Category_Rounded_widget extends StatelessWidget {
  const Category_Rounded_widget({super.key,required this.image,required this.name});
  final String image,name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, SearchScreen.routeName,arguments: name);
      },
      child: Column(
        children: [
              Image.asset(image,height: 50,width: 50,),
          SubtitleText(text: name,fontSize: 18,fontWeight: FontWeight.bold,)
        ],
      ),
    );
  }
}
