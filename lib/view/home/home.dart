import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:giveagift/app_navigation.dart';
import 'package:giveagift/constants/enums.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/view/cards/cards.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';
import 'package:giveagift/view/widgets/gift_card.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverStack(
          children: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/home_bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container( 
                      color: Colors.black.withOpacity(0.4),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (0.1),
                        vertical: MediaQuery.of(context).size.height * (0.1),
                      ),
                      child: FittedBox(
                        child: Container(
                          height: 200,
                          width: 300,
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          decoration: const BoxDecoration(
                            color:  Color.fromRGBO(182, 32, 38, 0.75),
                            shape: BoxShape.rectangle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'home_body'.tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "home_desc".tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/home_bg_2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.25),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            width: double.infinity,
                            child: Text(
                              "- ${"choose_what_suits_you".tr} -",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Colors.grey[300],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Builder(
                              builder: (context) {
                                Widget layoutbuilder({required List<Widget> children}) 
                                {
                                  return LayoutBuilder(
                                    builder: (context, constraints) {
                                      if (constraints.maxWidth > 600) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: children,
                                        );
                                      }
                                      return Column(
                                        children: children,
                                      );
                                    },
                                  );
                                }
                      
                                return layoutbuilder(
                                  children: [
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            appNavigationKey.currentState?.changeSelectedTab(Pages.cards);
                                            cardsPageKey.currentState?.changeTab(CardType.readyToUse);
                                          },
                                          child: const GiftCard(
                                            frontBackgroundImage: 'https://giveagift.com.sa/images/home2.png',
                                            backBackgroundImage: "https://i.ibb.co/jJRT8qW/back.png",
                                          ),
                                        ),
                                        // Gift Cards
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 20),
                                          child: Text(
                                            "gift_cards".tr,
                                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        // Choose a gift card from our wide collection
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 0),
                                          child: Text(
                                            "gift_cards_desc".tr,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            appNavigationKey.currentState?.changeSelectedTab(Pages.cards);
                                            cardsPageKey.currentState?.changeTab(CardType.custom);
                                          },
                                          child: const GiftCard(
                                            frontBackgroundImage: 'https://i.ibb.co/64djgNY/home2.webp',
                                            backBackgroundImage: "https://i.ibb.co/4Rd3jz2/home1-back.png"
                                          ),
                                        ),
                                        // Custom Cards
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 20),
                                          child: Text(
                                            "custom_cards".tr,
                                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        // Create a custom gift card for your loved ones
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 0),
                                          child: Text(
                                            "custom_cards_desc".tr,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          height: MediaQuery.of(context).padding.bottom,
                                        )
                                      ],
                                    )
                                  ],
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    )
                  )
                ],
              )
            ),
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              // stretch: true,
              // forceMaterialTransparency: true,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                // stretchModes: [StretchMode.zoomBackground],
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // floating: true,
              // forceElevated: false,
              // snap: true,
              actions: [
                GetBuilder(
                  init: cartController,
                  didChangeDependencies: (controller) {
                    if(controller.controller?.submissionState is SubmissionError) {
                      Get.snackbar(
                        'Error',
                        (controller.controller!.submissionState as SubmissionError).exception?.message ?? 'An error occurred',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  builder: (controller) {
                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: Badge(
                        label: Text(
                          '${cartController.customCarts.length + cartController.carts.length}',
                        ),
                        isLabelVisible: true,
                        backgroundColor: Colors.redAccent,
                        offset: const Offset(-5, 5),
                        child: IconButton(
                          onPressed: () {
                            appNavigationKey.currentState?.changeSelectedTab(Pages.cart);
                          },
                          icon: const Icon(
                            Icons.shopping_bag_rounded,
                            size: 30,
                          ),
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}