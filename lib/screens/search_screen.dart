import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecommerce_app2/models/product_model.dart';
import 'package:ecommerce_app2/providers/product_provider.dart';
import 'package:ecommerce_app2/utilities/assets_manager.dart';
import 'package:ecommerce_app2/widgets/products/product_widget.dart';
import 'package:ecommerce_app2/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static final String routeName = "/search";

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  List<ProductModel>productSearchList=[];

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    String? category = ModalRoute.of(context)!.settings.arguments as String?;
     List<ProductModel> products = category == null
        ? productProvider.getProducts
        : productProvider.getProductsByCategory(category);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TitleText(text: category??"Search", fontSize: 25),
          leading: Image.asset(AssetsManager.shoppingCart),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
        body: products.isEmpty?Center(child: TitleText(text: "NO products Found"),) :SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onSubmitted: (value) {
                  productSearchList=productProvider.searchQuery( searchText: controller.text,passedList: products);
                  setState(() {});
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  // productSearchList=productProvider.searchQuery( searchText: controller.text);
                  // setState(() {});

                },
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.clear();
                      FocusScope.of(context).unfocus();
                      setState(() {});
                    },
                    icon: Icon(Icons.clear),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (productSearchList.isEmpty&&controller.text.isNotEmpty)...[
                Center(child: TitleText(text: "NO products Found"),)
              ],
              Container(
                child: DynamicHeightGridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  builder: (context, index) {
                    return ProductWidget(
                      productId:controller.text.isEmpty? products[index].productId:productSearchList[index].productId,
                    );
                  },
                  itemCount:controller.text.isEmpty? products.length:productSearchList.length,
                  crossAxisCount: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
