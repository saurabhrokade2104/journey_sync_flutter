import 'package:flutter/material.dart';

import '../utils/my_color.dart';
import '../utils/style.dart';

ThemeData light = ThemeData(
    fontFamily: 'Inter',
    primaryColor: MyColor.lPrimaryColor,
    // brightness: Brightness.dark,
    // scaffoldBackgroundColor: MyColor.colorGrey.withOpacity(0.3),
    hintColor: MyColor.hintTextColor,
    buttonTheme: ButtonThemeData(
      buttonColor: MyColor.getPrimaryColor(),
    ),
    cardColor: MyColor.cardBgColor,
    appBarTheme: AppBarTheme(
      backgroundColor: MyColor.lPrimaryColor,
      elevation: 0,
      titleTextStyle: interRegularLarge.copyWith(color: MyColor.colorWhite),
      iconTheme: const IconThemeData(
        size: 20,
        color: MyColor.colorWhite
    )
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(MyColor.primaryColor),
      overlayColor: WidgetStateProperty.all(MyColor.colorWhite)
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(MyColor.colorWhite),
      fillColor: WidgetStateProperty.all(MyColor.primaryColor),
    ));
