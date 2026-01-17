import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_images.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/style.dart';

class NoDataWidget extends StatelessWidget {
  final double topMargin;
  final double bottomMargin;
  final String title;
  final double imageHeight;

  const NoDataWidget(
      {super.key,
      this.topMargin = 0,
      this.title = MyStrings.noDataFound,
      this.imageHeight = 150,
      this.bottomMargin = 0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: topMargin,
          ),
          SvgPicture.asset(MyImages.noDataImage,
              height: 100, width: 100, color: MyColor.getUnselectedIconColor()),
          const SizedBox(height: Dimensions.space20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: interRegularDefault.copyWith(
                color: MyColor.getTextColor().withOpacity(.6),
                fontSize: Dimensions.fontDefault),
          )
        ],
      ),
    );
  }
}
