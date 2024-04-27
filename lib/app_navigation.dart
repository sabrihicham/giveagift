import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/enums.dart';
import 'package:giveagift/view/cards/cards.dart';
import 'package:giveagift/view/home/home.dart';
import 'package:giveagift/view/settings/settings.dart';
import 'package:giveagift/view/store/store.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  var _selectedTab = Pages.home;

  @override
  void initState() {
    super.initState();
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
      extendBody: true, 
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > 600 ? 20 : 10),
        child: DotNavigationBar(
          curve: Curves.fastLinearToSlowEaseIn,
          marginR: EdgeInsets.symmetric(vertical: 0, horizontal: MediaQuery.of(context).size.width > 600 ? 150 : 50),
          paddingR: const EdgeInsets.symmetric(vertical: 0, horizontal: 10 ),
          margin: const EdgeInsets.only(left: 10, right: 10,),
          itemPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          enablePaddingAnimation: false,
          enableFloatingNavBar: true,
          borderRadius: 50,
          backgroundColor: Get.isDarkMode
            ? Colors.black
            : Colors.white,
          currentIndex: Pages.values.indexOf(_selectedTab),
          dotIndicatorColor: Colors.transparent,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Get.isDarkMode ? Colors.white : Colors.black,
          splashBorderRadius: 50,
          onTap: _handleIndexChanged,
          items: [
            /// Home
            DotNavigationBarItem(
              icon: const Column(
                children: [
                  Icon(Icons.home),
                  Text('Home'),
                ],
              ),
            ),

            /// Cards 
            /// Ready & Custom
            DotNavigationBarItem(
              icon: const Column(
                children: [
                  Icon(Icons.credit_card_outlined),
                  Text('Cards')
                ],
              ),
            ),

            /// Stores
            DotNavigationBarItem(
              icon: const Column(
                children: [
                  Icon(Icons.storefront_outlined),
                Text('Store'),
                ],
              ),
            ),

            /// Settings
            DotNavigationBarItem(
              icon: const Column(
                children: [
                  Icon(Icons.settings_suggest_rounded),
                  Text('Settings'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: Pages.values.indexOf(_selectedTab),
        children: const [
          HomePage(),
          CardsPage(),
          Store(),
          Settingspage(),
        ],
      )
    );
  }
}