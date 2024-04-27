import 'dart:convert';

import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/view/cards/data/models/custom_cards.dart';
import 'package:http/http.dart' as http;

class CustomCardsSource {
  static Future<CustomCardsResponse> getCustomCards() async {
    final response = await http.get(
      Uri.https('gifts-backend.onrender.com', '/get-custom-cards', 
      ),
    );
    
    if (response.statusCode == 200) {
      return CustomCardsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException.fromStatus(response.statusCode) ??  CustomException('An error occurred while fetching ready cards.');
    }
  }
}