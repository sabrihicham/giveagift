// ads?sort=priority

import 'dart:convert';

import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/view/cards/data/models/ads.dart';

class AdsSource {
  Future<AdsResponse> getAds() async {
    final response = await client. get(
      Uri.parse(
        '${API.BASE_URL}/api/v1/ads?sort=priority', 
      ),
    );
    
    if (response.statusCode == 200) {
      return AdsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException(jsonDecode(response.body)['message'] ?? 'An error occurred while fetching ready cards.');
    }
  }
}