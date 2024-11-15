import 'package:flutter/material.dart' hide Card;

import 'package:get/get.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/dialog_utils.dart';
import 'package:giveagift/core/utiles/loading_overlay.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';
import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/cart/widgets/cart_item.dart';
import 'package:giveagift/view/profile/controller/profile_controller.dart';

import 'package:giveagift/view/profile/profile.dart';

final cartPageKey = GlobalKey<_CartPageState>();

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController controller = Get.find<CartController>();

  bool isPaid = false;

  void _onRemove(Card card) async {
    OverlayUtils.showLoadingOverlay(
        text: 'removing_card'.tr,
        asyncFunction: () async {
          final success = await controller.removeCardFromCart(card.id);

          if (success) {}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          'cart'.tr,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Get.isDarkMode ? Colors.grey[900] : Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: Get.find<ProfileController>().isLoggedIn,
        builder: (context, value, _) => !value
            ? NotLogedIn(
                onLogIn: (value) {
                  if (value) {
                    Get.find<ProfileController>().onInit();
                  }
                },
              )
            : GetBuilder(
                init: controller,
                builder: (controller) {
                  if (controller.defaultState is Submitting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  if (controller.defaultState is SubmissionError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text((controller.defaultState as SubmissionError).exception.message),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              controller.getCards();
                            },
                            child: Text('refresh'.tr),
                          )
                        ],
                      ),
                    );
                  }

                  List<Card>? cards;

                  if (controller.cards != null) {
                    cards = [];
                    for (var card in controller.cards!) {
                      if (card.isPaid == isPaid) {
                        cards.add(card);
                      }
                    }
                  }

                  return cards!.isEmpty
                      ? SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('empty_cart'.tr),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  controller.getCards();
                                },
                                child: Text('refresh'.tr),
                              )
                            ],
                          ),
                        )
                      : RefreshIndicator.adaptive(
                          onRefresh: () async {
                            controller.getCards();
                          },
                          child: ListView.builder(
                            itemCount: cards.length,
                            itemBuilder: (context, index) {
                              final card = cards![index];
                              return ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 600,
                                ),
                                child: Dismissible(
                                  key: Key(card.id),
                                  onDismissed: (direction) {
                                    _onRemove(card);
                                  },
                                  confirmDismiss: (direction) async {
                                    return await DialogUtils.globalShowDialog<bool?>(
                                      title: 'remove_card'.tr,
                                      confirmText: "delete".tr,
                                      content: [
                                        FittedBox(
                                          child: Text(
                                            'remove_card_message'.tr
                                          )
                                        ),
                                      ],
                                    );
                                  },
                                  child: CartItem(card: card, onRemove: _onRemove),
                                ),
                              );
                            },
                          ),
                        );
                }),
      ),
    );
  }
}
