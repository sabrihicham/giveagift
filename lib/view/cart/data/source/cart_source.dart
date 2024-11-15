import 'dart:convert';

import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cart/data/model/card.dart';

class CartSource {
  String url = '${API.BASE_URL}/api/v1/cards';
  Uri get cardUrl => Uri.parse(url);

  Future<CreateCardResponse> addSpecialCardToCart(String shopId, num priceValue, String? recipientName, String? recipientNumber, DateTime? receiveAt) async {
    final response = await client.post(
      cardUrl,
      body: jsonEncode({
        "isSpecial": true,
        "shop": shopId,
        "price": {"value": priceValue},
        "recipient": {
          "name": recipientName,
          "whatsappNumber": recipientNumber,
        },
        "receiveAt": receiveAt?.toUtc().toIso8601String(),
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SharedPrefs.instance.token}',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return CreateCardResponse.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException.fromStatus(response.statusCode) ??
          CustomException('An error occurred while adding to cart.');
    }
  }

  Future<CreateCardResponse> addCustomCardToCart(CreateCardData card) async {
    final response = await client.post(
      cardUrl,
      body: jsonEncode(card.toJson()),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return CreateCardResponse.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException(jsonDecode(response.body)['message'] ?? 'An error occurred while adding to cart.');
    }
  }

  Future<bool> removeCardFromCart(String cartId) async {
    final response = await client.delete(
      Uri.parse('$cardUrl/$cartId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SharedPrefs.instance.token}',
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw CustomException.fromStatus(response.statusCode) ??
          CustomException('An error occurred while removing card from cart.');
    }
  }

  Future<GetCardsResponse> getCards() async {
    final response = await client.get(
      cardUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode < 500) {
      final cardsResponse = GetCardsResponse.fromJson(jsonDecode(response.body));

      if (cardsResponse.status != 'success') {
        throw CustomException(cardsResponse.message ?? 'An error occurred while fetching cards.');
      }

      return cardsResponse;
    } else {
      throw CustomException(jsonDecode(response.body)['message'] ?? 'An error occurred while fetching cards.');
    }
  }

  Future<GetCardResponse> getCard(String cardId) async {
    final response = await client.get(
      Uri.parse('$url/$cardId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return GetCardResponse.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException(GetCardResponse.fromJson(jsonDecode(response.body)).message ?? 'An error occurred while adding to cart.');
    }
  }

  Future<CreateCardResponse> updateCard(CreateCardData card) async {
    final response = await client.patch(
      Uri.parse('$url/${card.id}'),
      body: jsonEncode(card.toJson()),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return CreateCardResponse.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException(CreateCardResponse.fromJson(jsonDecode(response.body)).message ?? 'An error occurred while adding to cart.');
    }
  }
}
