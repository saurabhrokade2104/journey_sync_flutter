import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/style.dart';

import '../../../core/utils/dimensions.dart';

class LightText extends StatelessWidget {
  const LightText(
      {super.key,
      this.isAlignCenter = false,
      required this.text,
      this.size = Dimensions.fontLarge,
      this.space = 8,
      this.bottom = 8});
  final String text;
  final double size;
  final double space;
  final double bottom;
  final bool isAlignCenter;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr,
      style: interRegularDefault.copyWith(
          fontSize: size, color: MyColor.bodyTextColor),
      textAlign: isAlignCenter ? TextAlign.center : TextAlign.start,
    );
  }
}
