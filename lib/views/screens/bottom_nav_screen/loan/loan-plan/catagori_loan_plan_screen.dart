import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/string_format_helper.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/data/controller/loan/loan_plan_controller.dart';
import 'package:finovelapp/views/components/custom_loader.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/loan-plan/widget/apply_loan_bottom_sheet.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/widget/loan_card.dart';

class LoanPlanScreen extends StatefulWidget {
  const LoanPlanScreen({super.key});

  @override
  State<LoanPlanScreen> createState() => _LoanPlanScreenState();
}

class _LoanPlanScreenState extends State<LoanPlanScreen> {
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
              itemCount: loanPlancontroller.selectcatagori?.plans?.length ?? 0,
              separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
              itemBuilder: (context, index) => LoanCard(
                index: index,
                cardStatusTitle: loanPlancontroller.selectcatagori?.plans![index].name?.tr ?? '',
                percentRate: loanPlancontroller.selectcatagori?.plans![index].perInstallment ?? '0',
                takeMin: '${loanPlancontroller.currencySymbol}${Converter.formatNumber(loanPlancontroller.selectcatagori?.plans![index].minimumAmount ?? '0')}',
                takeMax: ' ${loanPlancontroller.currencySymbol}${Converter.formatNumber(loanPlancontroller.selectcatagori?.plans![index].maximumAmount ?? '0')}',
                perInstallment: '${Converter.roundDoubleAndRemoveTrailingZero(loanPlancontroller.selectcatagori?.plans![index].perInstallment ?? '0')}%',
                installmentInterval: loanPlancontroller.selectcatagori?.plans![index].installmentInterval ?? '',
                totalInstallment: loanPlancontroller.selectcatagori?.plans![index].totalInstallment ?? '',
                onPressed: () {
                  ApplyLoanBottomSheet().bottomSheet(context, index);
                }),
            );
    });
  }
}
