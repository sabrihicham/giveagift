import 'dart:convert';

import 'package:giveagift/core/classes/custom_controller.dart';
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/models/reciver_info.dart';
import 'package:giveagift/view/cards/data/models/custom_cards.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cart/data/model/cart.dart';
import 'package:giveagift/view/cart/data/repository/cart_repository.dart';
import 'package:giveagift/view/cart/data/source/cart_source.dart';

class CartController extends CustomController {
  CartRepository cartRepository = CartRepository(CartSource());

  List<Cart> get carts {
    List<String>? carts = SharedPrefs.instance.prefs.getStringList('carts');

    if(carts != null) {
      return carts.map((e) => Cart.fromJson(jsonDecode(e))).toList();
    }

    return [];
  }

  List<CustomCart> get customCarts {
    List<String>? customCarts = SharedPrefs.instance.prefs.getStringList('customCarts');

    if(customCarts != null) {
      return customCarts.map((e) => CustomCart.fromJson(jsonDecode(e))).toList();
    }

    return [];
  }

  void addReadyCardToCart(CardData card, ReceiverInfo receiverInfo) async {
    setState(Submitting());
    try {
      final cart = await cartRepository.addReadyCardToCart(card, receiverInfo);

      List<String>? carts = SharedPrefs.instance.prefs.getStringList('carts');

      if(carts != null) {
        List<Cart> cartList = carts.map((e) => Cart.fromJson(jsonDecode(e))).toList();

        cartList.add(cart);

        SharedPrefs.instance.prefs.setStringList('carts', cartList.map((e) => jsonEncode(e)).toList());
      } else {
        SharedPrefs.instance.prefs.setStringList('carts', [jsonEncode(cart)]);
      }

      setState(SubmissionSuccess());
    } catch (e) {
      if(e is CustomException) {
        return setState(SubmissionError(e));
      }

      setState(SubmissionError(CustomException('An error occurred while adding to cart.')));
    }
  }

  void addCustomCardToCart(CustomCardData customCard) async {
    setState(Submitting());
    try {
      final customCart = await cartRepository.addCustomCardToCart(customCard);

      List<String>? customCarts = SharedPrefs.instance.prefs.getStringList('customCarts');

      if(customCarts != null) {
        List<CustomCart> customCartList = customCarts.map((e) => CustomCart.fromJson(jsonDecode(e))).toList();

        customCartList.add(customCart);

        SharedPrefs.instance.prefs.setStringList('customCarts', customCartList.map((e) => jsonEncode(e)).toList());
      } else {
        SharedPrefs.instance.prefs.setStringList('customCarts', [jsonEncode(customCart)]);
      }

      setState(SubmissionSuccess());
    } catch (e) {
      if(e is CustomException) {
        return setState(SubmissionError(e));
      }

      setState(SubmissionError(CustomException('An error occurred while adding to cart.')));
    }
  }

  void removeReadyCardFromCart(int cartId) async {
    setState(Submitting());
    try {
      await cartRepository.removeReadyCardFromCart(cartId);

      List<String>? carts = SharedPrefs.instance.prefs.getStringList('carts');

      if(carts != null) {
        List<Cart> cartList = carts.map((e) => Cart.fromJson(jsonDecode(e))).toList();

        cartList.removeWhere((element) => element.id == cartId.toString());

        SharedPrefs.instance.prefs.setStringList('carts', cartList.map((e) => jsonEncode(e)).toList());
      }

      setState(SubmissionSuccess());
    } catch (e) {
      if(e is CustomException) {
        return setState(SubmissionError(e));
      }

      setState(SubmissionError(CustomException('An error occurred while removing from cart.')));
    }
  }
}