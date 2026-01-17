

import 'package:flutter/material.dart';


class MyUtil{

  static changeTheme(){
    /*SystemChrome.setSystemUIOverlayStyle(

        const SystemUiOverlayStyle(

            statusBarColor: MyColor.primaryColor,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: MyColor.navigationBarColor,
            systemNavigationBarIconBrightness: Brightness.dark
        )
    );*/
  }

  static dynamic getShadow(){
    return  [
      BoxShadow(
          blurRadius: 15.0,
          offset: const Offset(0, 25),
          color: Colors.grey.shade500.withOpacity(0.6),
          spreadRadius: -35.0),
    ];
  }

  static dynamic getBottomSheetShadow(){
    return  [
      BoxShadow(
        // color: MyColor.screenBgColor,
        color: Colors.grey.shade400.withOpacity(0.08),
        spreadRadius: 3,
        blurRadius: 4,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ];
  }

 static  String formatAmount(String amount) {
  // Try to convert the amount to a double
  final double? value = double.tryParse(amount);
  if (value != null) {
    // Check if the amount is an integer (no fractional part)
    if (value == value.toInt()) {
      // If yes, return it as an integer string
      return value.toInt().toString();
    } else {
      // If not, return the formatted string with only significant digits after the decimal point
      return value.toStringAsFixed(2).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
    }
  }
  // Return the original amount if parsing fails
  return amount;
}


  static dynamic getCardShadow(){
    return  [
      BoxShadow(
        color: Colors.grey.shade400.withOpacity(0.05),
        spreadRadius: 2,
        blurRadius: 2,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static String get _getDeviceType {
  final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
  return data.size.width < 550 ? 'phone' : 'tablet';
  }

  static bool get isTablet {
  return _getDeviceType == 'tablet';
  }
  String? ifscValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter IFSC code';
  }
  if (!RegExp(r'^[A-Za-z]{4}0[A-Z0-9a-z]{6}$').hasMatch(value)) {
    return 'Invalid IFSC code';
  }
  return null;
}

String? upiValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter UPI ID';
  }
  // Example UPI ID format validation (modify as per your requirements)
  if (!RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z]+$').hasMatch(value)) {
    return 'Invalid UPI ID format';
  }
  return null;
}



}