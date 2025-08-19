import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageWidgit extends StatelessWidget {
  const PickImageWidgit({super.key,  this.pickedImage, required this.function});
  final XFile? pickedImage;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: pickedImage == null
              ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(),
              color: Colors.grey,
            ),
            // You can add child widgets here like an Icon or Text
            // to make the placeholder more explicit, for example:
            // child: Icon(Icons.add_a_photo),
          )
              : Image.file(
            File(pickedImage!.path),
            fit: BoxFit.fill,
          ),
        ),
              Positioned(
                top:0,
                  right: 0,
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                    color: Colors.lightBlue,
                    child: IconButton(onPressed: (){
                      function();
                    }, icon: Icon(Icons.add_shopping_cart_outlined,color:Colors.white ,))),
              ))
      ],
    );
  }
}
