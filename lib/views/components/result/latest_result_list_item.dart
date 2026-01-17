import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/views/components/circle_widget/circle_button_with_icon.dart';

class LatestResultListItem extends StatelessWidget {
  final String text;
  final String quantity;
  final String? subtitle;
  final String imgpath;
  final IconData icon;
  final Color bgColor;
  final Color textColor;

  const LatestResultListItem(
      {super.key,
      required this.text,
      required this.quantity,
      required this.icon,
      required this.imgpath,
      this.textColor = MyColor.colorBlack,
      this.subtitle,
      required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.transparent,//bgColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: MyColor.borderColor),
            gradient: LinearGradient(
              colors: [
                bgColor,
                bgColor.withOpacity(.95),
                bgColor.withOpacity(.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              CircleButtonWithIcon(
                press: () {},
                bg: bgColor,
                isIcon: true,
                isAsset: false,
                circleSize: 25,
                imageSize: 20,
                padding: 5,
                borderColor: MyColor.transparentColor,
                isSvg: true,
                iconColor: MyColor.colorWhite,
                imagePath: imgpath,
                iconSize: 20,
                icon: icon,
              ),
              const SizedBox(width: Dimensions.space7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      quantity.isNotEmpty ? quantity.padLeft(2, '0') : quantity,
                      style: interSemiBold.copyWith(fontSize: Dimensions.fontDefault, color: textColor),
                    ),
                    subtitle != null
                        ? const SizedBox(
                            height: 5,
                          )
                        : const SizedBox.shrink(),
                    subtitle != null
                        ? Text(
                            subtitle?.tr ?? "".tr,
                            style: interRegularDefault.copyWith(
                              fontSize: Dimensions.fontSmall,
                              color: MyColor.textColor,
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      text.tr,
                      style: interRegularDefault.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.fontSmall12, color: textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
       /* Positioned(
          right: 5,
          top: 5,
          child: CircleButtonWithIcon(
            press: () {

            },
            bg: bgColor,
            isIcon: true,
            isAsset: false,
            circleSize: 28,
            imageSize: 22,
            padding: 6,
            borderColor: MyColor.transparentColor,
            isSvg: true,
            iconColor: MyColor.colorWhite,
            imagePath: imgpath,
            iconSize: 22,
            icon: icon,
          ),
        ),*/
      ],
    );
  }
}
