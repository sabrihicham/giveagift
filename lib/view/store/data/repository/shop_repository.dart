import 'package:giveagift/view/store/data/model/shop.dart';
import 'package:giveagift/view/store/data/source/shop_source.dart';

class ShopRepository {
  final ShopSource shopSource;

  ShopRepository(this.shopSource);

  Future<ShopsResponse> getShops({int page = 1}) async {
    return await shopSource.getShops(page: page);
  }

  Future<ShopDetailsResponse> getShopDetails(String id) async {
    return await shopSource.getShopDetails(id);
  }
}