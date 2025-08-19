import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app2/root_screen.dart';
import 'package:ecommerce_app2/utilities/app_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});
    Future<void> signInWithGoogle(BuildContext context) async {
      final  googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      print("--------------------");
      print(googleUser);
      print("--------------------");
      if (googleUser != null){
           final  googleAuth = await googleUser.authentication;
           if (googleAuth.idToken != null && googleAuth.accessToken != null) {
               try{
                final authResults=await FirebaseAuth.instance.signInWithCredential(
                  GoogleAuthProvider.credential(
                    idToken: googleAuth.idToken,
                    accessToken: googleAuth.accessToken
                  )
                );
                if(authResults.additionalUserInfo!.isNewUser){
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(authResults.user!.uid)
                    .set({
                  'userId': authResults.user!.uid,
                  'userName': authResults.user!.displayName,
                  'userImage': authResults.user!.photoURL,
                  'userEmail': authResults.user!.email,
                  'userCart': [],
                  'userWish': [],
                  'createdAt': Timestamp.now(),



                });
                }
                if(!context.mounted)return;
                Navigator.pushReplacementNamed(context, RootScreen.routeName);
               }on FirebaseException catch(e){
                 AppMethods.showErrorDialog(
                   context: context,
                   function: () {},
                   title: "an error has been occurred : ${e.message}",
                 );
               }catch(e){
                 AppMethods.showErrorDialog(
                   context: context,
                   function: () {},
                   title: "an error has been occurred : $e",
                 );
               }
           }

      }

    }
  @override
  Widget build(BuildContext context) {
    return  ElevatedButton.icon(

        style: ElevatedButton.styleFrom(
          elevation: 10,

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 12,horizontal: 40),

          backgroundColor:Colors.white,
        ),
        onPressed: ()async{
          await signInWithGoogle(context);

        },
        label: Text("Or continue with Google",style: TextStyle(color: Colors.black,fontSize: 20),),
        icon: Icon(Ionicons.logo_google,color: Colors.red,)) ;
  }
}
