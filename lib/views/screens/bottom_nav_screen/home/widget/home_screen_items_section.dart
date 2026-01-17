import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/date_converter.dart';
import 'package:finovelapp/core/helper/string_format_helper.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/data/controller/home/home_controller.dart';
import 'package:finovelapp/data/controller/loan/loan_plan_controller.dart';
import 'package:finovelapp/views/components/custom_loader.dart';
import 'package:finovelapp/views/components/no_data/no_data_found.dart';
import 'package:finovelapp/views/components/shimmer/myloan_card_shimmer.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/home/widget/all_loan_plans_title.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/home/widget/running_loan_bottom_shet.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/loan-plan/widget/apply_allloan_bottom_sheet.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/widget/loan_card.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/widget/running_loan_list_card.dart';

import '../../../../../core/utils/my_strings.dart';
import '../../../../components/card/card_bg.dart';
import 'dashboard_card.dart';
import 'title_label.dart';

class HomeScreenItemsSection extends StatefulWidget {
  const HomeScreenItemsSection({super.key});

  @override
  State<HomeScreenItemsSection> createState() => _HomeScreenItemsSectionState();
}

class _HomeScreenItemsSectionState extends State<HomeScreenItemsSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => Container(
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          color: MyColor.transparentColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DashboardCard(),
            const SizedBox(height: Dimensions.space12),
            RadiusCardShape(
              padding: Dimensions.space10,
              cardRadius: 4,
              showBorder: true,
              widget: Column(
                children: [
                  controller.runningLoanList.isNotEmpty
                      ?  const TitleLabel(titleLabel: MyStrings.myRunningLoan)
                      : const AllLoanPlanTitle(),
                  const SizedBox(height: Dimensions.space12),
                  controller.isLoading ? const MyLoanCardShimmer()
              : controller.runningLoanList.isNotEmpty
                  ? ListView.separated(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: controller.runningLoanList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
                      itemBuilder: (context, index) {
                        return RunningLoanListCard(
                          currencySymbol: controller.currencySymbol,
                          currency: controller.currency,
                          installMentDate: DateConverter.isoStringToLocalFormattedDateOnly(controller.runningLoanList[index].nextInstallment?.installmentDate.toString() ?? ""),
                          planName: controller.runningLoanList[index].plan?.name.toString().tr ?? '',
                          statusColor: controller.getStatusAndColor(index, isStatus: false),
                          status: controller.getStatusAndColor(index, isStatus: true).toString().tr,
                          amount: Converter.formatNumber(controller.runningLoanList[index].amount.toString()),
                          perInstallMent: Converter.formatNumber(
                            controller.runningLoanList[index].perInstallment.toString(),
                          ),
                          press: () {
                            RunningLoanBottomSheet()
                                .bottomSheet(context, index);
                          },
                        );
                      })
                  : GetBuilder<LoanPlanController>(
                      builder: (loanPlanController) {
                      return loanPlanController.isLoading
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height / 4,
                              child: const Center(child: CustomLoader()),
                            )
                          :
                          loanPlanController.planList.isEmpty?
                              NoDataWidget(topMargin: MediaQuery.of(context).size.height/20,):
                      ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              itemCount: loanPlanController.planList.length,
                              separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
                              itemBuilder: (context, index) => LoanCard(
                                isShowBorder: true,
                                  index: index,
                                  cardStatusTitle: loanPlanController.planList[index].name ?? '',
                                  percentRate: loanPlanController.planList[index].perInstallment ?? '0',
                                  takeMin: '${loanPlanController.currencySymbol}${Converter.formatNumber(loanPlanController.planList[index].minimumAmount ?? '0')}',
                                  takeMax: ' ${loanPlanController.currencySymbol}${Converter.formatNumber(loanPlanController.planList[index].maximumAmount ?? '0')}',
                                  perInstallment: '${Converter.roundDoubleAndRemoveTrailingZero(loanPlanController.planList[index].perInstallment ?? '0')}%',
                                  installmentInterval: loanPlanController.planList[index].installmentInterval ??'',
                                  totalInstallment: loanPlanController.planList[index].totalInstallment ?? '',
                                  onPressed: () {
                                    AllLoanApplyBottomSheet().bottomSheet(context, index);
                                  }),
                            );
                    }),
                const   SizedBox(height: Dimensions.space20)
                ],
              ),
            ),
            const SizedBox(height: Dimensions.space12),
          ],
        ),
      ),
    );
  }
}
