import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/style.dart';

class LatestTransactionCard extends StatelessWidget {
  final String trx, remark;
  final String date;
  final String amount;
  final String postBalance;
  final String currency;
  final VoidCallback onPressed;

  final bool isShowDivider;
  final bool isCredit;
  const LatestTransactionCard({
    super.key,
    required this.onPressed,
    required this.isCredit,
    required this.trx,
    required this.remark,
    required this.date,
    required this.amount,
    required this.postBalance,
    this.isShowDivider = false,
    this.currency = '',
  });

  @override
  Widget build(BuildContext context) {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    return Container(
      margin: const EdgeInsets.symmetric( vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: MyColor.colorWhite,
        borderRadius: BorderRadius.circular(8),
        // boxShadow: MyUtil.getCardShadow(),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 35,
                width: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCredit
                      ? MyColor.greenSuccessColor.withOpacity(0.17)
                      : MyColor.colorRed.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                  color:
                  isCredit ? MyColor.greenSuccessColor : MyColor.colorRed,
                  size: 20,
                ),
              ),
              const SizedBox(width: Dimensions.space12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    capitalize(remark.replaceAll("_", " ")).tr,
                    style: interBoldDefault.copyWith(
                      color: MyColor.primaryColor,
                      // fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: Dimensions.space5),
                  Text(
                    "#$trx",
                    style: interRegularDefault.copyWith(
                      color: MyColor.getBodyTextColor(),
                      // fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: Dimensions.space5),
                  SizedBox(
                    width: 150,
                    child: Text(
                      date,
                      style: interRegularSmall.copyWith(color: MyColor.getTextColor().withOpacity(0.5)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  )
                ],
              )
            ],
          )),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$currency$amount',
                    overflow: TextOverflow.ellipsis,
                    style: interRegularDefault.copyWith(
                      color: MyColor.primaryColor,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(
                  height: Dimensions.space5,
                ),
                Text(
                    '${MyStrings.balance.tr}: $currency$postBalance',
                    overflow: TextOverflow.ellipsis,
                    style: interRegularDefault.copyWith(
                      color: MyColor.colorGrey2,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
