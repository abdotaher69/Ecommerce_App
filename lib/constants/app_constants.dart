import 'package:ecommerce_app2/models/category_model.dart';
import 'package:ecommerce_app2/utilities/assets_manager.dart';

class AppConstants{
  static const productImageUrl='https://www.shutterstock.com/image-photo/handsome-happy-african-american-bearded-600nw-2460702995.jpg';

  static List<String>bannersImages=[
    AssetsManager.banner1,
    AssetsManager.banner2,
  ];
  static List<CategoryModel>categoriesList=[
    CategoryModel(id: "1", image: AssetsManager.mobiles, name: "phones"),
    CategoryModel(id: "2", image: AssetsManager.fashion, name: "Laptops"),
    CategoryModel(id: "3", image: AssetsManager.watch, name: "Watches"),
    CategoryModel(id: "4", image: AssetsManager.book, name: "Shoes"),
    CategoryModel(id: "5", image: AssetsManager.electronics, name: "Accessories"),
    CategoryModel(id: "6", image: AssetsManager.cosmetics, name: "cosmetics"),

  ];


}