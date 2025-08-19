import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier{
  static const String theme_status='theme_status';

  bool isDarkTheme=false;
  bool get getDarkTheme=>this.isDarkTheme;
  ThemeProvider(){
    getTheme();
  }
  Future<void> setDarkTheme(bool value)async{
   SharedPreferences prefs= await SharedPreferences.getInstance();
   prefs.setBool(theme_status, value);
   this.isDarkTheme=value;
   notifyListeners();


  }
  Future<bool> getTheme()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    this.isDarkTheme=prefs.getBool(theme_status)??false;
    notifyListeners();
    return this.isDarkTheme;
  }

}