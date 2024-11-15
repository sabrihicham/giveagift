import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BrandImage extends StatelessWidget {
  const BrandImage({
    super.key,
    required this.logoImage,
    this.size = 50,
    this.origilanSize = false,
    this.backgroundColor,
    this.margin = const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    this.fit,
    this.onTap,
    this.clipBehavior = Clip.antiAliasWithSaveLayer,
  });

  final String logoImage;
  final double? size;
  final bool? origilanSize;
  final Color? backgroundColor;
  final EdgeInsets margin;
  final BoxFit? fit;
  final Function()? onTap;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: clipBehavior,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: onTap,
        child: CachedNetworkImage(
          imageUrl: logoImage,
          imageBuilder: (context, imageProvider) => Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ),
            ),
          ),
          width: origilanSize! ? null : size,
          height: origilanSize! ? null : size,
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
      ),
    );
  }
}
