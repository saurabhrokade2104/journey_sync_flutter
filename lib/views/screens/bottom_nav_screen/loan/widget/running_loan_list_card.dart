import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/views/components/column/card_column.dart';
import 'package:finovelapp/views/components/divider/custom_divider.dart';

class RunningLoanListCard extends StatelessWidget {
  final String planName;
  final String status;
  final String amount, installMentDate;
  final String perInstallMent;
  final VoidCallback press;
  final String currency, currencySymbol;
  final Color statusColor;

  const RunningLoanListCard(
      {super.key,
      required this.planName,
      required this.status,
      required this.amount,
      required this.installMentDate,
      required this.perInstallMent,
      required this.press,
      required this.statusColor,
      required this.currency,
      required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding:  const EdgeInsets.all(Dimensions.space15),
        decoration: BoxDecoration(
            color: MyColor.colorWhite,
            border:Border.all(color: MyColor.borderColor),
            borderRadius: BorderRadius.circular(Dimensions.defaultBorderRadius),
           ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardColumn(
                  header: planName.capitalizeFirst??'',
                  body: '',
                  isOnlyHeader: true,
                  headerTextDecoration: interSemiBoldDefault.copyWith(
                    color: MyColor.getGreyText1(),
                  ),
                ),
                CardColumn(
                  header: MyStrings.installmentDate,
                  body: installMentDate,
                  alignmentEnd: true,
                  // isDate: true,
                ),
              ],
            ),
            const CustomDivider(space: Dimensions.space12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardColumn(
                  header: MyStrings.perInstallment,
                  body: '$currencySymbol$perInstallMent',
                  headerTextDecoration: interSemiBoldDefault.copyWith(
                      color: MyColor.getGreyText()),
                ),
                CardColumn(
                  header: MyStrings.amount,
                  body: '$currencySymbol$amount',
                  alignmentEnd: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
