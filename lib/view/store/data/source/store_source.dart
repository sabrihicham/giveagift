import 'dart:convert';

import 'package:giveagift/view/store/data/model/store.dart';
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:http/http.dart' as http;

class StoreSource {
  static Future<StoreModelResponse> getStores({int? page}) async {
    final response = await http.get(
      Uri.https(
        'gifts-backend.onrender.com', '/stores',
        {
          'page': page.toString(),
        }
      ),
    );
    
    if (response.statusCode == 200) {
      return StoreModelResponse.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException.fromStatus(response.statusCode) ??  CustomException('An error occurred while fetching custom cards.');
    }
  }
}