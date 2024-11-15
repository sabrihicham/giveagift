import 'dart:convert';

import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/view/cards/data/models/category.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';

class ReadyCardsSource {
  Future<ReadyCardsResponse> getReadyCards({int? minPrice, int? maxPrice, int? page, int? limit, List<String> ? brands}) async {
    final response = await client. get(
      Uri.parse(
        '${API.BASE_URL}/api/v1/special-cards', 
        // <String, String>{
        // if(minPrice != null && maxPrice != null)
        //   'price': '$minPrice-$maxPrice',
        // if(page != null)
        //   'page': '$page',
        // if(limit != null)
        //   'limit': '$limit',
        // if(brands != null && brands.isNotEmpty)
        //   'brands': brands.join(',')
        // }
      ),
    );
    
    if (response.statusCode == 200) {
      return ReadyCardsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException.fromStatus(response.statusCode) ??  CustomException('An error occurred while fetching ready cards.');
    }
  }

  Future<CategoriesResponse> getCategories() async {
    final response = await client.get(
      Uri.parse('${API.BASE_URL}/api/v1/categories'),
    );

    if (response.statusCode == 200) {
      return CategoriesResponse.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException.fromStatus(response.statusCode) ?? CustomException('An error occurred while fetching categories.');
    }
  }
}