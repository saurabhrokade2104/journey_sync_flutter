import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/style.dart';

class TitleLabel extends StatelessWidget {
  final String titleLabel;
  const TitleLabel({super.key,required this.titleLabel});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        titleLabel.tr,
        style: interSemiBoldDefault,
      ),
    );
  }
}
