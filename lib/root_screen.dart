import 'package:ecommerce_app2/providers/cart_provider.dart';
import 'package:ecommerce_app2/providers/product_provider.dart';
import 'package:ecommerce_app2/providers/users_provider.dart';
import 'package:ecommerce_app2/screens/cart/card_screen.dart';
import 'package:ecommerce_app2/screens/home_screen.dart';
import 'package:ecommerce_app2/screens/profile_screen.dart';
import 'package:ecommerce_app2/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});
  static final routeName = 'root_screen';
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  Future<void> fetchFCT() async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    try {
      Future.wait([
        productProvider.fetchProducts(),
        userProvider.fetchUserInfo(),
      ]);
      Future.wait([cartProvider.fetCartFirebase(context: context)]);
    } catch (e) {
      rethrow;
    } finally {
      isLoaded = false;
    }
  }

  int selectedIndex = 0;
  bool isLoaded = true;
  late PageController pageController;
  List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    CardScreen(),
    ProfileScreen(),
  ];
  @override
  void didChangeDependencies() {
    if (isLoaded) {
      fetchFCT();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    pageController = PageController(initialPage: selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: screens,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        selectedIndex: selectedIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
            selectedIcon: Icon(Icons.home_filled),
          ),
          NavigationDestination(
            icon: Icon(IconlyLight.search),
            label: "Search",
            selectedIcon: Icon(IconlyBold.search),
          ),
          NavigationDestination(
            icon: Badge(
              label: Text("${cartProvider.getCartItems.length}"),
              child: Icon(Icons.shopping_cart_outlined),
            ),
            label: "Card",
            selectedIcon: Icon(Icons.shopping_cart),
          ),
          NavigationDestination(
            icon: Icon(IconlyLight.profile),
            label: "Profile",
            selectedIcon: Icon(IconlyBold.profile),
          ),
        ],
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
            pageController.jumpToPage(selectedIndex);
          });
        },
      ),
    );
  }
}
