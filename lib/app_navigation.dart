import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
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
    final bottomPadding = MediaQuery.of(context).padding.bottom + 60;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true, 
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: DotNavigationBar(
          curve: Curves.fastLinearToSlowEaseIn,
          // itemPadding:  EdgeInsets.all(16),
          marginR: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          paddingR: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          margin: const EdgeInsets.only(left: 10, right: 10,),
          enableFloatingNavBar: true,
          currentIndex: Pages.values.indexOf(_selectedTab),
          dotIndicatorColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
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
              selectedColor: const Color(0xff73544C),
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
              selectedColor: const Color(0xff73544C),
            ),

            /// Stores
            DotNavigationBarItem(
              icon: const Column(
                children: [
                  Icon(Icons.storefront_outlined),
                Text('Store'),
                ],
              ),
              selectedColor: const Color(0xff73544C),
            ),

            /// Settings
            DotNavigationBarItem(
              icon: const Column(
                children: [
                  Icon(Icons.settings_suggest_rounded),
                  Text('Settings'),
                ],
              ),
              selectedColor: const Color(0xff73544C),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: Pages.values.indexOf(_selectedTab),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: const HomePage(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: const CardsPage(),
          ),
         Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: const Store(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: const Settingspage(),
          ),
        ],
      )
    );
  }
}