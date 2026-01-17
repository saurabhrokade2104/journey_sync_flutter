import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/shared_preference_helper.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/data/model/auth/login_response_model.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/data/repo/auth/login_repo.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';
import 'package:local_auth/local_auth.dart';

enum SupportState {
  unknown,
  supported,
  unsupported,
}

class LoginController extends GetxController {
  LoginRepo loginRepo;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<String> errors = [];
  String? email;
  String? password;
  bool remember = true;
   final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final Rx<SupportState> supportState = SupportState.unknown.obs;
  final RxBool canCheckBiometrics = false.obs;
  final RxList<BiometricType> availableBiometrics = <BiometricType>[].obs;
  final RxString authorized = 'Not Authorized'.obs;
  final RxBool isAuthenticating = false.obs;


  LoginController({required this.loginRepo});

  void forgetPassword() {
    Get.toNamed(RouteHelper.forgetPasswordScreen);
  }


Future<void> checkBiometrics() async {
    bool canCheck;
    try {
      canCheck = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheck = false;
      print(e);
    }
    canCheckBiometrics.value = canCheck;
  }

  Future<void> getAvailableBiometrics() async {
    List<BiometricType> biometrics;
    try {
      biometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      biometrics = <BiometricType>[];
      print(e);
    }
    availableBiometrics.value = biometrics;
    update();
  }



  Future<void> cancelAuthentication() async {
    await auth.stopAuthentication();
    isAuthenticating.value = false;
  }


Future<void> authenticateUserBiometric() async {
    try {
      //  await secureStorage.write(key: 'biometric_enabled', value: 'true');

      bool isBiometricEnabled = await secureStorage.read(key: 'biometric_enabled') == 'true';
      if (isBiometricEnabled) {
        isAuthenticating.value = true;
        authorized.value = 'Authenticating';
        update();
        bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Log in using your biometric credentials',
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );

        if (didAuthenticate) {
          debugPrint('Biometric authentication successful');
          // Successful biometric authentication
          String? authToken = await secureStorage.read(key: 'auth_token');
          debugPrint('Authentication token retrieved: $authToken');
          if (authToken != null) {
            loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey, authToken);
            loginRepo.apiClient.sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, true);
            loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.accessTokenType, 'Bearer');



            // Use authToken to log in the user automatically
            await processLogin(authToken); // Process login with authToken

          } else {
            // Handle case where authToken is null
            authorized.value = 'Failed to retrieve authentication token.';
          }
        } else {
          // Biometric authentication failed
          authorized.value = 'Authentication failed.';
        }
      } else {
        // Biometrics not enabled or not set up
        authorized.value = 'Biometric authentication not enabled.';
        CustomSnackBar.error(errorList: ['Biometric authentication not enabled.']);
      }
    } on PlatformException catch (e) {
      // Handle specific platform exceptions related to local authentication
      authorized.value = 'Error authenticating: ${e.message}';
    } catch (e) {
      // Handle other exceptions
      authorized.value = 'An unexpected error occurred.';
    } finally {
      isAuthenticating.value = false;
      update();
    }
  }

  Future<void> processLogin(String authToken) async {
    isSubmitLoading = true;
    update();

    try {
      ResponseModel responseModel = await loginRepo.getUserData();
      debugPrint('Response: ${responseModel.responseJson}');
      if (responseModel.statusCode == 200) {
        LoginResponseModel loginModel = LoginResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (loginModel.status.toString().toLowerCase() == 'success') {
          CustomSnackBar.success(successList: ['Login successful.']);
          Get.offAndToNamed(RouteHelper.bottomNavScreen); // Navigate to the home screen
        } else {
          // Handle login failure
          CustomSnackBar.error(errorList: loginModel.message?.error ?? [MyStrings.loginFailedTryAgain]);
        }
      } else {
        debugPrint('Error: ${responseModel.message}');
        // Handle API error response
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      debugPrint('Error api call biometric call : $e');
      // Handle unexpected errors
      CustomSnackBar.error(errorList: ['An unexpected error occurred']);
    } finally {
      isSubmitLoading = false;
      update();
    }
  }


  void checkAndGotoNextStep(LoginResponseModel responseModel) async {
    bool needEmailVerification =
        responseModel.data?.user?.ev == "1" ? false : true;
    bool needSmsVerification =
        responseModel.data?.user?.sv == '1' ? false : true;
    bool isTwoFactorEnable = responseModel.data?.user?.tv == '1' ? false : true;

    print('remmber the user $remember');

    await loginRepo.apiClient.sharedPreferences
        .setBool(SharedPreferenceHelper.rememberMeKey, true);

    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.userIdKey,
        responseModel.data?.user?.id.toString() ?? '-1');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.accessTokenKey,
        responseModel.data?.accessToken ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.accessTokenType,
        responseModel.data?.tokenType ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.userEmailKey,
        responseModel.data?.user?.email ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.userPhoneNumberKey,
        responseModel.data?.user?.mobile ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.userNameKey,
        responseModel.data?.user?.username ?? '');

    await loginRepo.sendUserToken();

    bool isProfileCompleteEnable =
        responseModel.data?.user?.regStep == '0' ? true : false;

    // bool isDeviceDataComplete =    ;

    if (needSmsVerification == false &&
        needEmailVerification == false &&
        isTwoFactorEnable == false) {
      if (isProfileCompleteEnable) {
        Get.offAndToNamed(RouteHelper.profileCompleteScreen);
      } else {
        Get.offAndToNamed(RouteHelper.bottomNavScreen);
      }
    } else if (needSmsVerification == true &&
        needEmailVerification == true &&
        isTwoFactorEnable == true) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen,
          arguments: [true, isProfileCompleteEnable, isTwoFactorEnable, responseModel.data?.user?.email, responseModel.data?.user?.mobile]);
    } else if (needSmsVerification == true && needEmailVerification == true) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen,
          arguments: [true, isProfileCompleteEnable, isTwoFactorEnable, responseModel.data?.user?.email, responseModel.data?.user?.mobile]);
    } else if (needSmsVerification) {
       debugPrint('needSmsVerification ${responseModel.data?.user?.mobile}');
      debugPrint('needSmsVerification profilecomplete $isProfileCompleteEnable');
      debugPrint('needSmsVerification two factor $isTwoFactorEnable');

      Get.offAndToNamed(RouteHelper.smsVerificationScreen,
          arguments: [isProfileCompleteEnable, isTwoFactorEnable,responseModel.data?.user?.mobile ]);
    } else if (needEmailVerification) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen,
          arguments: [false, isProfileCompleteEnable, isTwoFactorEnable, responseModel.data?.user?.email, responseModel.data?.user?.mobile]);
    } else if (isTwoFactorEnable) {
      Get.offAndToNamed(RouteHelper.twoFactorVerificationScreen,
          arguments: isProfileCompleteEnable);
    }

    if (remember) {
      changeRememberMe();
    }
  }

  bool isSubmitLoading = false;
  void loginUser() async {
    isSubmitLoading = true;
    update();

    ResponseModel model =
        await loginRepo.loginWithMobile('+91${phoneController.text.trim()}');

    if (model.statusCode == 200) {
      LoginResponseModel loginModel =
          LoginResponseModel.fromJson(jsonDecode(model.responseJson));
      if (loginModel.status.toString().toLowerCase() ==
          MyStrings.success.toLowerCase()) {
        // checkAndGotoNextStep(loginModel);
        Get.offAndToNamed(RouteHelper.loginSmsVerificationScreen,
            arguments: ['+91${phoneController.text.trim()}']);
        return;
      } else {
        if (loginModel.message?.error != [] ||
            loginModel.message?.error != null) {
          String message = '';
          for (var element in loginModel.message!.error!) {
            String tempMessage = element.tr;
            message =
                message.isEmpty ? tempMessage.tr : "$message\n$tempMessage";
          }

          if (message == 'User is not registered.') {
            Get.offAndToNamed(RouteHelper.registrationScreen,arguments: [phoneController.text.trim()]);
          }
        }
       else{
         CustomSnackBar.error(
          errorList:
              loginModel.message?.error ?? [MyStrings.loginFailedTryAgain],
        );
       }
      }
    } else {
      // CustomSnackBar.error(
      //   errorList: [model.message],
      // );
    }
    isSubmitLoading = false;
    update();
  }

  changeRememberMe() {
    remember = !remember;
    update();
  }

  void clearAllSharedPreData() {
    loginRepo.apiClient.sharedPreferences
        .setBool(SharedPreferenceHelper.rememberMeKey, false);
    loginRepo.apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.accessTokenKey, '');
    return;
  }

  void clearData() {
    remember = false;
    isSubmitLoading = false;
    emailController.text = '';
    passwordController.text = '';
  }
}
