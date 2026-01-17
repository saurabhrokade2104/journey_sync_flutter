import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/style.dart';

class BottomSheetLabelText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const BottomSheetLabelText({super.key, required this.text, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr,
      textAlign: textAlign,
      style: interRegularLarge.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
