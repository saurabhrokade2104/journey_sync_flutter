import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/style.dart';

class BottomSection extends StatelessWidget {
  const BottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(MyStrings.alreadyAccount.tr, style: interRegularDefault),
        TextButton(
          onPressed: () {
            Get.offAndToNamed(RouteHelper.loginScreen);
          },
          child: Text(
            MyStrings.signInNow.tr,
            style: interRegularDefault.copyWith(
                color: MyColor.primaryColor,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }
}
