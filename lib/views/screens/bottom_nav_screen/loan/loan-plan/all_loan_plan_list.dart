
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/string_format_helper.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/data/controller/loan/loan_plan_controller.dart';
import 'package:finovelapp/views/components/custom_loader.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/loan-plan/widget/apply_allloan_bottom_sheet.dart';

import 'package:finovelapp/views/screens/bottom_nav_screen/loan/widget/loan_card.dart';

class AllLoanPlanList extends StatefulWidget {
  const AllLoanPlanList({super.key});

  @override
  State<AllLoanPlanList> createState() => _AllLoanPlanListState();
}

class _AllLoanPlanListState extends State<AllLoanPlanList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoanPlanController>(builder: (loanPlancontroller) {
      return loanPlancontroller.isLoading
          ? const CustomLoader()
          : ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: loanPlancontroller.planList.length,
              separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
              itemBuilder: (context, index) => LoanCard(
                  index: index,
                  cardStatusTitle: loanPlancontroller.planList[index].name.toString().tr ?? '',
                  percentRate: loanPlancontroller.planList[index].perInstallment ?? '0',
                  takeMin: '${loanPlancontroller.currencySymbol}${Converter.formatNumber(loanPlancontroller.planList[index].minimumAmount ?? '0')}',
                  takeMax: ' ${loanPlancontroller.currencySymbol}${Converter.formatNumber(loanPlancontroller.planList[index].maximumAmount ?? '0')}',
                  perInstallment: '${Converter.roundDoubleAndRemoveTrailingZero(loanPlancontroller.planList[index].perInstallment ?? '0')}%',
                  installmentInterval: loanPlancontroller.planList[index].installmentInterval ?? '',
                  totalInstallment: loanPlancontroller.planList[index].totalInstallment ?? '',
                  onPressed: () {
                    AllLoanApplyBottomSheet().bottomSheet(context, index);
                  }),
            );
    });
  }
}
