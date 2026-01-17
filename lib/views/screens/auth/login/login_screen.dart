import 'package:country_code_picker/country_code_picker.dart';
import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/views/components/text-field/custom_text_field_phone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_images.dart';

import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/style.dart';

import 'package:finovelapp/data/controller/auth/login_controller.dart';
import 'package:finovelapp/data/repo/auth/login_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/buttons/rounded_button.dart';
import 'package:finovelapp/views/components/buttons/rounded_loading_button.dart';

import 'package:finovelapp/views/components/text/header_text.dart';
import 'package:finovelapp/views/components/text/light_text.dart';
import 'package:finovelapp/views/components/will_pop_widget.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool b = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoginRepo(apiClient: Get.find()));
    final controller = Get.put(LoginController(loginRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.remember = false;
      controller.checkBiometrics();
      controller.getAvailableBiometrics();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _countryDialCode = '+91';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) => WillPopWidget(
        nextRoute: '',
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: MyColor.whiteColor,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05),
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Center(
                            child: Image.asset(MyImages.appLogo,
                                height: Dimensions.appLogoHeight,
                                width: Dimensions.appLogoWidth),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),
                        const HeaderText(text: MyStrings.wellComeBack),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              end: MediaQuery.of(context).size.width * .32),
                          child: const LightText(
                              text: MyStrings.happyToSeeYouAgain),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .035,
                        ),

                        CustomTextFieldPhone(
                          titleText: 'Enter your phone number',
                          hintText: 'Enter your phone number',
                          controller: controller.phoneController,
                          focusNode: controller.emailFocusNode,
                          inputType: TextInputType.phone,
                          isPhone: true,
                          showTitle: false,
                          onCountryChanged: (CountryCode countryCode) {
                            _countryDialCode = countryCode.dialCode!;
                          },
                          countryDialCode: '+91',
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Expanded(
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(0),
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           children: [
                        //             SizedBox(
                        //               width: 23,
                        //               height: 25,
                        //               child: Checkbox(
                        //                   activeColor: MyColor.primaryColor,
                        //                   value: controller.remember,
                        //                   side: MaterialStateBorderSide
                        //                       .resolveWith(
                        //                     (states) => BorderSide(
                        //                         width: 1.0,
                        //                         color: controller.remember
                        //                             ? MyColor.transparentColor
                        //                             : MyColor.primaryColor),
                        //                   ),
                        //                   onChanged: (value) {
                        //                     controller.changeRememberMe();
                        //                   }),
                        //             ),
                        //             const SizedBox(
                        //               width: 12,
                        //             ),
                        //             Expanded(
                        //               child: Text(
                        //                 MyStrings.rememberMe.tr,
                        //                 style: interBoldDefault.copyWith(
                        //                     fontSize: Dimensions.fontDefault),
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     Flexible(
                        //       child: Align(
                        //         alignment: Alignment.centerRight,
                        //         child: GestureDetector(
                        //           onTap: () {
                        //             Get.toNamed(
                        //                 RouteHelper.forgetPasswordScreen);
                        //           },
                        //           child: Text(
                        //             MyStrings.forgetPassword.tr,
                        //             style: interRegularDefault.copyWith(
                        //                 color: MyColor.primaryColor,
                        //                 fontSize: Dimensions.fontDefault),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('* ', style: robotoRegular),
                              Text('By login I Agree with all the',
                                  style: robotoRegular.copyWith(
                                      color: Theme.of(context).hintColor)),
                              Expanded(
                                child: InkWell(
                                  onTap: () => Get.toNamed(
                                      RouteHelper.termsServicesScreen),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSize15),
                                    child: Text('Terms & Condition',
                                        style: robotoMedium.copyWith(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 45,
                        ),
                        controller.isSubmitLoading
                            ? const RoundedLoadingBtn()
                            : RoundedButton(
                                press: () {
                                  if (formKey.currentState!.validate()) {
                                    controller.loginUser();
                                  }
                                },
                                text: MyStrings.login,
                              ),

                        const SizedBox(
                          height: 50,
                        ),

                       if(controller.availableBiometrics.isNotEmpty)
                        Center(
                          child: TextButton.icon(
                            onPressed: () =>
                                controller.authenticateUserBiometric(),
                            icon: const Icon(Icons.fingerprint),
                            label: controller.isAuthenticating.value
                                ? Center(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      AppColors.accentColor),
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          const SizedBox(
                                              width:
                                                  Dimensions.paddingSizeSmall),
                                          Text('loading'.tr,
                                              style: interMediumSmall.copyWith(
                                                  color:
                                                      AppColors.accentColor)),
                                        ]),
                                  )
                                : Text(
                                    controller.availableBiometrics
                                            .contains(BiometricType.face)
                                        ? 'Login with Face Id'
                                        : 'Login with Fingerprint',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accentColor,
                                    ),
                                  ),
                            style: TextButton.styleFrom(
                              disabledBackgroundColor:
                                  Colors.grey.shade800, // Icon color
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 20), // Button padding
                              backgroundColor: Colors
                                  .grey.shade200, // Button background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Button corner radius
                              ),
                            ),
                          ),
                        ),
                        // Center(
                        //   child: Text(
                        //     MyStrings.doNotHaveAccount.tr,
                        //     style: mulishRegular.copyWith(
                        //         fontSize: Dimensions.fontLarge),
                        //   ),
                        // ),
                        // Center(
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       controller.emailController.text = '';
                        //       controller.passwordController.text = '';
                        //       controller.remember = true;
                        //       Get.offAndToNamed(RouteHelper.registrationScreen);
                        //     },
                        //     child: Text(
                        //       MyStrings.createNew.tr,
                        //       style: interRegularDefault.copyWith(
                        //           fontSize: 18, color: MyColor.primaryColor),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 30,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
