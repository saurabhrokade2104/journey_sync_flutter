import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dimensions {
  static const double appLogoHeight = 100.00;
  static const double appLogoWidth = 100.00;
  static const double onboardImageHeight = 250.00;
  static const double onboardImageHeightInV = 150.00;
  static const double onBoardImageWidthInV = 250.00;
  static const double onBoardImageWidth = 250.00;

  /// font-size
  static const double fontOverSmall = 7.00;
  static const double fontExtraSmall = 9.00;
  static const double fontSmall = 11.00;
  static const double fontSmall12 = 12.00;
  static const double fontDefault = 13.00;
  static const double fontLarge = 15.00;
  static const double fontMediumLarge = 16.00;
  static const double fontExtraLarge = 17.00;
  static const double fontOverLarge = 18.00;
  static const double fontHeader1 = 20.00;
  static const double fontHeader2 = 23.00;
  static const double fontExtraHeader = 27.00;

  // white-space
  static const double space5 = 5;
  static const double space10 = 10;
  static const double space7 = 7;
  static const double space15 = 15;
  static const double space12 = 12;
  static const double space14 = 14;
  static const double space20 = 20;
  static const double space25 = 25;
  static const double space30 = 30;
  static const double space35 = 35;
  static const double space40 = 40;
  static const double space50 = 50;

  // screen-padding
  static const double defaultScreenTopPadding = 20.00;
  static const double defaultScreenLeftPadding = 15.00;
  static const double screenPadding = 15.00;
  static const double defaultScreenRightPadding = 15.00;
  static const double defaultScreenBottomPadding = 20.00;

  // widgets border-radius
  static const double defaultRadius = 4.00;
  static const double defaultBorderRadius = 5.00;
  static const double cardMargin = 12;
  static const double mediumRadius = 8;
  static const double largeRadius = 12;
  static const double extraRadius = 16;

// padding
  static const double paddingSize5 = 5.0;
  static const double paddingSize10 = 10.0;
  static const double paddingSize15 = 15.0;
  static const double paddingSize20 = 20.0;
  static const double paddingSize25 = 25.0;
  static const double paddingSize30 = 30.0;

  static const double defaultButtonHeight45 = 45.00;
  static const double textToTextSpace = 8.00;
  static const double sectionToSectionSpace = 13.00;
  static const double textFieldToTextFieldSpace = 15.00;
  static const double cardToCardSpace = 12.00;

  static const double radiusSmall = 5.0;
  static const double radiusDefault = 10.0;
  static const double radiusLarge = 15.0;
  static const double radiusExtraLarge = 20.0;


  static const double webMaxWidth = 1170;
 static const double paddingSizeSmall = 10.0;
  static double fontSizeLarge = Get.context!.width >= 1300 ? 20 : 16;

  static const double screenPaddingH = 15;
  static const double paddingSizeLarge = 20.0;
   static double fontSizeDefault = Get.context!.width >= 1300 ? 16 : 14;
  static const double screenPaddingV = 15;
  static const EdgeInsets paddingInset = EdgeInsets.symmetric(vertical: Dimensions.screenPaddingV * 4, horizontal: Dimensions.screenPaddingH);
  static const EdgeInsets screenPaddingHV = EdgeInsets.symmetric(vertical: 15, horizontal: Dimensions.space12);
  static const EdgeInsets screenPaddingHV1 = EdgeInsets.symmetric(vertical: 20, horizontal: 17);
  static const EdgeInsets previewPaddingHV = EdgeInsets.symmetric(vertical: 17, horizontal: Dimensions.space15);

}
