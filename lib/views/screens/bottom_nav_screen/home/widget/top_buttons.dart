import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/data/controller/home/home_controller.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/home/widget/top_button_card.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({super.key});

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GetBuilder<HomeController>(builder: (controller) {
      return controller.moduleList.isEmpty
          ? const SizedBox.expand()
          : Positioned(
              top: 200,
              right: 15,
              left: 15,
              child: Container(
                width: width,
                height: 100,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: MyColor.colorWhite,
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.defaultBorderRadius),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: TopButtonCard(child: controller.moduleList[0])),
                    Expanded(
                        child: TopButtonCard(child: controller.moduleList[1])),
                    Expanded(
                        child: TopButtonCard(child: controller.moduleList[2])),
                    Expanded(
                        child: TopButtonCard(child: controller.moduleList[3])),
                  ],
                ),
              ),
            );
    });
  }
}
