import 'package:flutter/material.dart';
import 'package:finovelapp/core/utils/my_color.dart';

class CustomDivider extends StatelessWidget {
  final double space;
  final Color? borderColor;
  const CustomDivider({super.key, this.space = 10, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: space),
        Divider(
            color: borderColor ?? MyColor.getBorderColor(),
            height: 0.5,
            thickness: .5),
        SizedBox(height: space),
      ],
    );
  }
}
