import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_images.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/data/controller/auth/auth/email_verification_controler.dart';
import 'package:finovelapp/data/repo/auth/general_setting_repo.dart';
import 'package:finovelapp/data/repo/auth/sms_email_verification_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/appbar/custom_appbar.dart';
import 'package:finovelapp/views/components/buttons/rounded_button.dart';
import 'package:finovelapp/views/components/buttons/rounded_loading_button.dart';
import 'package:finovelapp/views/components/otp_field_widget/otp_field_widget.dart';
import 'package:finovelapp/views/components/will_pop_widget.dart';

class EmailVerificationScreen extends StatefulWidget {
  final bool needSmsVerification;
  final bool isProfileCompleteEnabled;
  final bool needTwoFactor;
  final String phoneNumber;
  final String emailId;

  const EmailVerificationScreen(
      {super.key,
      required this.needSmsVerification,
      required this.isProfileCompleteEnabled,
      required this.needTwoFactor,
      this.phoneNumber = '',
      required this.emailId});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SmsEmailVerificationRepo(apiClient: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    final controller = Get.put(EmailVerificationController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.needSmsVerification = widget.needSmsVerification;
      controller.isProfileCompleteEnable = widget.isProfileCompleteEnabled;
      controller.needTwoFactor = widget.needTwoFactor;
      controller.userPhoneNumber = widget.phoneNumber;
      controller.emailId = widget.emailId;
      controller.loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: RouteHelper.loginScreen,
      child: Scaffold(
          backgroundColor: MyColor.getScreenBgColor(),
          appBar: CustomAppBar(
            title: MyStrings.emailVerification,
            fromAuth: true,
          ),
          body: GetBuilder<EmailVerificationController>(
            builder: (controller) => SingleChildScrollView(
                padding: Dimensions.screenPaddingHV,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: Dimensions.space30),
                      Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: MyColor.primaryColor600,
                            shape: BoxShape.circle),
                        child: SvgPicture.asset(MyImages.emailVerifyImage,
                            height: 50,
                            width: 50,
                            color: MyColor.primaryColor),
                      ),
                      const SizedBox(height: Dimensions.space50),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * .1),
                        child: Text('${MyStrings.otpSubText.tr} ${controller.emailId}',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: interRegularDefault.copyWith(
                                color: MyColor.labelTextColor)),
                      ),
                      const SizedBox(height: 30),
                      OTPFieldWidget(
                        onChanged: (value) {
                          controller.currentText = value;
                        },
                      ),
                      const SizedBox(height: Dimensions.space30),
                      controller.submitLoading
                          ? const RoundedLoadingBtn()
                          : RoundedButton(
                              text: MyStrings.verify.tr,
                              textColor: MyColor.colorWhite,
                              press: () {
                                controller
                                    .verifyEmail(controller.currentText);
                              },
                              color: MyColor.primaryColor,
                            ),
                      const SizedBox(height: Dimensions.space30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            MyStrings.didNotReceiveCode.tr,
                            style: interRegularDefault.copyWith(
                                color: MyColor.labelTextColor),
                          ),
                          const SizedBox(width: Dimensions.space10),
                          controller.resendLoading
                              ? Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, top: 5),
                                  height: 20,
                                  width: 20,
                                  child: const CircularProgressIndicator(
                                      color: MyColor.primaryColor),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    controller.sendCodeAgain();
                                  },
                                  child: Text(
                                    MyStrings.resend.tr,
                                    style: interRegularDefault.copyWith(
                                      color: MyColor.primaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                        ],
                      )
                    ],
                  ),
                )),
          )),
    );
  }
}
