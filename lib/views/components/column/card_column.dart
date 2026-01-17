import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/style.dart';

class CardColumn extends StatelessWidget {
  final String header;
  final String body;
  final bool alignmentEnd;
  final bool isDate;
  final Color? textColor;
  TextStyle? headerTextDecoration;
  final bool isOnlyHeader;
  bool? isonlyBody;

  CardColumn(
      {super.key,
      this.alignmentEnd = false,
      required this.header,
      this.isDate = false,
      this.textColor,
      this.headerTextDecoration,
      required this.body,
      this.isOnlyHeader = false,
      this.isonlyBody = false});

  @override
  Widget build(BuildContext context) {
    return isOnlyHeader
        ? Column(
            crossAxisAlignment: alignmentEnd
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                header.tr,
                style: headerTextDecoration ??
                    interRegularSmall.copyWith(
                        color: MyColor.getGreyText(),
                        fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: Dimensions.space5,
              ),
            ],
          )
        : Column(
            crossAxisAlignment: alignmentEnd
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                header.tr,
                style: headerTextDecoration ??
                    interRegularSmall.copyWith(
                        color: MyColor.getGreyText(),
                        fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: Dimensions.space5,
              ),
              Text(body.tr,
                  style: isDate
                      ? interRegularDefault.copyWith(
                          fontStyle: FontStyle.italic,
                          color: textColor ?? MyColor.smallTextColor1,
                          fontSize: Dimensions.fontSmall)
                      : interRegularDefault.copyWith(
                          color: textColor ?? MyColor.smallTextColor1))
            ],
          );
  }
}
