import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/data/controller/auth/auth/registration_controller.dart';
import 'package:finovelapp/views/components/buttons/rounded_button.dart';
import 'package:finovelapp/views/components/buttons/rounded_loading_button.dart';
import 'package:finovelapp/views/components/text-field/custom_text_form_field.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final formKey = GlobalKey<FormState>();

  // Hardcoded values for Indian country code and dial code
  final String defaultCountryName = "India";
  final String defaultDialCode = "+91";

  @override
  Widget build(BuildContext context) {
    final RegistrationController controller =
        Get.find<RegistrationController>();

    // Set the default values for country and dial code
    controller.countryName = defaultCountryName;
    controller.mobileCode = defaultDialCode;

    return GetBuilder<RegistrationController>(
      builder: (controller) => Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.textFieldToTextFieldSpace),

            CustomTextFormField(
              isUnderline: true,
              label: MyStrings.enterUsername,
              fillColor: MyColor.bgColor1,
              controller: controller.userNameController,
              focusNode: controller.userNameFocusNode,
              inputType: TextInputType.text,
              nextFocus: controller.emailFocusNode,
              hintText: MyStrings.enterUsername,
              maxLines: 1,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return MyStrings.enterYourUsername.tr;
                } else if (value.length < 6) {
                  return MyStrings.kShortUserNameError.tr;
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                return;
              },
            ),
            const SizedBox(height: Dimensions.textFieldToTextFieldSpace),

            CustomTextFormField(
                isUnderline: true,
                label: MyStrings.email,
                fillColor: MyColor.bgColor1,
                controller: controller.emailController,
                focusNode: controller.emailFocusNode,
                hintText: MyStrings.enterYourEmail,
                validator: (String? value) {
                  if (value != null && value.isEmpty) {
                    return MyStrings.enterYourEmail.tr;
                  } else if (!MyStrings.emailValidatorRegExp
                      .hasMatch(value ?? '')) {
                    return MyStrings.invalidEmailMsg.tr;
                  } else {
                    return null;
                  }
                },
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                onChanged: (value) {
                  return;
                }),
            const SizedBox(height: Dimensions.textFieldToTextFieldSpace),

            controller.countryName == null
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Focus(
                        onFocusChange: (hasFocus) {
                          controller.changeMobileFocus(hasFocus);
                        },
                        child: CustomTextFormField(
                          isUnderline: true,
                          label: 'Phone',
                          controller: controller.mobileController,
                          focusNode: controller.mobileFocusNode,
                          inputType: TextInputType.phone,
                          nextFocus: controller.referralCodeFocusNode,
                          fillColor: MyColor.bgColor1,
                          hintText: '7701908492',
                          isIcon: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your 10 digit phone number';
                            }
                            // Regex for Indian mobile number without country code
                            if (!RegExp(r"^[6789]\d{9}$").hasMatch(value)) {
                              return 'Enter a valid 10 digit phone number';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            return;
                          },
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: Dimensions.textFieldToTextFieldSpace),
            CustomTextFormField(
              isUnderline: true,
              label: 'Referral Code',
              fillColor: MyColor.bgColor1,
              controller: controller.referralCodeController,
              focusNode: controller.referralCodeFocusNode,
              inputType: TextInputType.text,
              hintText: 'Enter Referral Code',
              maxLines: 1,
              validator: (String? value) {
                if (value != null && value.isNotEmpty) {
                  if (value.length < 6) {
                    return 'Referral code must be at least 6 characters long';
                  } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                    return 'Referral code must be alphanumeric';
                  }
                }
                return null; // No validation error if the field is empty
              },
              onChanged: (value) {
                return;
              },
            ),
            const SizedBox(height: Dimensions.textFieldToTextFieldSpace),

            const SizedBox(height: Dimensions.textFieldToTextFieldSpace),
            controller.needAgree
                ? Visibility(
                    visible: controller.needAgree,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors
                                  .grey, // Color for the unchecked checkbox
                            ),
                            child: Checkbox(
                                value: controller.agreeTC,
                                onChanged: (value) {
                                  controller.updateAgreeTC();
                                }),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Row(
                          children: [
                            Text(MyStrings.iAgreeWith.tr,
                                style: interRegularDefault.copyWith(
                                    color: MyColor.colorBlack)),
                            const SizedBox(width: 3),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(RouteHelper.privacyScreen);
                              },
                              child: Text(
                                  MyStrings.privacyPolicies.tr.toLowerCase(),
                                  style: interBoldDefault.copyWith(
                                      color: MyColor.primaryColor,
                                      decoration: TextDecoration.underline,
                                      fontSize: Dimensions.fontSmall,
                                      decorationColor: MyColor.primaryColor)),
                            ),
                            const SizedBox(width: 3),
                          ],
                        ),
                      ],
                    ))
                : const SizedBox.shrink(),
            const SizedBox(
              height: 30,
            ),
            controller.submitLoading
                ? const RoundedLoadingBtn()
                : RoundedButton(
                    text: MyStrings.submit,
                    press: () {
                      if (formKey.currentState!.validate()) {
                        controller.signUpUser();
                      }
                    },
                  ),
            // const SizedBox(height: Dimensions.space40),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(MyStrings.alreadyAccount.tr, style: interRegularDefault),
            //     TextButton(
            //       onPressed: () {
            //         Get.offAndToNamed(RouteHelper.loginScreen);
            //       },
            //       child: Text(
            //         MyStrings.signIn.tr,
            //         style: interRegularDefault.copyWith(
            //             color: MyColor.primaryColor,
            //             decoration: TextDecoration.underline),
            //       ),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
