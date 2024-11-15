import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.frontBackgroundImageFit = BoxFit.fill,
    this.frontForegroundImage,
    this.backForegroundImageFit = BoxFit.fitHeight,
    this.isFrontAssets = false,
    this.backBackgroundImage,
    this.backForegroundImage,
    this.isBackAssets = false,
    this.color,
    this.aspectRatio = 343 / 213,
    this.borderRadius = 30,
  });

  final GestureFlipCardController? controller;
  final CardSide? showOnly;
  final String? frontBackgroundImage;
  final BoxFit frontBackgroundImageFit;
  final String? frontForegroundImage;
  final BoxFit backForegroundImageFit;
  final bool isFrontAssets, isBackAssets;
  final String? backBackgroundImage;
  final String? backForegroundImage;
  final double aspectRatio;
  final Color? color;
  final double borderRadius;

  @override
  State<GiftCard> createState() => _GiftCardState();
}

class _GiftCardState extends State<GiftCard> {
  Widget _buildImage(String url,
      {bool isAssets = false, BoxFit? fit = BoxFit.fill}) {
    final svgFunction = isAssets ? SvgPicture.asset : SvgPicture.network;

    return RegExp(r'.svg').hasMatch(url)
        ? svgFunction(
            url,
            fit: fit ?? BoxFit.contain,
            placeholderBuilder: (context) => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        : !isAssets
            ? CachedNetworkImage(
                imageUrl: url,
                fit: fit,
                width: double.infinity,
                height: double.infinity,
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              )
            : Image.asset(
                url,
                fit: fit,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              );
  }

  @override
  Widget build(BuildContext context) {
    final front = Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          _buildImage(
            widget.frontBackgroundImage ?? "",
            isAssets: widget.isFrontAssets,
            fit: widget.frontBackgroundImageFit,
          ),
          if (widget.frontForegroundImage != null)
            _buildImage(
              widget.frontForegroundImage ?? "",
              isAssets: widget.isFrontAssets,
              fit: widget.backForegroundImageFit,
            ),
        ],
      ),
    );

    final back = Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          _buildImage(
            widget.backBackgroundImage ?? "",
            isAssets: widget.isBackAssets,
            fit: widget.frontBackgroundImageFit,
          ),
          if (widget.backForegroundImage != null)
            _buildImage(
              widget.backForegroundImage ?? "",
              isAssets: widget.isBackAssets,
              fit: widget.backForegroundImageFit,
            ),
        ],
      ),
    );

    Widget? flipCard;

    if (widget.showOnly == null) {
      flipCard = GestureFlipCard(
        axis: FlipAxis.vertical,
        controller: widget.controller,
        enableController: widget.controller != null,
        frontWidget: front,
        backWidget: back,
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 343.w,
        maxHeight: 213.h,
      ),
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: widget.color,
          ),
          child: widget.showOnly == null
              ? flipCard
              : widget.showOnly == CardSide.front
                  ? front
                  : back,
        ),
      ),
    );
  }
}
