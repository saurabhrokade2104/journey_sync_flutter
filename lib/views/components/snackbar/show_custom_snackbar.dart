import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/string_format_helper.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_images.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/style.dart';

class CustomSnackBar {
  static bool isSnackbarShowing = false; // Flag to prevent multiple snackbars

  static error({required List<String> errorList, int duration = 5}) {

    String message = '';
    if (errorList.isEmpty) {
      message = MyStrings.somethingWentWrong.tr;
    } else {
      for (var element in errorList) {
        String tempMessage = element.tr;
        message = message.isEmpty ? tempMessage.tr : "$message\n$tempMessage";
      }
    }
    message = Converter.removeQuotationAndSpecialCharacterFromString(message);
    Get.rawSnackbar(
      progressIndicatorBackgroundColor: MyColor.transparentColor,
      progressIndicatorValueColor:
          const AlwaysStoppedAnimation<Color>(Colors.transparent),
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 2,
          ),
          Text(
            message,
            style: interRegularDefault.copyWith(color: MyColor.colorWhite),
          ),
        ],
      ),
      dismissDirection: DismissDirection.horizontal,
      snackPosition: SnackPosition.BOTTOM,
      /* titleText: Row(
        children: [
          SvgPicture.asset(MyImages.errorIcon,height: 20,width: 20,color: MyColor.colorWhite,),
          const SizedBox(width: 5),
          Text(MyStrings.error.tr.capitalizeFirst??'',style: interSemiBoldSmall.copyWith(fontSize: Dimensions.fontLarge,color: MyColor.colorWhite)),
        ],
      ),*/
      backgroundColor: MyColor.red,
      borderRadius: 4,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      duration: Duration(seconds: duration),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeIn,
      showProgressIndicator: true,
      leftBarIndicatorColor: MyColor.transparentColor,
      animationDuration: const Duration(seconds: 1),
      borderColor: MyColor.transparentColor,
      reverseAnimationCurve: Curves.easeOut,
      borderWidth: 2,
    );
  }

  static success({required List<String> successList, int duration = 2}) {
    String message = '';
    if (successList.isEmpty) {
      message = MyStrings.somethingWentWrong.tr;
    } else {
      for (var element in successList) {
        String tempMessage = element.tr;
        message = message.isEmpty ? tempMessage : "$message\n$tempMessage";
      }
    }
    message = Converter.removeQuotationAndSpecialCharacterFromString(message);
    Get.rawSnackbar(
      progressIndicatorBackgroundColor: MyColor.green,
      progressIndicatorValueColor: AlwaysStoppedAnimation<Color>(MyColor.transparentColor),
      messageText: Column(
        mainAxisSize: MainAxisSize.min, // Adjust the column size to fit the content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reduced the size for a more compact look
          Text(message, style: interRegularDefault.copyWith(fontSize: 14, color: MyColor.colorWhite)),
        ],
      ),
      dismissDirection: DismissDirection.horizontal,
      snackPosition: SnackPosition.BOTTOM,
      titleText: Row(
        mainAxisSize: MainAxisSize.min, // Adjust row size to fit content
        children: [
          SvgPicture.asset(
            MyImages.successIcon,
            height: 18, // Slightly smaller icon for a sleeker look
            width: 18,
            color: MyColor.colorWhite,
          ),
          const SizedBox(width: 5),
          // Adjusted for a more compact and elegant display
          Text(MyStrings.success.tr, style: interSemiBoldSmall.copyWith(fontSize: Dimensions.fontMediumLarge, color: MyColor.colorWhite)),
        ],
      ),
      backgroundColor: MyColor.greenSuccessColor,
      borderRadius: 4,
      margin: const EdgeInsets.all(8),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Reduced padding for less height
      duration: Duration(seconds: duration),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeInOutCubicEmphasized,
      showProgressIndicator: false, // Consider whether you need a progress indicator for a success message
      leftBarIndicatorColor: MyColor.transparentColor,
      animationDuration: const Duration(seconds: 1),
      borderColor: MyColor.transparentColor,
      reverseAnimationCurve: Curves.easeOut,
      borderWidth: 1, // Optional: Adjusted for a more refined look
    );
  }

}
