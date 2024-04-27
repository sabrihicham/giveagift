
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cards/pages/custom_card_page.dart';
import 'package:giveagift/view/cards/pages/ready_card_page.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({
    super.key,
    this.initialTab = CardType.readyToUse
  });

  final CardType initialTab;

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final controller = Get.put(CardsController());
  late CardType _selectedTab;

  @override
  void initState() {
    _selectedTab = widget.initialTab;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: Column(
        children: [
          CustomSlidingSegmentedControl<CardType>(
            initialValue: _selectedTab,
            children: const <CardType, Widget>{
              CardType.readyToUse: Text('Ready to Use'),
              CardType.custom: Text('Custom'),
            },
            padding: MediaQuery.of(context).viewPadding.top,
            decoration: BoxDecoration(
              color: CupertinoColors.lightBackgroundGray,
              borderRadius: BorderRadius.circular(8),
            ),
            thumbDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.3),
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                  offset: const Offset(
                    0.0,
                    2.0,
                  ),
                ),
              ],
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInToLinear,
            onValueChanged: (v) {
              setState(() {
                _selectedTab = v;
              });
            },
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedTab == CardType.readyToUse
                  ? ReadyToUsePage(controller: controller)
                  : CustomCardPage(controller: controller),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
