import 'package:ecommerce_app2/firebase_options.dart';
import 'package:ecommerce_app2/providers/cart_provider.dart';
import 'package:ecommerce_app2/providers/orders_provider.dart';
import 'package:ecommerce_app2/providers/product_provider.dart';
import 'package:ecommerce_app2/providers/theme_provider.dart';
import 'package:ecommerce_app2/providers/users_provider.dart';
import 'package:ecommerce_app2/providers/veiwed_recently_provider.dart';
import 'package:ecommerce_app2/providers/wishlist_provider.dart';
import 'package:ecommerce_app2/root_screen.dart';
import 'package:ecommerce_app2/screens/auth/forget_pass.dart';
import 'package:ecommerce_app2/screens/auth/login.dart';
import 'package:ecommerce_app2/screens/auth/register.dart';
import 'package:ecommerce_app2/screens/home_screen.dart';
import 'package:ecommerce_app2/screens/inner_screens/orders/order_screen.dart';
import 'package:ecommerce_app2/screens/inner_screens/product_detail_screen.dart';
import 'package:ecommerce_app2/screens/inner_screens/veiwed_recently.dart';
import 'package:ecommerce_app2/screens/inner_screens/wish_list.dart';
import 'package:ecommerce_app2/screens/profile_screen.dart';
import 'package:ecommerce_app2/screens/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>ThemeProvider()),
        ChangeNotifierProvider(create: (context)=>ProductProvider()),
        ChangeNotifierProvider(create: (context)=>CartProvider()),
        ChangeNotifierProvider(create: (context)=>WishListProvider()),
        ChangeNotifierProvider(create: (context)=>ViewedProdProvider()),
        ChangeNotifierProvider(create: (context)=>UserProvider()),
        ChangeNotifierProvider(create: (context)=>OrderProvider()),

      ],
      child: Consumer<ThemeProvider>(
        builder: (context,themeProvider,child){
          return MaterialApp(
            routes: {
              ProductDetailScreen.routeName:(context)=>ProductDetailScreen(),
              WishListScreen.routeName:(context)=>WishListScreen(),
              VeiwedRecentlyScreen.routeName:(context)=>VeiwedRecentlyScreen(),
              RegisterScreen.routeName:(context)=>RegisterScreen(),
              LoginScreen.routeName:(context)=>LoginScreen(),
              OrdersScreenFree.routeName:(context)=>OrdersScreenFree(),
              ForgotPasswordScreen.routeName:(context)=>ForgotPasswordScreen(),
              SearchScreen.routeName:(context)=>SearchScreen(),
              RootScreen.routeName:(context)=>RootScreen(),


            },
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(isDarkTheme: themeProvider.getDarkTheme, context: context),
            //home:RootScreen(),
            home:RootScreen(),

          );
        }
      ),
    );
  }
}
