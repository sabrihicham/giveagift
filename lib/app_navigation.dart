import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/enums.dart';
import 'package:giveagift/view/cards/cards.dart';
import 'package:giveagift/view/cart/cart.dart';
import 'package:giveagift/view/home/home.dart';
import 'package:giveagift/view/profile/profile.dart';
import 'package:giveagift/view/store/store.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// initial key for AppNavigation
final GlobalKey<AppNavigationState> appNavigationKey = GlobalKey<AppNavigationState>();

// AppNavigation class

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => AppNavigationState();
}

class AppNavigationState extends State<AppNavigation> {
  var _selectedTab = Pages.home;

  @override
  void initState() {
    super.initState();
  }

  void changeSelectedTab(Pages page) {
    setState(() {
      _selectedTab = page;
    });
  }

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = Pages.values[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // extendBody: true, 
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: Pages.values.indexOf(_selectedTab),
        onTap: _handleIndexChanged,
        backgroundColor: Get.isDarkMode
          ? Colors.black.withOpacity(.9)
          : Colors.white.withOpacity(.9),
          // : Color.fromRGBO(58, 72, 86, 0.898),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: Text('home'.tr),
            // selectedColor: Colors.purple,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.credit_card_outlined),
            title: Text('cards'.tr),
            // selectedColor: Colors.pink,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.storefront_outlined),
            title: Text('stores'.tr),
            // selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            title: Text('cart'.tr),
            icon: const Icon(Icons.shopping_bag_rounded),
            // selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            title: Text('profile'.tr),
            // selectedColor: Colors.teal,
          ),
        ],
      ),
      // Padding(
      //   padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > 600 ? 20 : 10),
      //   child: DotNavigationBar(
      //     curve: Curves.fastLinearToSlowEaseIn,
      //     marginR: EdgeInsets.symmetric(vertical: 0, horizontal: MediaQuery.of(context).size.width > 600 ? 150 : 50),
      //     paddingR: const EdgeInsets.symmetric(vertical: 0, horizontal: 10 ),
      //     margin: const EdgeInsets.only(left: 10, right: 10,),
      //     itemPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      //     enablePaddingAnimation: false,
      //     enableFloatingNavBar: true,
      //     borderRadius: 50,
      //     backgroundColor: Get.isDarkMode
      //       ? Colors.black
      //       : Colors.white,
      //     currentIndex: Pages.values.indexOf(_selectedTab),
      //     dotIndicatorColor: Colors.transparent,
      //     unselectedItemColor: Colors.grey,
      //     selectedItemColor: Get.isDarkMode ? Colors.white : Colors.black,
      //     splashBorderRadius: 50,
      //     onTap: _handleIndexChanged,
      //     items: [
      //       /// Home
      //       DotNavigationBarItem(
      //         icon: const Column(
      //           children: [
      //             Icon(Icons.home),
      //             Text('Home'),
      //           ],
      //         ),
      //       ),

      //       /// Cards 
      //       /// Ready & Custom
      //       DotNavigationBarItem(
      //         icon: const Column(
      //           children: [
      //             Icon(Icons.credit_card_outlined),
      //             Text('Cards')
      //           ],
      //         ),
      //       ),

      //       /// Stores
      //       DotNavigationBarItem(
      //         icon: const Column(
      //           children: [
      //             Icon(Icons.storefront_outlined),
      //           Text('Store'),
      //           ],
      //         ),
      //       ),

      //       /// Settings
      //       DotNavigationBarItem(
      //         icon: const Column(
      //           children: [
      //             Icon(Icons.settings_suggest_rounded),
      //             Text('Settings'),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: IndexedStack(
        index: Pages.values.indexOf(_selectedTab),
        children: [
          const HomePage(),
          CardsPage(key: cardsPageKey),
          const Store(),
          const CartPage(),
          const ProfilePage(),
        ],
      )
    );
  }
}