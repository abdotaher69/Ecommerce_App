import 'package:ecommerce_app2/utilities/assets_manager.dart';
import 'package:ecommerce_app2/widgets/subtitle_text.dart';
import 'package:ecommerce_app2/widgets/title_text.dart';
import 'package:flutter/material.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget({super.key,required this.imagePath,required this.title,required this.subtitle,required this.buttonText});
  final String imagePath;
  final String title;
  final String subtitle;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return  SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Image.asset(imagePath,height: size.height*0.35,width: size.width),
          ),
          TitleText(text: "Whoops",fontSize: 40,color: Colors.red,),
          const SizedBox(height: 20,),
           SubtitleText(text: title,fontSize: 25,fontWeight: FontWeight.bold),
          const SizedBox(height: 20,),
          SubtitleText(text:subtitle,fontSize: 20,)
          ,const   SizedBox(height: 60,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                  elevation: 8

              ),
              onPressed: (){},
              child:  Text(buttonText,style: TextStyle(color: Colors.white,fontSize: 20),))

        ],
      ),
    );;
  }
}
