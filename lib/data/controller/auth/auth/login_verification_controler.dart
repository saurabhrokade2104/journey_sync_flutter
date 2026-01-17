import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/data/model/authorization/authorization_response_model.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/data/repo/auth/sms_email_verification_repo.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';

import '../../../model/auth/login_response_model.dart';
import '../login_controller.dart';

class LoginSmsVerificationController extends GetxController {
  SmsEmailVerificationRepo repo;
  final LoginController loginController;
  LoginSmsVerificationController(
      {required this.repo, required this.loginController});

  bool hasError = false;
  bool isLoading = true;
  String currentText = '';
  bool isProfileCompleteEnable = false;
  String? phoneNumber;
  bool isTwoFactorEnable = false;

  Future<void> loadBefore() async {
    isLoading = true;
    update();
    // await repo.sendAuthorizationRequest();
    isLoading = false;
    update();
    return;
  }

  bool submitLoading = false;
  verifyYourSms(String currentText) async {
    if (currentText.isEmpty) {
      CustomSnackBar.error(
        errorList: [MyStrings.otpFieldEmptyMsg.tr],
      );
      return;
    }

    submitLoading = true;
    update();

    ResponseModel responseModel =
        await repo.verifyLoginMobileOtp(phone: phoneNumber!, otp: currentText);

    // Check if responseJson is empty or null
    if (responseModel.responseJson.isEmpty) {
      print("Error: Empty JSON response");
      CustomSnackBar.error(
          errorList: ["Empty or invalid response from server"]);
      return;
    }

    print('otp response check : ${responseModel.statusCode}');

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));

      print('otp auth model check: ${model.toJson()}');
      if (model.status == 'success') {
        // if (isTwoFactorEnable) {
        //   Get.offAndToNamed(RouteHelper.twoFactorVerificationScreen,
        //       arguments: isProfileCompleteEnable);
        // } else {
        //   Get.offAndToNamed(RouteHelper.bottomNavScreen);
        // }

        // Call checkAndGotoNextStep
        LoginResponseModel loginModel =
            LoginResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        loginController.checkAndGotoNextStep(loginModel);
        CustomSnackBar.success(
          successList: model.message?.success ??
              ['${MyStrings.sms.tr} ${MyStrings.verificationSuccess.tr}'],
        );
      } else {
        CustomSnackBar.error(
            errorList: model.message?.error ??
                ['${MyStrings.sms.tr} ${MyStrings.verificationFailed}']);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    submitLoading = false;
    update();
  }

  bool resendLoading = false;
  Future<void> sendCodeAgain() async {
    resendLoading = true;
    update();
    print('check phone no : $phoneNumber');
    await repo.resendLoginVerifyCode(phoneNumber: phoneNumber!);
    resendLoading = false;
    update();
  }
}
