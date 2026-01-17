

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/data/controller/loan/loan_plan_controller.dart';
import 'package:finovelapp/data/model/loan/loan_plan_response_model.dart';

class LoanCategoryChip extends StatelessWidget {

  final CategoryPlans categoryPlans;
  const LoanCategoryChip({
    super.key,
    required this.categoryPlans,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoanPlanController>(builder: (planController) {
      return GestureDetector(
        onTap: () {
          planController.selectCatagori(categoryPlans);
        },
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: planController.selectedCatId.toString() ==
                        categoryPlans.id.toString()
                    ? MyColor.primaryColor
                    : MyColor.borderColor,
                width: 1),
            color: planController.selectedCatId.toString() ==
                    categoryPlans.id.toString()
                ? MyColor.primaryColor
                : MyColor.colorWhite,
          ),
          child: Text(
            categoryPlans.name.toString(),
            style: interLightMediumLarge.copyWith(
              color: planController.selectedCatId.toString() ==
                      categoryPlans.id.toString()
                  ? MyColor.textColor
                  : MyColor.colorBlack,
            ),
          ),
        ),
      );
    });
  }
}
