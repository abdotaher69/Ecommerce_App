
import 'dart:io';

import 'package:ecommerce_app2/models/user_model.dart';
import 'package:ecommerce_app2/providers/theme_provider.dart';
import 'package:ecommerce_app2/providers/users_provider.dart';
import 'package:ecommerce_app2/screens/auth/login.dart';
import 'package:ecommerce_app2/screens/inner_screens/orders/order_screen.dart';
import 'package:ecommerce_app2/screens/inner_screens/veiwed_recently.dart';
import 'package:ecommerce_app2/screens/inner_screens/wish_list.dart';
import 'package:ecommerce_app2/screens/loading_manager.dart';
import 'package:ecommerce_app2/utilities/app_methods.dart' as AppMethods;
import 'package:ecommerce_app2/widgets/app_name_text.dart';
import 'package:ecommerce_app2/widgets/subtitle_text.dart';
import 'package:ecommerce_app2/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../utilities/assets_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user=FirebaseAuth.instance.currentUser;
  bool isloading=true;
  UserModel? userModel;
  Future<void> fetchInfo()async{
    if(user==null){
      setState(() {
        isloading=false;

      });
      return;
    }
    final UserProvider userProvider=Provider.of<UserProvider>(context,listen: false);
    try{
       userModel=await userProvider.fetchUserInfo();
    }on FirebaseAuthException catch (e) {
      AppMethods.AppMethods.showErrorDialog(
        context: context,
        function: () {},
        title: "an error has been occurred : ${e.message}",
      );
    } catch (e) {
      AppMethods.AppMethods.showErrorDialog(
        context: context,
        function: () {},
        title: "an error has been occurred : $e",
      );
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }
  @override
  void initState() {
      fetchInfo();
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(user);

    final themeProvider=Provider.of<ThemeProvider>(context);

    return LoadingManager(
      isLoading: isloading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: AppNameText(),
          leading: Image.asset(AssetsManager.shoppingCart),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: user==null?true:false,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SubtitleText(text: "please login to have unlimited access"),
                ),
              ),
              SizedBox(height: 20,),
             userModel==null?SizedBox.shrink(): Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                      border: Border.all(color: Theme.of(context).colorScheme.background,width: 2),
                   image:  DecorationImage(image: FileImage(
                     File(userModel!.userImage),
                   )
                       ,fit: BoxFit.cover)
                    )
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleText(text: userModel!.userName),
                          SubtitleText(text: userModel!.userEmail)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,vertical: 24
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(text: "general "),
                    CustomListTile(imagePath: AssetsManager.orderSvg,
                        text: "All orders",
                        function: (){
                          Navigator.pushNamed(context, OrdersScreenFree.routeName);
                        }),

                    CustomListTile(imagePath: AssetsManager.wishlistSvg,
                        text: "Wish List",
                        function: (){
                       Navigator.pushNamed(context, WishListScreen.routeName);
                        }),

                    CustomListTile(imagePath: AssetsManager.recent,
                        text: "Viewed Recently",
                        function: (){
                          Navigator.pushNamed(context, VeiwedRecentlyScreen.routeName);
                        }),

                    CustomListTile(imagePath: AssetsManager.address,
                        text: "address",
                        function: (){}),
                   const  Divider(),
                    TitleText(text: "settings"),

                    SwitchListTile(
                         secondary: Image.asset(AssetsManager.theme,height: 30,),
                        title:themeProvider.getDarkTheme?const Text("Dark Mode"):const Text("Light Mode")   ,
                        value: themeProvider.getDarkTheme,
                        onChanged: (value){
                          themeProvider.setDarkTheme(value);
                        }),
                    Divider(),
                    Center(child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.red,
                      ),
                        onPressed: ()async{
                        if(user==null){
                          Navigator.pushNamed(context, LoginScreen.routeName);

                        }else{
                          AppMethods.AppMethods.showErrorDialog(
                              context: context,
                              title: "are you sure you want to logout",
                              function: ()async{
                                await FirebaseAuth.instance.signOut();
                                 print("logout");
                                 Navigator.pushNamed(context, LoginScreen.routeName);
                              },
                                isError: false);
                        }

                        },
                        label: Text(user==null?"Login":"logout",style: TextStyle(color: Colors.white),),
                        icon: Icon(IconlyBold.logout,color: Colors.white,)))






                  ],
                ),
              )

            ],
          ),
        ),

      ),
    );
  }
}
class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });

  final String imagePath, text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      leading: Image.asset(
        imagePath,
        height: 30,
      ),
      title: Text(text),
      trailing: const Icon(Icons.arrow_right_rounded),
    );
  }
}

