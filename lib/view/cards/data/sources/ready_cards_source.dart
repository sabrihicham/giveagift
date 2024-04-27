import 'dart:convert';

import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:http/http.dart' as http;

class ReadyCardsSource {
  static Future<ReadyCardsResponse> getReadyCards({int? minPrice, int? maxPrice, int? page, int? limit, List<String> ? brands}) async {
    final response = await http.get(
      Uri.https('gifts-backend.onrender.com', '/api/cards', <String, String>{
        if(minPrice != null && maxPrice != null)
          'price': '$minPrice-$maxPrice',
        if(page != null)
          'page': '$page',
        if(limit != null)
          'limit': '$limit',
        if(brands != null && brands.isNotEmpty)
          'brands': brands.join(',')
      }),
    );
    
    if (response.statusCode == 200) {
      return ReadyCardsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException.fromStatus(response.statusCode) ??  CustomException('An error occurred while fetching ready cards.');
    }
  }


}