import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_images.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/data/controller/home/home_controller.dart';
import 'package:finovelapp/views/components/circle_widget/circle_image_button.dart';
import 'package:finovelapp/views/components/image/custom_svg_picture.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/home/widget/balance_animated_app_bar.dart';

class HomeScreenTop extends StatefulWidget {
  const HomeScreenTop({super.key});

  @override
  State<HomeScreenTop> createState() => _HomeScreenTopState();
}

class _HomeScreenTopState extends State<HomeScreenTop> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: MyColor.primaryColor,
        ),
        padding: const EdgeInsets.only(
          left: Dimensions.space15,
          right: Dimensions.space15,
          top: Dimensions.space20,
          bottom: Dimensions.space20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.profileScreen);
                      },
                      child: CircleImageWidget(
                        height: 40,
                        width: 40,
                        isProfile: true,
                        isAsset: true,
                        imagePath: MyImages.defaultAvatar,
                        press: () {},
                      ),
                    ),
                    const SizedBox(width: Dimensions.space10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.username,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: interRegularLarge.copyWith(
                            color: MyColor.colorWhite,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: Dimensions.space5),
                        BalanceAnimationContainer(
                            amount: controller.balance,
                            curSymbol: controller.currencySymbol)

                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.notificationScreen);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: MyColor.colorWhite, shape: BoxShape.circle),
                    child: const CustomSvgPicture(
                        image: MyImages.notificationIcon,
                        color: MyColor.primaryColor,
                        height: 15,
                        width: 15),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
