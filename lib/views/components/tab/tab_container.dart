import 'package:flutter/material.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/util.dart';
import 'tab_widget.dart';

class TabContainer extends StatelessWidget {
  final String firstText;
  final String secondText;
  final VoidCallback firstTabPress;
  final VoidCallback secondTabPress;
  final bool isFirstSelected;

  const TabContainer({
    super.key,
    this.isFirstSelected = true,
    required this.secondText,
    required this.firstTabPress,
    required this.secondTabPress,
    required this.firstText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
          horizontal: Dimensions.space7, vertical: Dimensions.space5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.space30),
          color: MyColor.colorWhite,
          boxShadow: MyUtil.getBottomSheetShadow()),
      child: Row(
        children: [
          Expanded(
              child: PlanTabBar(
                  text: firstText,
                  isActive: isFirstSelected,
                  press: firstTabPress)),
          Expanded(
              child: PlanTabBar(
                  text: secondText,
                  isActive: !isFirstSelected,
                  press: secondTabPress)),
        ],
      ),
    );
  }
}
