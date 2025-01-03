import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/enums.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cards/cards.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cards/explore.dart';
import 'package:giveagift/view/cart/cart.dart';
import 'package:giveagift/view/home/home.dart';
import 'package:giveagift/view/profile/controller/profile_controller.dart';
import 'package:giveagift/view/profile/login.dart';
import 'package:giveagift/view/profile/profile.dart';
import 'package:giveagift/view/store/shop.dart';

// initial key for AppNavigation
final GlobalKey<AppNavigationState> appNavigationKey =
    GlobalKey<AppNavigationState>();

// AppNavigation class

class AppNavigation extends StatefulWidget {
  final bool navigateToLogin;

  const AppNavigation({super.key, this.navigateToLogin = false});

  @override
  State<AppNavigation> createState() => AppNavigationState();
}

class AppNavigationState extends State<AppNavigation> {
  var selectedTab = Pages.home;

  Color? get _iconsColor => Theme.of(context).primaryColor;

  // Stream for selectedTab changes
  final selectedTabStream = StreamController<Pages>.broadcast();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown
    ]);

    if(widget.navigateToLogin) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        final value = await Get.to(
          () => const LoginPage(),
        );

        if (value == true) {
          Get.find<ProfileController>().onInit();
        }
      });
    }

    super.initState();
  }

  void changeSelectedTab(Pages page) {
    setState(() {
      selectedTab = page;
      selectedTabStream.add(selectedTab);
    });
  }

  void _handleIndexChanged(int i) {
    setState(() {
      selectedTab = Pages.values[i];
      selectedTabStream.add(selectedTab);
    });
  }

  void onChangedThemeMode(bool isDark) {
    setState(() {
      // change theme
      Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
      SharedPrefs.instance.prefs.setBool('isDark', isDark);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Get.isDarkMode ? Theme.of(context).cardColor : null,
        // extendBody: true,
        // drawer: Drawer(
        //   child: ListView(
        //     padding: EdgeInsets.zero,
        //     children: <Widget>[
        //       SafeArea(
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Image.asset(
        //             'assets/images/logo.webp',
        //             alignment: Get.locale?.languageCode == 'ar'
        //                 ? Alignment.topRight
        //                 : Alignment.topLeft,
        //             width: 30,
        //             height: 30,
        //           ),
        //         ),
        //       ),
        //       ListTile(
        //         title: Text('home'.tr),
        //         trailing: Icon(Icons.home, color: _iconsColor),
        //         onTap: () {
        //           changeSelectedTab(Pages.home);
        //           Navigator.pop(context);
        //         },
        //       ),
        //       ListTile(
        //         title: Text('my_account'.tr),
        //         trailing:
        //             Icon(Icons.person_outline_rounded, color: _iconsColor),
        //         onTap: () {
        //           changeSelectedTab(Pages.profile);
        //           Navigator.pop(context);
        //         },
        //       ),
        //       ListTile(
        //         title: Text('ready_cards'.tr),
        //         trailing: Icon(Icons.credit_card_outlined, color: _iconsColor),
        //         onTap: () {
        //           appNavigationKey.currentState?.changeSelectedTab(Pages.cards);
        //           cardsPageKey.currentState?.changeTab(CardType.readyToUse);
        //           Navigator.pop(context);
        //         },
        //       ),
        //       ListTile(
        //         title: Text('creat_a_card'.tr),
        //         trailing: Icon(Icons.edit_attributes_rounded, color: _iconsColor),
        //         onTap: () {
        //           appNavigationKey.currentState?.changeSelectedTab(Pages.cards);
        //           cardsPageKey.currentState?.changeTab(CardType.custom);
        //           Navigator.pop(context);
        //         },
        //       ),
        //       if (kDebugMode)
        //         ListTile(
        //           title: Text('cart'.tr),
        //           trailing: Icon(Icons.shopping_bag_rounded, color: _iconsColor),
        //           onTap: () {
        //             changeSelectedTab(Pages.cart);
        //             Navigator.pop(context);
        //           },
        //         ),
        //       ListTile(
        //         title: Text('shops'.tr),
        //         trailing: Icon(Icons.storefront_outlined, color: _iconsColor),
        //         onTap: () {
        //           changeSelectedTab(Pages.stores);
        //           Navigator.pop(context);
        //         },
        //       ),
        //       // logout
        //       ValueListenableBuilder(
        //         valueListenable: SharedPrefs.instance.isLogedIn,
        //         builder: (context, value, child) {
        //           if (!value) {
        //             return const SizedBox.shrink();
        //           } else {
        //             return Container(
        //               alignment: Alignment.center,
        //               margin: const EdgeInsets.symmetric(
        //                 vertical: 10, 
        //                 horizontal: 20,
        //               ),
        //               padding: const EdgeInsets.symmetric(
        //                 horizontal: 16,
        //                 vertical: 8,
        //               ),
        //               decoration: BoxDecoration(
        //                 color: Theme.of(context).colorScheme.secondary,
        //                 borderRadius: BorderRadius.circular(8),
        //               ),
        //               child: InkWell(
        //                 onTap: () {
        //                   SharedPrefs.instance.clearToken();
        //                   Scaffold.of(context).closeDrawer();
        //                 },
        //                 child: Text(
        //                   'logout'.tr,
        //                   style: Theme.of(context).textTheme.titleSmall?.copyWith(
        //                     color: Colors.white,
        //                   ),
        //                 ),
        //               ),
        //             );
        //           }
        //         },
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: [
        //           IconButton(
        //             icon: const Icon(Icons.brightness_4),
        //             color: _iconsColor,
        //             onPressed: () {
        //               onChangedThemeMode(!Get.isDarkMode);
        //             },
        //           ),
        //           Row(
        //             children: [
        //               IconButton(
        //                 icon: const Icon(Icons.language),
        //                 color: _iconsColor,
        //                 onPressed: () {
        //                   final newValue = Get.locale?.languageCode == 'ar' ? 'en' : 'ar';
        //                   // save in shared preferences
        //                   SharedPrefs.instance.prefs.setString('lang', newValue);
        //                   // change language
        //                   Get.updateLocale(Locale(newValue));
        //                 },
        //               ),
        //               Text(Get.locale?.languageCode == 'ar' ? 'العربية' : 'English'),
        //             ],
        //           ),
        //         ],
        //       )
        //     ],
        //   ),
        // ),
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: Pages.values.indexOf(selectedTab) < 3
        //     ? Pages.values.indexOf(selectedTab)
        //     : Pages.values.indexOf(selectedTab) == 3
        //       ? 1
        //       : 0,
        //   onTap: _handleIndexChanged,
        //   backgroundColor: !Get.isDarkMode ? Colors.white : Colors.black,
        //   selectedItemColor: Theme.of(context).primaryColor,
        //   // selectedIconTheme: IconThemeData(
        //   //   color: Theme.of(context).primaryColor,
        //   // ),
        //   items: [
        //     BottomNavigationBarItem(
        //       icon: const FaIcon(FontAwesomeIcons.home),
        //       activeIcon: const FaIcon(FontAwesomeIcons.homeLgAlt),
        //       label: 'home'.tr,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: const FaIcon(Icons.travel_explore_outlined, size: 28,),
        //       activeIcon: const FaIcon(Icons.travel_explore_rounded, size: 28,),
        //       label: 'explore'.tr,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: const FaIcon(FontAwesomeIcons.user),
        //       activeIcon: const FaIcon(FontAwesomeIcons.userAlt),
        //       label: 'my_account'.tr,
        //     ),
        //   ],
        // ),
        body: BottomBar(
          barColor: Get.isDarkMode ? Theme.of(context).cardColor :  Colors.white,
          borderRadius: BorderRadius.circular(25),
          width: MediaQuery.of(context).size.width * 336 / 375,
          barDecoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Get.isDarkMode
                ? Colors.grey.shade400
                : const Color.fromRGBO(241, 241, 241, 1), 
              width: 1
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: SizedBox(
            height: 76.h,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: Center(
                  child: GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // padding: EdgeInsets.only(top: 16.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, 
                        childAspectRatio: Get.size.width > 600 ? 3 : 16 / 10
                      ),
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            changeSelectedTab(Pages.home);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/nav_bar_home.svg',
                                height: 24.w,// Get.size.width > 600 ? 16.w : 24.w,
                                width: 24.w,
                                color: selectedTab == Pages.home
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'home'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: selectedTab == Pages.home
                                      ? Get.isDarkMode ? Colors.white : Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            changeSelectedTab(Pages.explore);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/nav_bar_explore.svg',
                                height: 24.w,
                                width: 24.w,
                                color: selectedTab == Pages.explore
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'explore'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: selectedTab == Pages.explore
                                      ? Get.isDarkMode ? Colors.white : Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            changeSelectedTab(Pages.profile);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/nav_bar_profile.svg',
                                height: 24.w,
                                width: 24.w,
                                color: selectedTab == Pages.profile
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'my_account'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: selectedTab == Pages.profile
                                      ? Get.isDarkMode ? Colors.white : Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                )),
          ),
          body: (context, controller) => IndexedStack(
            index: Pages.values.indexOf(selectedTab),
            children: [
              HomePage(),
              ExplorePage(),
              ProfilePage(),
              // CardsPage(key: cardsPageKey),
              // ShopView(key: shopViewKey),
            ],
          ),
        ));
  }
}
