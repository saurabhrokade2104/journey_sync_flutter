import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/style.dart';

class PreviewRow extends StatelessWidget {
  final String firstText, secondText;
  final bool showDivider;
  TextStyle? secondTextStyle;

  PreviewRow(
      {super.key,
      required this.firstText,
      required this.secondText,
      this.showDivider = true,
      this.secondTextStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(firstText.tr,
                style: interSemiBold.copyWith(
                    fontSize: Dimensions.fontDefault,
                    color: MyColor.getGreyText())),
            Text(
              secondText.tr,
              style: secondTextStyle ??
                  interSemiBold.copyWith(
                    fontSize: Dimensions.fontSmall12,
                    color: MyColor.getGreyText1(),
                  ),
            )
          ],
        ),
        const SizedBox(height: 15),
        Visibility(
          visible: showDivider,
          child: Divider(
            height: .5,
            color: MyColor.getBorderColor(),
          ),
        ),
        Visibility(
          visible: showDivider,
          child: const SizedBox(height: 15),
        ),
      ],
    );
  }
}
