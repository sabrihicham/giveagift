import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giveagift/core/extensions/web_images.dart';
import 'package:giveagift/view/cart/data/model/card.dart';

abstract class LayerBase {
  LayerBase({
    this.width,
    this.height,
  });

  double? width;
  double? height;

  Widget build(BuildContext context);
}

class Layer extends LayerBase {
  double scale;
  double rotation;
  Position position;
  late double _baseScaleFactor;
  late double _baseAngleFactor;
  Function()? _onDelete;
  bool locked;

  set onDelete(Function()? value) {
    _onDelete = value;
  }

  Layer(
      {super.width,
      super.height,
      this.scale = 1,
      this.rotation = 0,
      this.position = Position.zero,
      this.locked = false}) {
    onScaleStart();
  }

  onScaleStart() {
    _baseScaleFactor = scale;
    _baseAngleFactor = rotation;
  }

  onScaleUpdate(double scaleNew) =>
      scale = (_baseScaleFactor * scaleNew).clamp(0.2, 5);

  onRotateUpdate(double angleNew) => rotation = _baseAngleFactor + angleNew;

  final isSelected = ValueNotifier(false);

  final rebuild = ValueNotifier<int>(0);

  final isDraging = StreamController<bool>.broadcast();

  final containerKey = GlobalKey();

  Offset ray = const Offset(0, 0);

  Offset toCenter(widthA, heightA) {
    if (width == null || height == null) {
      ray = const Offset(0, 0);
      return ray;
    }

    ray = Offset(
      widthA / 2 - width! / 2, 
      heightA / 2 - height! / 2
    );
    return ray;
  }

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        toCenter(constraints.maxWidth, constraints.maxHeight);
        return Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Positioned(
            left: ray.dx + position.x - constraints.maxWidth / 2,
            top: ray.dy + position.y - constraints.maxHeight / 2,
            child: Transform.rotate(
              angle: rotation,
              child: Transform.scale(
                scale: scale,
                child: Stack(
                  children: [
                    Container(
                      key: containerKey,
                      constraints: BoxConstraints(
                        maxWidth: width ?? double.infinity,
                        maxHeight: height ?? double.infinity,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected.value
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: child!,
                    ),
                    if (isSelected.value)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: _onDelete,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: 16 * (5 - scale),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
      },
    );
  }
}

class TextLayer extends Layer {
  CardText text;

  TextLayer({
    required this.text,
    super.width,
    super.height,
  }) : super(
          position: Position(
            x: text.xPosition?.toDouble() ?? 0,
            y: text.yPosition?.toDouble() ?? 0,
          ),
        );

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return super.build(
      context,
      child: Text(
        text.message ?? '',
        style: TextStyle(
          color: text.fontColorAtr,
          fontSize: text.fontSize?.toDouble() ?? 12,
          // fontWeight: ,
        ),
      ),
    );
  }
}

class ShapeLayer extends Layer {
  CardShape cardShape;

  ShapeLayer({
    required this.cardShape,
    super.width,
    super.height,
  }) : super(
          scale: cardShape.scale.toDouble(),
          rotation: cardShape.rotation.toDouble(),
          position: Position(
            x: cardShape.position?.x ?? 0,
            y: cardShape.position?.y ?? 0,
          ),
        );

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return super.build(
      context,
      child: CachedNetworkImage(
        imageUrl: cardShape.shape.image.shapeImage,
        imageBuilder: (context, imageProvider) {
          // Get Image Height
          if (height == null && width == null) {
            final image = Image(image: imageProvider);
            image.image.resolve(const ImageConfiguration()).addListener(
              ImageStreamListener(
                (info, _) {
                  height = info.image.height.toDouble();
                  width = info.image.width.toDouble();
                  // set State from Context
                  rebuild.value++;
                },
              ),
            );
          }
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ),
          );
        },
        fit: BoxFit.fill,
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          color: Colors.red,
          size: 48,
        ),
      ),
    );
  }
}