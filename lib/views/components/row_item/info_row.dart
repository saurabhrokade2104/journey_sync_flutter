import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/style.dart';

class InfoRow extends StatelessWidget {
  final String text;
  final double iconSize;
  const InfoRow({
    super.key,
    required this.text,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: iconSize,
          color: MyColor.getGreyText(),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(text.tr,
            style: interSemiBold.copyWith(
              fontSize: Dimensions.fontDefault,
              color: MyColor.getGreyText(),
            )),
      ],
    );
  }
}
