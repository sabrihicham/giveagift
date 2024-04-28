import 'package:giveagift/view/cart/data/source/cart_source.dart';

class CartRepository {
  final CartSource cartSource;

  CartRepository(this.cartSource);

  Future<void> getStores() async {
    return await cartSource.addReadyCardToCart();
  }
}