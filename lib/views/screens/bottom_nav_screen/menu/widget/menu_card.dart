import 'package:flutter/material.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';

class MenuCard extends StatelessWidget {
  final Widget child;
  const MenuCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(Dimensions.space15),
      decoration: BoxDecoration(
          color: MyColor.getCardBg(),
          borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
      child: child,
    );
  }
}
