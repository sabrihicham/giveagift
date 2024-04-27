import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

enum CardSide {
  front,
  back,
}

class GiftCard extends StatefulWidget {
  const GiftCard({
    super.key,
    this.controller,
    this.showOnly,
    this.frontBackgroundImage,
    this.backBackgroundImage,
    this.color,
    this.aspectRatio = 4/3,

  });

  final GestureFlipCardController? controller;
  final CardSide? showOnly;
  final String? frontBackgroundImage;
  final String? backBackgroundImage;
  final double aspectRatio;
  final Color? color;

  @override
  State<GiftCard> createState() => _GiftCardState();
}

class _GiftCardState extends State<GiftCard> {
  @override
  Widget build(BuildContext context) {

    final front = Container(
      width: double.infinity,
      color: widget.color,
      child: CachedNetworkImage(
          imageUrl: widget.frontBackgroundImage ?? "",
          fit: BoxFit.fill,
          errorWidget: (context, url, error) => const SizedBox.shrink(),
        )
      );

    final back = Container(
      width: double.infinity,
      color: widget.color,
      child: CachedNetworkImage(
          imageUrl: widget.backBackgroundImage ?? "",
          fit: BoxFit.fill,
          errorWidget: (context, url, error) => const SizedBox.shrink(),
        )
      );

    Widget? flipCard;

    if(widget.showOnly == null) {
      flipCard = GestureFlipCard(
        axis: FlipAxis.vertical,
        controller: widget.controller,
        enableController: widget.controller != null,
        frontWidget: front,
        backWidget: back
        );
    }
    

    return Container(
      height: 180,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: widget.showOnly == null 
        ? flipCard 
        : widget.showOnly == CardSide.front 
          ? front 
          : back,
    );
  }
}