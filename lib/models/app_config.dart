// 20241002023532
// https://api.giveagift.com.sa/api/v1/configs

// {
//   "status": "success",
//   "data": [
//     {
//       "key": "WALLET_STARTING_BALANCE",
//       "value": "0"
//     },
//     {
//       "key": "MAIN_COLOR",
//       "value": "#b62026"
//     },
//     {
//       "key": "SECONDRY_COLOR",
//       "value": "#2D3A58"
//     },
//     {
//       "key": "SPECIAL_FRONT_SHAPE_PATH",
//       "value": "/specialCards/front-shape.webp"
//     },
//     {
//       "key": "SPECIAL_BACK_SHAPE_PATH",
//       "value": "/specialCards/back-shape.webp"
//     },
//     {
//       "key": "VAT_VALUE",
//       "value": "0"
//     },
//     {
//       "key": "CELEBRATE_ICON_PRICE",
//       "value": "5"
//     },
//     {
//       "key": "CELEBRATE_LINK_PRICE",
//       "value": "10"
//     },
//     {
//       "key": "CASH_BACK_PERCENTAGE",
//       "value": "15"
//     },
//     {
//       "key": "CART_REMINDER_MESSAGE",
//       "value": "Hi, we see that you have created something special! Your card is ready to be yours.Do not miss out – complete your purchase now. 💌"
//     },
//     {
//       "key": "UNUSED_CODE_REMINDER_MESSAGE",
//       "value": "Hey, your discount code is still waiting for you! Don’t miss out on the chance to save big on your next purchase💸"
//     },
//     {
//       "key": "WHATSAPP_CARD_MESSAGE",
//       "value": "You have received a gift card from [USER_NAME]. Click here to view: [CARD_LINK]"
//     }
//   ]
// }

import 'package:flutter/material.dart';

class AppConfigResponse {
  AppConfigResponse({
    required this.status,
    required this.data,
  });

  final String status;
  final AppConfigModel data;

  factory AppConfigResponse.fromJson(Map<String, dynamic> json) => AppConfigResponse(
    status: json["status"],
    // list to map (key, value)
    data: AppConfigModel.fromJson({ for (var item in json["data"]) item["key"] : item["value"] })  
  );

  Map<String, dynamic> toJson() => {
      "status": status,
      "data": data.toJson(),
    };
}

class AppConfigModel {
  AppConfigModel({
    this.startingBalance,
    this.mainColor,
    this.secondaryColor,
    this.specialFrontShapePath,
    this.specialBackShapePath,
    this.vatValue,
    this.celebrateIconPrice,
    this.celebrateLinkPrice,
    this.cashBackPercentage,
    this.cartReminderMessage,
    this.unusedCodeReminderMessage,
    this.whatsappCardMessage,
  });

  final num? startingBalance;
  final Color? mainColor;
  final Color? secondaryColor;
  final String? specialFrontShapePath;
  final String? specialBackShapePath;
  final num? vatValue;
  final num? celebrateIconPrice;
  final num? celebrateLinkPrice;
  final num? cashBackPercentage;
  final String? cartReminderMessage;
  final String? unusedCodeReminderMessage;
  final String? whatsappCardMessage;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) => AppConfigModel(
      // startingBalance: num.parse(json["WALLET_STARTING_BALANCE"]),
      // mainColor: Color(int.parse(json["MAIN_COLOR"].substring(1, 7), radix: 16) + 0xFF000000),
      // secondaryColor: Color(int.parse(json["SECONDRY_COLOR"].substring(1, 7), radix: 16) + 0xFF000000),
      // specialFrontShapePath: json["SPECIAL_FRONT_SHAPE_PATH"],
      // specialBackShapePath: json["SPECIAL_BACK_SHAPE_PATH"],
      // vatValue: num.parse(json["VAT_VALUE"]),
      // celebrateIconPrice: num.parse(json["CELEBRATE_ICON_PRICE"]),
      // celebrateLinkPrice: num.parse(json["CELEBRATE_LINK_PRICE"]),
      // cashBackPercentage: num.parse(json["CASH_BACK_PERCENTAGE"]),
      // cartReminderMessage: json["CART_REMINDER_MESSAGE"],
      // unusedCodeReminderMessage: json["UNUSED_CODE_REMINDER_MESSAGE"],
      // whatsappCardMessage: json["WHATSAPP_CARD_MESSAGE"],

      // null safty
      startingBalance: json["WALLET_STARTING_BALANCE"] == null ? null : num.parse(json["WALLET_STARTING_BALANCE"]),
      mainColor: json["MAIN_COLOR"] == null ? null : Color(int.parse(json["MAIN_COLOR"].substring(1, 7), radix: 16) + 0xFF000000),
      secondaryColor: json["SECONDRY_COLOR"] == null ? null : Color(int.parse(json["SECONDRY_COLOR"].substring(1, 7), radix: 16) + 0xFF000000),
      specialFrontShapePath: json["SPECIAL_FRONT_SHAPE_PATH"],
      specialBackShapePath: json["SPECIAL_BACK_SHAPE_PATH"],
      vatValue: json["VAT_VALUE"] == null ? null : num.parse(json["VAT_VALUE"]),
      celebrateIconPrice: json["CELEBRATE_ICON_PRICE"] == null ? null : num.parse(json["CELEBRATE_ICON_PRICE"]),
      celebrateLinkPrice: json["CELEBRATE_LINK_PRICE"] == null ? null : num.parse(json["CELEBRATE_LINK_PRICE"]),
      cashBackPercentage: json["CASH_BACK_PERCENTAGE"] == null ? null : num.parse(json["CASH_BACK_PERCENTAGE"]),
      cartReminderMessage: json["CART_REMINDER_MESSAGE"],
      unusedCodeReminderMessage: json["UNUSED_CODE_REMINDER_MESSAGE"],
      whatsappCardMessage: json["WHATSAPP_CARD_MESSAGE"],
    );

  Map<String, dynamic> toJson() => {
      // "WALLET_STARTING_BALANCE": startingBalance.toString(),
      // "MAIN_COLOR": "#${mainColor.value.toRadixString(16).substring(2)}",
      // "SECONDRY_COLOR": "#${secondaryColor.value.toRadixString(16).substring(2)}",
      // "SPECIAL_FRONT_SHAPE_PATH": specialFrontShapePath,
      // "SPECIAL_BACK_SHAPE_PATH": specialBackShapePath,
      // "VAT_VALUE": vatValue.toString(),
      // "CELEBRATE_ICON_PRICE": celebrateIconPrice.toString(),
      // "CELEBRATE_LINK_PRICE": celebrateLinkPrice.toString(),

      // null saftey
      "WALLET_STARTING_BALANCE": startingBalance?.toString(),
      "MAIN_COLOR": mainColor == null ? null : "#${mainColor!.value.toRadixString(16).substring(2)}",
      "SECONDRY_COLOR": secondaryColor == null ? null : "#${secondaryColor!.value.toRadixString(16).substring(2)}",
      "SPECIAL_FRONT_SHAPE_PATH": specialFrontShapePath,
      "SPECIAL_BACK_SHAPE_PATH": specialBackShapePath,
      "VAT_VALUE": vatValue?.toString(),
      "CELEBRATE_ICON_PRICE": celebrateIconPrice?.toString(),
      "CELEBRATE_LINK_PRICE": celebrateLinkPrice?.toString(),
      "CASH_BACK_PERCENTAGE": cashBackPercentage?.toString(),
      "CART_REMINDER_MESSAGE": cartReminderMessage,
      "UNUSED_CODE_REMINDER_MESSAGE": unusedCodeReminderMessage,
      "WHATSAPP_CARD_MESSAGE": whatsappCardMessage,
  };
}