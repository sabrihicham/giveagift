import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/cart/data/source/cart_source.dart';

class CartRepository {
  final CartSource cartSource;

  CartRepository(this.cartSource);

  Future<GetCardsResponse> getCards() async {
    return await cartSource.getCards();
  }

  Future<GetCardResponse> getCard(String cardId) async {
    return await cartSource.getCard(cardId);
  }

  Future<CreateCardResponse> addSpecialCardToCart(String shopId, num price, {String? recipientName, String? recipientNumber, DateTime? receiveAt}) async {
    return await cartSource.addSpecialCardToCart(shopId, price, recipientName, recipientNumber, receiveAt);
  }

  Future<CreateCardResponse> addCustomCardToCart(CreateCardData card) async {
    return await cartSource.addCustomCardToCart(card);
  }

  Future<bool> removeCardFromCart(String cartId) async {
    return await cartSource.removeCardFromCart(cartId);
  }

  Future<CreateCardResponse> updateCard(CreateCardData card) async {
    return await cartSource.updateCard(card);
  }
}