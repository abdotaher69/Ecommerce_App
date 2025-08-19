import 'package:card_swiper/card_swiper.dart';
import 'package:ecommerce_app2/constants/app_constants.dart';
import 'package:ecommerce_app2/providers/product_provider.dart';
import 'package:ecommerce_app2/utilities/assets_manager.dart';
import 'package:ecommerce_app2/widgets/app_name_text.dart';
import 'package:ecommerce_app2/widgets/products/cat_rounded_widget.dart';
import 'package:ecommerce_app2/widgets/products/latest_arrival.dart';
import 'package:ecommerce_app2/widgets/subtitle_text.dart';
import 'package:ecommerce_app2/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider=Provider.of<ProductProvider>(context);
    final size=MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: AppNameText(),
        leading: Image.asset(AssetsManager.shoppingCart),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height*.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                  child: Swiper(
                    autoplay: true,
                    viewportFraction: 1,
                    scale: 0.8,
                    loop: true,
                    itemBuilder: (BuildContext context,int index){
                      return Image.asset(AppConstants.bannersImages[index],fit: BoxFit.fill,);
                    },
                    itemCount: AppConstants.bannersImages.length,
                    pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(color: Colors.white,activeColor: Colors.blue)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
          
              Visibility(
                visible: productProvider.products.isNotEmpty,
                  child: TitleText(text: "Latest Arrival",fontSize: 25,)),
              SizedBox(height: 10,),
          
              Visibility(
                visible: productProvider.products.isNotEmpty,
                child: SizedBox(
                  height:size.height*.2,
                  child: ListView.builder(
                    itemCount: productProvider.products.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return ChangeNotifierProvider.value(
                        value: productProvider.products[index],
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: LatestArrivalProductsWidgets(),
                        ),
                      );

                    },

                  ),
                ),
              ),
              TitleText(text: "Catrgories",fontSize: 25,),
              SizedBox(height: 10,),
              GridView.count(crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),

              children: List.generate(AppConstants.categoriesList.length, (index) {
                return Category_Rounded_widget(image: AppConstants.categoriesList[index].image, name: AppConstants.categoriesList[index].name);
              })
              )
            ],
          ),
        ),
      ),
    );
  }
}
