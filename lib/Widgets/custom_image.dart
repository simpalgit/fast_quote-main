import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.path,
    this.fit = BoxFit.contain,
    this.height,
    this.width,
    this.color,
    this.isFile = false,
  });
  final String? path;
  final BoxFit fit;
  final double? height, width;
  final Color? color;
  final bool isFile;

  @override
  Widget build(BuildContext context) {
    final imagePath = path ??
        'https://www.ncenet.com/wp-content/uploads/2020/04/No-image-found.jpg';

    if (isFile) {
      return Image.file(
        File(imagePath),
        fit: fit,
        color: color,
        height: height,
        width: width,
      );
    }

    if (imagePath.endsWith('.svg')) {
      return SizedBox(
        height: height,
        width: width,
        child: SvgPicture.asset(imagePath,
            fit: fit,
            height: height,
            width: width,
            colorFilter: ColorFilter.mode(color!, BlendMode.srcIn)),
      );
    }
    if (imagePath.startsWith('http') ||
        imagePath.startsWith('https') ||
        imagePath.startsWith('www.')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: fit,
        color: color,
        height: height,
        width: width,
        // placeholder: (context, url) => const CircularProgressIndicator(),
        // progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
        //   width: 50,
        //   height: 50,
        //   child: Stack(
        //     alignment: Alignment.center,
        //     children: [
        //       Image.asset(
        //         // you can replace this with Image.asset
        //         'assets/images/app_logo.png',
        //         fit: BoxFit.cover,
        //         height: 30,
        //         width: 30,
        //       ),
        //       // you can replace
        //       CircularProgressIndicator(
        //         value: downloadProgress.progress,
        //         valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
        //         strokeWidth: 2,
        //       ),
        //     ],
        //   ),
        // ),
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
          width: 25,
          height: 25,
          // child: CircularProgressIndicator(
          //   value: downloadProgress.progress,
          //   valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
          //   strokeWidth: 2,
          // ),
          child: Shimmer.fromColors(
            baseColor: Colors.black12,
            highlightColor: Colors.white,
            enabled: true,
            child: Container(
              width: 25,
              height: 25,
              decoration:
                  const BoxDecoration(color: kWhite, shape: BoxShape.circle),
            ),
          ),
        ),

        errorWidget: (context, url, error) =>
            Image.asset("assets/images/no_image.jpeg"),
      );
    }
    return Image.asset(
      imagePath,
      fit: fit,
      color: color,
      height: height,
      width: width,
    );
  }
}
