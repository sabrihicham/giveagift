import 'package:giveagift/core/classes/custom_controller.dart';
import 'package:giveagift/view/cart/data/repository/cart_repository.dart';
import 'package:giveagift/view/cart/data/source/cart_source.dart';
import 'package:giveagift/view/store/data/model/store.dart';

class CartController extends CustomController {
  CartRepository cartRepository = CartRepository(CartSource());

  StoreModelResponse? response;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}