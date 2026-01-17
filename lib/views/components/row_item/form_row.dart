import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/style.dart';

class FormRow extends StatelessWidget {
  final String label;
  final bool isRequired;

  const FormRow({super.key, required this.label, required this.isRequired});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label.tr,
          style:
              interRegularDefault.copyWith(color: MyColor.getLabelTextColor()),
        ),
        Text(
          isRequired ? ' *' : '',
          style: interBoldDefault.copyWith(color: MyColor.red),
        )
      ],
    );
  }
}
