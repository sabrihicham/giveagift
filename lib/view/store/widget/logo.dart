import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
    required this.url,
    required this.size,
    required this.fit,
  });

  final String url;
  final double size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
     return SizedBox(
      height: size,
      width: size,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        height: size,
        width: size,
        placeholder: (context, url) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300]!,
                  borderRadius: BorderRadius.circular(100)),
            ),
          );
        },
        errorWidget: (context, error, stackTrace) {
          return const Image(
            image: AssetImage("assets/image_not_found.png"),
          );
        },
      ),
    );
  }
}