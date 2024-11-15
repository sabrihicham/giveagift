import 'package:flutter/material.dart' hide Card;
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/extensions/web_images.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cards/widgets/custom_card.dart';
import 'package:giveagift/view/cards/widgets/layer.dart';
import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/widgets/gift_card.dart';

class MyFlipCard extends StatelessWidget {
  final Card card;
  final FlipCardController? controller;

  const MyFlipCard({
    super.key, 
    required this.card,
    this.controller
  });

  @override
  Widget build(BuildContext context) {
    
    return FlipCard(
      controller: controller ?? FlipCardController(),
      rotateSide: RotateSide.right,
      onTapFlipping: true,
      axis: FlipAxis.vertical,
      frontWidget: card.isSpecial
          ? GiftCard(
              frontBackgroundImage: API.BASE_URL + (SharedPrefs.instance.appConfig!.specialFrontShapePath ?? ''),
              backBackgroundImage: API.BASE_URL + (SharedPrefs.instance.appConfig!.specialBackShapePath ?? ''),
            )
          : LayoutBuilder(
              builder: (context, constrained) => CustomCard(
                color: card.color?.color,
                backgroundImage: card.proColor?.image.colorImage,
                foregroundImage: card.isSpecial
                    ? API.BASE_URL + (SharedPrefs.instance.appConfig!.specialFrontShapePath ?? '')
                    : null,
                foregroundImageFit: BoxFit.cover,
                layers: card.shapes?.map((e) {
                  return ShapeLayer(
                    cardShape: e.toRadians(),
                  )..locked = true;
                }).toList(),
                brandImage: card.shop?.logo.shopImage,
                showOnly: CardSide.front,
                locked: true,
              ),
            ),
      backWidget: card.isSpecial
          ? GiftCard(
              frontBackgroundImage: API.BASE_URL + (SharedPrefs.instance.appConfig!.specialFrontShapePath ?? ''),
              backBackgroundImage: API.BASE_URL + (SharedPrefs.instance.appConfig!.specialBackShapePath ?? ''),
            )
          : CustomCard(
              color: card.color?.color,
              backgroundImage: card.proColor?.image.colorImage,
              foregroundImage: card.isSpecial
                  ? API.BASE_URL + (SharedPrefs.instance.appConfig!.specialBackShapePath ?? '')
                  : null,
              // TODO: Check when to use layers
              layers: null,
              textStyle: TextStyle(
                color: card.text?.fontColorAtr,
                fontFamily: card.text?.fontFamilyAtr,
                fontSize: card.text?.fontSize?.toDouble(),
                fontWeight: FontWeight.values.firstWhereOrNull(
                  (element) => element.value == card.text?.fontWeight,
                ),
              ),
              message: card.text?.message,
              price: card.price!.value.toString(),
              currency: 'sar'.tr,
              showOnly: CardSide.back,
              locked: true,
              messagePosX: card.text?.xPosition?.toDouble(),
              messagePosY: card.text?.yPosition?.toDouble(),
            ),
    );
  }
}