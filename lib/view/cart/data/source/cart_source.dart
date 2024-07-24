import 'dart:convert';

import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/models/reciver_info.dart';
import 'package:giveagift/view/cards/data/models/custom_cards.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cart/data/model/cart.dart';

import 'package:http/http.dart' as http;

class CartSource {
  Future<Cart> addReadyCardToCart(CardData card, ReceiverInfo receiverInfo) async {
    final response = await http.post(
      Uri.http(
        API.BASE_URL, '/api/cartReady',
      ),
      body: jsonEncode({
        "card": card.toJson(),
        "receiverInfo": receiverInfo.toJson(),
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 201) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException.fromStatus(response.statusCode) ??  CustomException('An error occurred while adding to cart.');
    }
  }

  Future<CustomCart> addCustomCardToCart(CustomCardData customCard) async {
    final response = await http.post(
      Uri.http(
        API.BASE_URL, '/api/cartCustom',
      ),
      body: jsonEncode(customCard.toJson()),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 201) {
      return CustomCart.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException.fromStatus(response.statusCode) ??  CustomException('An error occurred while adding to cart.');
    }
  }

  Future<String> removeReadyCardFromCart(String cartId) async {
    final response = await http.delete(
      Uri.http(
        API.BASE_URL, '/api/CartRemove/remove/$cartId/true',
      ),
    );
    
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return json['message'];
    } else {
      throw CustomException.fromStatus(response.statusCode) ??  CustomException('An error occurred while removing from cart.');
    }
  }
}