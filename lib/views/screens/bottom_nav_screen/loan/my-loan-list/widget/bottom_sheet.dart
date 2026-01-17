import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/date_converter.dart';
import 'package:finovelapp/core/helper/string_format_helper.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/data/controller/loan/my_loan_controller.dart';
import 'package:finovelapp/views/components/bottom_sheet/custom_bottom_sheet.dart';
import 'package:finovelapp/views/components/buttons/rounded_button.dart';
import 'package:finovelapp/views/components/column/bottom_sheet_column.dart';
import 'package:finovelapp/views/components/row_item/bottom_sheet_top_row.dart';
import 'package:finovelapp/views/components/widget-divider/widget_divider.dart';

class LoanListBottomSheet {
  void bottomSheet(BuildContext context, int index) {
    CustomBottomSheet(
        child: GetBuilder<MyLoanController>(
            builder: (controller) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BottomSheetTopRow(header: MyStrings.loanInformation),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 1,
                            child: BottomSheetColumn(
                              header: MyStrings.amount,
                              body:
                                  '${controller.currencySymbol}${Converter.formatNumber(controller.myLoanList[index].amount ?? '')}',
                            )),
                        Expanded(
                            flex: 1,
                            child: BottomSheetColumn(
                              alignmentEnd: true,
                              header: MyStrings.needToPay,
                              body:
                                  '${controller.currencySymbol}${controller.getNeedToPayAmount(index)}',
                            )),
                      ],
                    ),
                    const SizedBox(height: Dimensions.space20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 1,
                            child: BottomSheetColumn(
                              header: MyStrings.installmentAmount,
                              body:
                                  "${controller.currencySymbol}${Converter.formatNumber(controller.myLoanList[index].perInstallment ?? '')}",
                            )),
                        Expanded(
                            flex: 1,
                            child: BottomSheetColumn(
                              alignmentEnd: true,
                              header: MyStrings.installmentInterval,
                              body:
                                  '${controller.myLoanList[index].installmentInterval ?? '0'} ${MyStrings.days.tr}',
                            )),
                      ],
                    ),
                    const SizedBox(height: Dimensions.space20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 1,
                            child: BottomSheetColumn(
                                header: MyStrings.totalInstallment,
                                body: controller
                                        .myLoanList[index].totalInstallment ??
                                    '0')),
                        Expanded(
                            flex: 1,
                            child: BottomSheetColumn(
                              alignmentEnd: true,
                              header: MyStrings.givenInstallment,
                              body: controller
                                      .myLoanList[index].givenInstallment ??
                                  '0',
                            )),
                      ],
                    ),
                    const SizedBox(height: Dimensions.space20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 1,
                            child: BottomSheetColumn(
                              header: MyStrings.nextInstallment,
                              body: DateConverter.isoStringToLocalDateOnly(
                                  controller.myLoanList[index].nextInstallment
                                          ?.installmentDate ??
                                      ''),
                            )),
                        Expanded(
                            flex: 1,
                            child: BottomSheetColumn(
                              alignmentEnd: true,
                              header: MyStrings.paidAmount,
                              body:
                                  "${controller.currencySymbol}${Converter.mul(controller.myLoanList[index].givenInstallment ?? '0', controller.myLoanList[index].perInstallment ?? '0')}",
                            )),
                      ],
                    ),
                    const WidgetDivider(),
                    RoundedButton(
                      text: MyStrings.installments,
                      color: controller.myLoanList[index].status == "1"
                          ? MyColor.greenSuccessColor
                          : MyColor.getGreyText(),
                      press: () {
                        if (controller.myLoanList[index].status == "1") {
                          Get.toNamed(
                            RouteHelper.loanInstallmentLogScreen,
                            arguments:
                                controller.myLoanList[index].id.toString(),
                          );
                        }
                      },
                    ),
                  ],
                ))).customBottomSheet(context);
  }
}
