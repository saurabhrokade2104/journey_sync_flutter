import 'package:flutter/material.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/style.dart';

class ChipWidget extends StatelessWidget {
  const ChipWidget({super.key, required this.name, required this.hasError});

  final String name;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Chip(
            elevation: 0,
            shape: StadiumBorder(
                side: BorderSide(
                    color: hasError ? Colors.red : Colors.green, width: 1)),
            avatar: Icon(
              hasError ? Icons.cancel : Icons.check_circle,
              color: hasError ? Colors.red : Colors.green,
              size: 15,
            ),
            label: Text(
              name,
              style: interRegularDefault.copyWith(
                fontSize: Dimensions.fontExtraSmall,
                color: hasError ? Colors.red : Colors.green,
              ),
            ),
            backgroundColor: MyColor.getCardBg()),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
