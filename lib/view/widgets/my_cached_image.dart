import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gigglio/model/utils/app_constants.dart';
import 'package:gigglio/model/utils/image_resources.dart';
import 'package:gigglio/view/widgets/shimmer_widget.dart';

class MyCachedImage extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool isAvatar;
  final bool loading;
  final double? avatarRadius;
  final BorderRadiusGeometry? borderRadius;
  final Color? foregroundColor;
  const MyCachedImage(this.image,
      {super.key,
      this.isAvatar = false,
      this.avatarRadius,
      this.height,
      this.width,
      this.foregroundColor,
      this.borderRadius,
      this.fit})
      : loading = false;

  const MyCachedImage.error(
      {super.key,
      this.isAvatar = false,
      this.avatarRadius,
      this.height,
      this.width,
      this.foregroundColor,
      this.borderRadius,
      this.fit})
      : image = null,
        loading = false;
  const MyCachedImage.loading(
      {super.key,
      this.isAvatar = false,
      this.avatarRadius,
      this.height,
      this.width,
      this.foregroundColor,
      this.borderRadius,
      this.fit})
      : image = null,
        loading = true;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      if (isAvatar) {
        return CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: avatarRadius,
            child: Shimmer.avatar);
      }

      return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: SizedBox(
            height: height,
            width: width,
            child: Shimmer.box,
          ));
    }

    if (image == null) {
      final image = AssetImage(ImageRes.userThumbnail);
      if (isAvatar) {
        return CircleAvatar(backgroundImage: image, radius: avatarRadius);
      }
      return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Image(
            image: image,
            fit: fit ?? BoxFit.cover,
            height: height,
            width: width,
          ));
    }

    return CachedNetworkImage(
        imageUrl: image!,
        fit: fit ?? BoxFit.cover,
        height: height,
        width: width,
        imageBuilder: (context, imageProvider) {
          if (isAvatar) {
            return CircleAvatar(
                backgroundImage: imageProvider, radius: avatarRadius);
          }

          return ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: Image(
                image: imageProvider,
                height: height,
                width: width,
                fit: fit ?? BoxFit.cover,
              ));
        },
        placeholder: (context, url) {
          if (isAvatar) {
            return CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: avatarRadius,
                child: Shimmer.avatar);
          }

          return ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: SizedBox(
                height: height,
                width: width,
                child: Shimmer.box,
              ));
        },
        errorWidget: (context, url, error) {
          logPrint('CachedImage: $error');

          final image = AssetImage(ImageRes.userThumbnail);

          if (isAvatar) {
            return CircleAvatar(backgroundImage: image, radius: avatarRadius);
          }
          return ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: Image(
                image: image,
                fit: fit ?? BoxFit.cover,
                height: height,
                width: width,
              ));
        });
  }
}
