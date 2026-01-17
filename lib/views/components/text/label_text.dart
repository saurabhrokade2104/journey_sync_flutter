import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/views/components/row_item/form_row.dart';

class LabelText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final bool required;

  const LabelText(
      {super.key, required this.text, this.textAlign, this.required = false});

  @override
  Widget build(BuildContext context) {
    return required
        ? FormRow(label: text.tr, isRequired: true)
        : Text(
            text.tr,
            textAlign: textAlign,
            style: interRegularDefault.copyWith(
                color: MyColor.getLabelTextColor()),
          );
  }
}
