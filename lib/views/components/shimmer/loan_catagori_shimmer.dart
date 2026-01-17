import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:finovelapp/views/components/shimmer/custom_shimmer.dart';

import '../../../../../../core/utils/dimensions.dart';
import '../../../../../../core/utils/my_color.dart';

class LoanchipShimmer extends StatelessWidget {
  const LoanchipShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 10,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                border: Border.all(color: MyColor.borderColor, width: 1),
                color: MyColor.colorWhite),
            child: Shimmer.fromColors(
              baseColor: MyColor.shimmerBaseColor,
              highlightColor: MyColor.borderColor,
              child: Container(
                margin: const EdgeInsets.all(2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: const MyShimmerEffectUI.rectangular(
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          );
        });
  }
}
