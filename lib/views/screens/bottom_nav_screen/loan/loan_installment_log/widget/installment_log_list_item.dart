import 'package:flutter/material.dart';
import 'package:finovelapp/core/helper/date_converter.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/views/components/column/label_column.dart';

class InstallmentLogItem extends StatelessWidget {
  final String serialNumber;
  final String installmentDate;
  final String giveOnDate;
  final String delay;

  const InstallmentLogItem(
      {super.key,
      required this.serialNumber,
      required this.installmentDate,
      required this.giveOnDate,
      required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.space12, vertical: Dimensions.space15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
          color: MyColor.getCardBg()),
      child: Row(
        children: [
          Container(
            height: 35,
            width: 35,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(Dimensions.space5),
            decoration: const BoxDecoration(
                color: MyColor.containerBgColor, shape: BoxShape.circle),
            child: Text(serialNumber,
                textAlign: TextAlign.center, style: interRegularSmall),
          ),
          const SizedBox(width: Dimensions.space12),
          Expanded(
              flex: 5,
              child: LabelColumn(
                isSmallFont: true,
                header: MyStrings.installmentDate,
                body: DateConverter.isoStringToLocalDateOnly(installmentDate),
              )),
          Expanded(
              flex: 3,
              child: LabelColumn(
                isSmallFont: true,
                header: MyStrings.givenOn,
                body: DateConverter.isoStringToLocalDateOnly(giveOnDate,
                    errorResult: MyStrings.notYet),
              )),
          Expanded(
              flex: 2,
              child: LabelColumn(
                isSmallFont: true,
                alignmentEnd: true,
                header: MyStrings.delay,
                body: delay,
              )),
        ],
      ),
    );
  }
}
