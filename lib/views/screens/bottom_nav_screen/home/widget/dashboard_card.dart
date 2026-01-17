import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_icons.dart';
import 'package:finovelapp/core/utils/my_strings.dart';

import 'package:finovelapp/data/controller/home/home_controller.dart';
import 'package:finovelapp/views/components/card/card_bg.dart';
import 'package:finovelapp/views/components/result/latest_result_list_item.dart';

import '../../../../../core/utils/style.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return RadiusCardShape(
      padding: Dimensions.space10,
      cardRadius: 4,
      showBorder: true,
      widget: GetBuilder<HomeController>(builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              MyStrings.loanSummary.tr,
              style: interSemiBoldDefault,
            ),
            const SizedBox(
              height: 12,
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: LatestResultListItem(
                    bgColor: MyColor.card3,
                    text: MyStrings.totalLoan.tr,
                    imgpath: MyIcons.runningIcon,
                    icon: Icons.clear,
                    quantity: controller.runningLoan,
                  )),
                  const SizedBox(
                    width: Dimensions.space10,
                  ),
                  Expanded(
                    child: LatestResultListItem(
                      bgColor: Colors.orange,
                      text: MyStrings.pendingLoan.tr,
                      imgpath: MyIcons.pendingIcon,
                      icon: Icons.pending,
                      quantity: controller.pendingLoan,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
        MyStrings.nextInstallment.tr,
        style: interSemiBoldDefault,
        ),
            const SizedBox(
              height: 12,
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: LatestResultListItem(
                      bgColor: MyColor.card4,
                      text: MyStrings.installmentAmt.tr,
                      imgpath: MyIcons.nextInstallment,
                      icon: Icons.next_plan_outlined,
                      quantity:
                      '${controller.nextInstallmentAmount} ${controller.currency}',
                      /* quantity: controller.nextInstallmentDate,*/
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: LatestResultListItem(
                      bgColor: MyColor.card1,
                      text: MyStrings.installmentDate.tr,
                      imgpath: MyIcons.date,
                      icon: Icons.run_circle_outlined,
                      quantity: controller.nextInstallmentDate,
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 12,
            // ),
            // LatestResultListItem(
            //   bgColor: MyColor.card3,
            //   text: MyStrings.installmentDate.tr,
            //   imgpath: '',
            //   icon: Icons.alarm,
            //   // subtitle: controller.nextInstallmentDate,
            //   quantity: controller.nextInstallmentDate.toUpperCase(),
            //   // "${controller.nextInstallmentAmount} ${controller.currency}",
            // ),
          ],
        );
      }),
    );
  }
}
