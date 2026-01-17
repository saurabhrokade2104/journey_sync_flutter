// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/util.dart';

class TopButtonCard extends StatelessWidget {
  Widget child;
  TopButtonCard({super.key, required this.child});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.space5),
      margin: const EdgeInsets.all(Dimensions.space5),
      decoration: BoxDecoration(
        color: MyColor.imageContainerBg,
        borderRadius: BorderRadius.circular(Dimensions.defaultBorderRadius),
        boxShadow: MyUtil.getCardShadow(),
      ),
      child: child,
    );
  }
}
