import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_strings.dart';

import 'package:finovelapp/data/controller/home/home_controller.dart';
import 'package:finovelapp/views/components/card/card_bg.dart';

import '../../../../../core/utils/style.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return RadiusCardShape(
      padding: Dimensions.space10,
      cardRadius: 4,
      showBorder: true,
      widget: GetBuilder<HomeController>(builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              MyStrings.availableBalance.tr,
              style: interSemiBoldDefault,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              controller.balance,
              style: interSemiBoldDefault.copyWith(fontSize: Dimensions.fontLarge),
            ),
          ],
        );
      }),
    );
  }
}
