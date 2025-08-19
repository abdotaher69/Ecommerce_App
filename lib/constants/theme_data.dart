import 'package:flutter/material.dart';

import 'app_colors.dart';

class Styles{
  static ThemeData themeData ({required bool isDarkTheme,required BuildContext context}){
         return ThemeData(
           scaffoldBackgroundColor: isDarkTheme?AppColors.darkScaffoldColor:AppColors.lightScaffoldColor,
           primaryColor: isDarkTheme?AppColors.darkPrimary:AppColors.lightPrimary,
           cardColor: isDarkTheme?Color.fromARGB(255, 13, 6, 37):AppColors.lightCardColor,
           brightness: isDarkTheme?Brightness.dark:Brightness.light,
           appBarTheme: AppBarTheme(
             iconTheme: isDarkTheme?IconThemeData(color: Colors.white):IconThemeData(color: Colors.black),
             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
             elevation: 0,
             titleTextStyle: TextStyle(color:isDarkTheme?Colors.white:Colors.black),


           )
             ,
           inputDecorationTheme: InputDecorationTheme(
             filled: true,
             contentPadding: const EdgeInsets.all(10),
             enabledBorder: OutlineInputBorder(
               borderSide: const BorderSide(
                 width: 1,
                 color: Colors.transparent,
               ),
               borderRadius: BorderRadius.circular(8),
             ),
             focusedBorder: OutlineInputBorder(
               borderSide: BorderSide(
                 width: 1,
                 color: isDarkTheme ? Colors.white : Colors.black,
               ),
               borderRadius: BorderRadius.circular(8),
             ),
             errorBorder: OutlineInputBorder(
               borderSide: BorderSide(
                 width: 1,
                 color: Theme.of(context).colorScheme.error,
               ),
               borderRadius: BorderRadius.circular(8),
             ),
             focusedErrorBorder: OutlineInputBorder(
               borderSide: BorderSide(
                 width: 1,
                 color: Theme.of(context).colorScheme.error,
               ),
               borderRadius: BorderRadius.circular(8),
             ),
           ),
       );
  }
}