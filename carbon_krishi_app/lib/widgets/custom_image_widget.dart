import 'package:flutter/material.dart';

class CustomImageWidget extends StatelessWidget {
  final String? imagePath;
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? semanticLabel;

  const CustomImageWidget({
    super.key,
    this.imagePath,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.semanticLabel,
  }) : assert(
         imagePath != null || imageUrl != null,
         'Either imagePath or imageUrl must be provided',
       );

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (imageUrl != null) {
      image = Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: semanticLabel,
      );
    } else {
      image = Image.asset(
        imagePath!,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: semanticLabel,
      );
    }

    return borderRadius != null
        ? ClipRRect(borderRadius: borderRadius!, child: image)
        : image;
  }
}
