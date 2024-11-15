import 'dart:convert';

import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/view/cards/data/models/color.dart';

abstract class ColorsSource {
  Future<ColorsResponse> getColors();
}

class ColorsSourceImp implements ColorsSource {
  
  @override
  Future<ColorsResponse> getColors() async {
    final response = await client.get(
      Uri.parse('${API.BASE_URL}/api/v1/colors'),
    );
    
    if (response.statusCode == 200) {
      return ColorsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw  CustomException('An error occurred while fetching colors.');
    }
  }
}