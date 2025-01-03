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
        padding: EdgeInsets.zero,
        child: Column(
          children: [
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
