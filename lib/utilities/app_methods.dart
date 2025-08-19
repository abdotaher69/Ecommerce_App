import 'package:ecommerce_app2/utilities/assets_manager.dart';
import 'package:ecommerce_app2/widgets/title_text.dart';
import 'package:flutter/material.dart';
class AppMethods{
 static Future<void>  showErrorDialog({
  required BuildContext context,
  required String title,
  required Function function,
  bool isError=true
})async{
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AssetsManager.warning,height: 50,),
          ],
        ),
        actions: <Widget>[
          Visibility(
            visible: !isError,
            child: TextButton(
              child: TitleText(text: "Cancel",color: Colors.red,),
              onPressed: (){

                if(Navigator.canPop(context)){
                  Navigator.pop(context);
                }
              }
            ),
          ),
          TextButton(
            child:  TitleText(text: "Ok",color: Colors.blue,),
            onPressed: (){
              if(Navigator.canPop(context)){
                Navigator.pop(context);
              }
              function();

            },
          ),

        ],
      );
    },
  );

}
static Future<void> showImagePickerDialog({
  required BuildContext context,
  required Function cameraFCT,
  required Function galleryFCT,
  required Function removeFCT
})async {
  showDialog<void>(
    context: context,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Choose option'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextButton.icon(
                onPressed: (){
                  cameraFCT();

                  if(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                },
                label: Text("Camera"),
                icon: Icon(Icons.camera),
              ),
              TextButton.icon(
                onPressed: (){
                  galleryFCT();
                  if(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                },
                label: Text("Gallery"),
                icon: Icon(Icons.image),
              ),
              TextButton.icon(
                onPressed: (){
                  removeFCT();
                  if(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                },
                label: Text("remove"),
                icon: Icon(Icons.remove_circle_outline),
              ),

            ],
          ),
        ),

      );
    },
  );
}


}