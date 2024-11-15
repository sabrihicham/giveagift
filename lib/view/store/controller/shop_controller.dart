import 'package:get/get.dart';
import 'package:giveagift/core/classes/custom_controller.dart';
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/view/store/data/model/shop.dart';
import 'package:giveagift/view/store/data/repository/shop_repository.dart';
import 'package:giveagift/view/store/data/source/shop_source.dart';

class ShopController extends CustomController {
  ShopRepository shopRepository = ShopRepository(ShopSource());

  Map<int, Set<Shop>> shops = {};

  ShopsResponse? response;

  Map<String, ShopDetails?> shopsDetails = {};

  int page = 1;

  void fetchShops() async {
    if (shops[page] != null && shops[page]!.isNotEmpty) {
      return setState(const SubmissionSuccess());
    }

    setState(Submitting());

    try {
      response = await shopRepository.getShops(page: page);

      for (var element in response!.data) {
        if (shops[page] == null) {
          shops[page] = {};
        }

        shops[page]!.add(element);
      }

      setState(const SubmissionSuccess());
    } catch (e) {
      if (e is CustomException) {
        return setState(SubmissionError(e));
      }

      setState(SubmissionError(CustomException('something_went_wrong'.tr)));
    }
  }

  void fetchShopDetails(String id) async {
    shopDetailSetState(Submitting(), id);

    try {
      final shopDetailsResponse = await shopRepository.getShopDetails(id);

      if (shopDetailsResponse.status != 'success') {
        return shopDetailSetState(SubmissionError(CustomException(shopDetailsResponse.message ?? 'حدث مشكل بالاتصال')), id);
      }

      shopsDetails[id] = shopDetailsResponse.data;

      shopDetailSetState(const SubmissionSuccess(), id);
    } catch (e) {
      if (e is CustomException) {
        return shopDetailSetState(SubmissionError(e), id);
      }

      shopDetailSetState(SubmissionError(CustomException('حدث مشكل بالاتصال')), id);
    }
  }

  void shopDetailSetState(SubmissionState? status, String id) {
    setState(status ?? const InitialState(), ids: ['${id}_shop_details']);
  }

  SubmissionState getShopDetailsState(String id) {
    return getState('${id}_shop_details');
  }

  @override
  void onInit() {
    fetchShops();
    super.onInit();
  }
}
