import 'dart:convert';

import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/view/store/data/model/shop.dart';
import 'package:giveagift/core/classes/custom_exception.dart';

class ShopSource {
  Future<ShopsResponse> getShops({int? page}) async {
    final response = await client.get(
      Uri.parse(
        '${API.BASE_URL}/api/v1/shops?sort=priority',
      ),
    );

    if (response.statusCode == 200) {
      return ShopsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException.fromStatus(response.statusCode) ?? CustomException('An error occurred while fetching shops.');
    }
  }

  Future<ShopDetailsResponse> getShopDetails(String id) async {
    final response = await client.get(
      Uri.parse(
        '${API.BASE_URL}/api/v1/shops/$id',
      ),
    );

    if (response.statusCode == 200) {
      return ShopDetailsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException.fromStatus(response.statusCode) ?? CustomException('An error occurred while fetching the shop.');
    }
  }

}
