import 'dart:convert';

import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/view/cards/data/models/shape.dart';

abstract class ShapesSource {
  Future<ShapesResponse> getShapes();
}

class ShapesSourceImpl implements ShapesSource {
  @override
  Future<ShapesResponse> getShapes() async {
    final response = await client.get(
      Uri.parse('${API.BASE_URL}/api/v1/shapes'),
    );

    if (response.statusCode == 200) {
      return ShapesResponse.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException.fromStatus(response.statusCode) ??
          CustomException('An error occurred while fetching custom cards.');
    }
  }
}
