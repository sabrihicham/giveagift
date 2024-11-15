import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cards/pages/custom_card_page.dart';
import 'package:giveagift/view/cards/pages/ready_card_page.dart';
import 'package:giveagift/view/store/data/model/shop.dart';

GlobalKey<CardsPageState> cardsPageKey = GlobalKey<CardsPageState>();

class CardsPage extends StatefulWidget {
  const CardsPage({
    super.key,
    this.initialTab = CardType.readyToUse,
    this.shop,
    this.hideAppBar = false,
    this.title,
  });

  final CardType initialTab;
  final Shop? shop;
  final bool hideAppBar;
  final String? title;

  @override
  State<CardsPage> createState() => CardsPageState();
}

class CardsPageState extends State<CardsPage> {
  final controller = Get.find<CardsController>();
  late CardType _selectedTab;

  @override
  void initState() {
    _selectedTab = widget.initialTab;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        // padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // TODO: Implement CustomSlidingSegmentedControl
            // CustomSlidingSegmentedControl<CardType>(
            //   initialValue: _selectedTab,
            //   children: <CardType, Widget> {
            //     CardType.readyToUse: Text('ready_to_use'.tr),
            //     CardType.custom: Text('custom'.tr),
            //   },
            //   padding: MediaQuery.of(context).viewPadding.top,
            //   // innerPadding: EdgeInsets.symmetric(
            //   //   vertical: 5,
            //   //   horizontal: 2,
            //   // ),
            //   decoration: BoxDecoration(
            //     color: Get.isDarkMode 
            //     ? Colors.grey[900] 
            //     : CupertinoColors.lightBackgroundGray,
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   thumbDecoration: BoxDecoration(
            //     color: Get.isDarkMode
            //       ? Colors.grey[700]
            //       : Colors.white,
            //     borderRadius: BorderRadius.circular(6),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Get.isDarkMode
            //           ? Colors.grey[900]!
            //           : Colors.grey[300]!,
            //         blurRadius: 4.0,
            //         spreadRadius: 1.0,
            //         offset: const Offset(
            //           0.0,
            //           2.0,
            //         ),
            //       ),
            //     ],
            //   ),
            //   duration: const Duration(milliseconds: 300),
            //   curve: Curves.easeInToLinear,
            //   onValueChanged: (v) {
            //     setState(() {
            //       _selectedTab = v;
            //     });
            //   },
            // ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedTab == CardType.readyToUse
                  ? ReadyToUsePage(controller: controller, hideAppBar: widget.hideAppBar, title: widget.title)
                  : CustomCardPage(controller: controller, shop: widget.shop),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
