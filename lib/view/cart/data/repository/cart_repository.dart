import 'package:giveagift/models/reciver_info.dart';
import 'package:giveagift/view/cards/data/models/custom_cards.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cart/data/model/cart.dart';
import 'package:giveagift/view/cart/data/source/cart_source.dart';

class CartRepository {
  final CartSource cartSource;

  CartRepository(this.cartSource);

  Future<Cart> addReadyCardToCart(CardData card, ReceiverInfo receiverInfo) async {
    return await cartSource.addReadyCardToCart(card, receiverInfo);
  }

  Future<CustomCart> addCustomCardToCart(CustomCardData customCard) async {
    return await cartSource.addCustomCardToCart(customCard);
  }

  Future<String> removeReadyCardFromCart(int cartId) async {
    return await cartSource.removeReadyCardFromCart(cartId);
  }
}