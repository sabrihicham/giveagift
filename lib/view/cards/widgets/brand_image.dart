import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BrandImage extends StatelessWidget {
  const BrandImage({
    super.key,
    required this.logoImage,
    this.size = 50,
    this.margin = const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    this.fit,
  });

  final String logoImage;
  final double? size;
  final EdgeInsets margin;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: margin,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: CachedNetworkImage(
        imageUrl: logoImage,
        width: size,
        height: size,
        fit: fit,
        errorWidget: (context, url, error) {
          return const Center(
            child: Icon(
              Icons.storefront_outlined,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}