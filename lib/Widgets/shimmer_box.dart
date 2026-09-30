import 'package:fast_quote/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A convenient widget to create a [Shimmer] box where needed to present a
/// loading state.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: SizedBox(
        width: width,
        height: height,
        child: Shimmer.fromColors(
          baseColor: Colors.black12,
          highlightColor: Colors.white,
          enabled: true,
          child: Container(
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(0),
            ),
          ),
        ),
      ),
    );
  }
}
