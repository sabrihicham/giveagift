import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giveagift/view/cards/widgets/brand_image.dart';
import 'package:giveagift/view/cards/widgets/layer.dart';
import 'package:giveagift/view/cards/widgets/layer_widget.dart';
import 'package:giveagift/view/widgets/gift_card.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({
    super.key,
    this.showOnly = CardSide.front,
    this.color,
    this.backgroundImage,
    this.backgroundImageFit,
    this.foregroundImage,
    this.foregroundImageFit,
    this.layers,
    this.brandImage,
    this.textStyle,
    this.message,
    this.price,
    this.currency = 'SAR',
    this.locked = false,
    this.centerText = false,
    this.messagePosX,
    this.messagePosY,
    this.onMessageDrag,
    this.onDelete,
  });

  final CardSide showOnly;
  final Color? color;
  final String? backgroundImage;
  final BoxFit? backgroundImageFit;
  final String? foregroundImage;
  final BoxFit? foregroundImageFit;
  final List<Layer>? layers;
  final String? brandImage;
  final TextStyle? textStyle;
  final String? message, price;
  final String currency;
  final bool locked;
  final bool centerText;
  final double? messagePosX, messagePosY;
  final Function(double x, double y, double? height, double? width)? onMessageDrag;
  final Function(Layer layer)? onDelete;

  @override
  State<CustomCard> createState() => CustomCardState();
}

class CustomCardState extends State<CustomCard> {
  double messagePosX = 0, messagePosY = 0;
  double backgrounImageScale = 1;
  double backgroundPosX = -1, backgroundPosY = -1;
  bool dragIsOn = false;

  @override
  void initState() {
    // get widget size after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.centerText) {
        // x: cardWidth / 2 - (cardWidth / 2) * 0.8,
        // y: cardHeight / 2,
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        final cardWidth = renderBox.size.width;
        final cardHeight = renderBox.size.height;
        final textSize = (TextPainter(
                text: TextSpan(text: '0', style: widget.textStyle),
                textDirection: TextDirection.ltr)
              ..layout())
            .size;
        messagePosX = (cardWidth / 2) - (cardWidth / 2) * 0.8;
        messagePosY = cardHeight / 2 - textSize.height / 2;
        if (mounted) {
          setState(() {});
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });
        }
        widget.onMessageDrag?.call(messagePosX, messagePosY, null, null);
      } else {
        setState(() {
          messagePosX = widget.messagePosX ?? 0;
          messagePosY = widget.messagePosY ?? 0;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 343.w,
        maxHeight: 213.h,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) => ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              fit: StackFit.expand,
              children: [
                GiftCard(
                  frontBackgroundImage: widget.backgroundImage,
                  frontBackgroundImageFit: widget.foregroundImageFit ?? BoxFit.fill,
                  frontForegroundImage: widget.foregroundImage,
                  backBackgroundImage: widget.backgroundImage,
                  backForegroundImageFit: widget.foregroundImageFit ?? BoxFit.fitHeight,
                  color: widget.color ?? Colors.grey.shade200,
                  showOnly: widget.showOnly,
                  aspectRatio: 1,
                ),
                if (widget.showOnly == CardSide.back && widget.message != null)
                  Positioned(
                    left: messagePosX,
                    top: messagePosY,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanUpdate: (details) {
                        if (widget.locked) return;

                        if (dragIsOn == false) {
                          dragIsOn = true;
                          // if (widget.centerText) {
                          //   messagePosX = (constraints.maxWidth * 0.5) - (constraints.maxWidth * 0.4);
                          //   messagePosY = (constraints.maxHeight * 0.5) - (constraints.maxHeight * 0.3);
                          // } else {
                          //   messagePosX = widget.messagePosX ?? 0;
                          //   messagePosY = widget.messagePosY ?? 0;
                          // }
                        }

                        if (mounted) {
                          setState(() {
                            messagePosX += details.delta.dx;
                            messagePosY += details.delta.dy;
                          });
                          if (widget.onMessageDrag != null) {
                            widget.onMessageDrag!(messagePosX, messagePosY,
                                constraints.maxHeight, constraints.maxWidth);
                          }
                        }
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.8,
                            child: Text(
                              widget.message!,
                              textAlign: TextAlign.center,
                              style: widget.textStyle ??
                                  TextStyle(
                                    color: (widget.color?.computeLuminance() ??
                                                0) >
                                            0.5
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 20,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (widget.showOnly == CardSide.front && widget.layers != null)
                  for (final layer in widget.layers!)
                    LayerWidget(
                      layer: layer,
                      onDelete: () {
                        if (layer.locked || widget.onDelete == null) return;
                        widget.layers?.remove(layer);
                        if (mounted) setState(() {});
                        widget.onDelete!(layer);
                      },
                      onLayerSelected: (isSelected) {
                        widget.layers?.forEach((e) {
                          if (e != layer && e.isSelected.value) {
                            e.isSelected.value = false;
                          }
                        });
                      },
                    ),
                if (widget.showOnly == CardSide.front &&
                    widget.brandImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: BrandImage(
                          logoImage: widget.brandImage!,
                          fit: BoxFit.cover,
                          margin: EdgeInsets.zero,
                          size: constraints.maxWidth * 0.125,
                          // size: MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
                          //   ? MediaQuery.of(context).size.width > 600 ? 70 : 60
                          //   : MediaQuery.of(context).size.width > 600 ? 60 : 50,
                        ),
                      ),
                    ),
                  ),
                if (widget.showOnly == CardSide.back && widget.price != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '${widget.price} ${widget.currency}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: widget.textStyle?.color ?? Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                if (widget.showOnly == CardSide.back)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                          width: constraints.maxWidth < 360 ? 60 : 90,
                          // height: MediaQuery.of(context).size.width > 600
                          //     ? 34.8
                          //     : 30,
                        )),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
