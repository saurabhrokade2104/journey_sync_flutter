import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/style.dart';

class AllLoanPlanTitle extends StatelessWidget {
  const AllLoanPlanTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        MyStrings.loanPlan.tr,
        style: interSemiBoldDefault,
      ),
    );
  }
}
