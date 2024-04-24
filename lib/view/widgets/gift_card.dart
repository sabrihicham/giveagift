import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class GiftCard extends StatefulWidget {
  const GiftCard({
    super.key,
    this.controller,
    this.frontBackgroundImage,
    this.backBackgroundImage,
    this.color = Colors.white,
    this.aspectRatio = 4/3,

  });

  final GestureFlipCardController? controller;
  final String? frontBackgroundImage;
  final String? backBackgroundImage;
  final double aspectRatio;
  final Color color;

  @override
  State<GiftCard> createState() => _GiftCardState();
}

class _GiftCardState extends State<GiftCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child:  GestureFlipCard(
        // rotateSide: RotateSide.bottom,
        // onTapFlipping: false, //When enabled, the card will flip automatically when touched.
        axis: FlipAxis.vertical,
        controller: widget.controller,
        enableController: widget.controller != null,
        frontWidget: Container(
          width: double.infinity,
          color: widget.color,
          child: CachedNetworkImage(
              imageUrl: widget.frontBackgroundImage ?? "",
              fit: BoxFit.fill,
              errorWidget: (context, url, error) {
                return const Center(
                  child: Text('Image not found'),
                );
              },
            )
          ),
        backWidget: Container(
          width: double.infinity,
          color: widget.color,
          child: CachedNetworkImage(
              imageUrl: widget.backBackgroundImage ?? "",
              fit: BoxFit.fill,
              errorWidget: (context, url, error) {
                return const Center(
                  child: Text('Image not found'),
                );
              },
            )
          )
        )
    );
  }
}