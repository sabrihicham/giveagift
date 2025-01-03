import 'package:flutter/material.dart' hide Card;
import 'package:get/get.dart';
import 'package:giveagift/core/classes/custom_controller.dart';
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/dialog_utils.dart';
import 'package:giveagift/core/utiles/loading_overlay.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cards/pages/ready_card_page.dart';
import 'package:giveagift/view/cart/cart.dart';
import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/cart/data/repository/cart_repository.dart';
import 'package:giveagift/view/cart/data/source/cart_source.dart';
import 'package:giveagift/view/cart/recepient_info.dart';

class CartController extends CustomController {
  CartRepository cartRepository = CartRepository(CartSource());

  List<Card>? get cards {
    return SharedPrefs.instance.cards;
  }

  void addToCart(
    String cardId, 
    String? celebrateIcon, 
    String? celebrateLink, 
    DateTime? selectedTime, 
    String reciverName, 
    String reciverPhone
    ) async {
    OverlayUtils.showLoadingOverlay(
      asyncFunction: () async {

        await updateCard(
          CreateCardData(
            id: cardId,
            celebrateIcon: celebrateIcon,
            celebrateLink: celebrateLink,
            receiveAt: selectedTime?.toUtc() ?? DateTime.now().toUtc(),
            recipient: Recipient(
              name: reciverName,
              whatsappNumber: reciverPhone
            ),
          )
        );

        if(updateCardState is SubmissionSuccess) {
          // TODO: Look this
          Navigator.pop(Get.context!, true);
        } else if(updateCardState is SubmissionError) {
          Get.snackbar(
            'error'.tr,
            (updateCardState as SubmissionError).exception.message,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      }
    );
  }

  Future<Card?> getCard(String cardId) async {
    getCardSetState(Submitting());
    try {
      final cardResponse = await cartRepository.getCard(cardId);

      getCardSetState(const SubmissionSuccess());

      return cardResponse.data;
    } catch (e) {
      if (e is CustomException) {
        getCardSetState(SubmissionError(e));
        return null;
      }

      getCardSetState(SubmissionError(CustomException('An error occurred while fetching cards.')));
    }
    return null;
  }

  void getCards() async {
    setState(Submitting());
    try {
      final cards = await cartRepository.getCards();

      SharedPrefs.instance.setCards(cards.data);

      setState(const SubmissionSuccess());
    } catch (e) {
      if (e is CustomException) {
        return setState(SubmissionError(e));
      }

      setState(SubmissionError(CustomException('An error occurred while fetching cards.')));
    }
  }

  Future<void> addSpecialCardToCartView(String shopId, CardData card, BuildContext context) async {
    final isLoggedIn = await DialogUtils.askForLogin(context);
                
    if (!isLoggedIn) {
      return;
    }

    CreateCardResponse? response;

    await OverlayUtils.showLoadingOverlay(
      asyncFunction: () async {
        response = await addSpecialCardToCart(shopId, card.price);
      },
    );

    String _message;
    bool success = false;

    if (response != null) {
      if (response!.status == "success") {
        _message = 'add_to_cart_success'.tr;
        success = true;

        await Get.to(() => RecepientInfoPage(card: card.toCard().copyWith(id: response!.data['_id']), later: true));
      } else {
        _message = 'add_to_cart_failed'.tr;
      }
    } else {
      if (specialCardState is SubmissionError) {
          _message = (specialCardState as SubmissionError).exception.message;
      } else {
        _message = 'add_to_cart_failed'.tr;
      }
    }

    SnackBarHelper.showSnackBar(
      title: success ? 'success'.tr : 'error'.tr,
      message: _message,
      color: success ? Colors.green : Colors.red,
      buttonText: 'view_cart'.tr,
      onTapButton: () {
        // appNavigationKey.currentState?.changeSelectedTab(Pages.cart);
        Get.to(() => CartPage(key: cartPageKey));
        Get.closeCurrentSnackbar();
      });
  }

  Future<CreateCardResponse?> addSpecialCardToCart(String shopId, num price,
      {String? recipientName,
      String? recipientNumber,
      DateTime? receiveAt}) async {
    specialCardSetState(Submitting());
    try {
      final cardResponse = await cartRepository.addSpecialCardToCart(
          shopId, price,
          recipientName: recipientName,
          recipientNumber: recipientNumber,
          receiveAt: receiveAt);

      getCards();

      specialCardSetState(const SubmissionSuccess());

      return cardResponse;
    } catch (e) {
      if (e is CustomException) {
        specialCardSetState(SubmissionError(e));
      } else {
        specialCardSetState(SubmissionError(
            CustomException('An error occurred while adding to cart.')));
      }
    }

    return null;
  }

  Future<CreateCardResponse?> addCustomCardToCart(CreateCardData card) async {
    customCardSetState(Submitting());
    try {
      final response = await cartRepository.addCustomCardToCart(card);

      getCards();

      customCardSetState(const SubmissionSuccess());

      return response;
    } catch (e) {
      if (e is CustomException) {
        customCardSetState(SubmissionError(e));
        return null;
      }

      customCardSetState(
        SubmissionError(CustomException('An error occurred while adding to cart.'))
      );
      
      return null;
    }
  }

  // void addCustomCardToCart(CustomCardData customCard) async {
  //   setState(Submitting());
  //   try {
  //     final customCart = await cartRepository.addCustomCardToCart(customCard);

  //     List<String>? customCarts = SharedPrefs.instance.prefs.getStringList('customCarts');

  //     if(customCarts != null) {
  //       List<CustomCart> customCartList = customCarts.map((e) => CustomCart.fromJson(jsonDecode(e))).toList();

  //       customCartList.add(customCart);

  //       SharedPrefs.instance.prefs.setStringList('customCarts', customCartList.map((e) => jsonEncode(e)).toList());
  //     } else {
  //       SharedPrefs.instance.prefs.setStringList('customCarts', [jsonEncode(customCart)]);
  //     }

  //     setState(const SubmissionSuccess());
  //   } catch (e) {
  //     if(e is CustomException) {
  //       return setState(SubmissionError(e));
  //     }

  //     setState(SubmissionError(CustomException('An error occurred while adding to cart.')));
  //   }
  // }

  Future<bool> removeCardFromCart(String cartId) async {
    removeCardSetState(Submitting());
    try {
      final result = await cartRepository.removeCardFromCart(cartId);

      getCards();

      removeCardSetState(const SubmissionSuccess());

      return result;
    } catch (e) {
      if (e is CustomException) {
        removeCardSetState(SubmissionError(e));
      } else {
        removeCardSetState(SubmissionError(
            CustomException('An error occurred while removing from cart.')));
      }
    }
    return false;
  }

  Future<void> updateCard(CreateCardData card) async {
    updateCardSetState(Submitting());
    try {
      final result = await cartRepository.updateCard(card);

      if (result.status != "success") {
        throw CustomException(
          result.message ?? 'An error occurred while updating card.',
        );
      }

      getCards();

      updateCardSetState(const SubmissionSuccess());
    } catch (e) {
      if (e is CustomException) {
        updateCardSetState(SubmissionError(e));
      } else {
        updateCardSetState(
          SubmissionError(
            CustomException('An error occurred while removing from cart.'),
          ),
        );
      }
    }
  }

  void getCardSetState(SubmissionState status) {
    setState(status, ids: ['getCard']);
  }

  SubmissionState get getCardState => getState('getCard');

  void specialCardSetState(SubmissionState status) {
    setState(status, ids: ['specialCard']);
  }

  SubmissionState get specialCardState => getState('specialCard');

  void customCardSetState(SubmissionState status) {
    setState(status, ids: ['customCard']);
  }

  SubmissionState get customCardState => getState('customCard');

  void removeCardSetState(SubmissionState status) {
    setState(status, ids: ['removeCard']);
  }

  void updateCardSetState(SubmissionState status) {
    setState(status, ids: ['updateCard']);
  }

  SubmissionState get removeCardState => getState('removeCard');

  SubmissionState get updateCardState => getState('updateCard');

  @override
  void onInit() {
    getCards();
    super.onInit();
  }
}
