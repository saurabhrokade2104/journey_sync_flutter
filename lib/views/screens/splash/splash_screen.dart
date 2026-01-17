import 'package:finovelapp/data/controller/onboard/onboarding_controller.dart';
import 'package:finovelapp/data/repo/onboard/onboarding_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/theme/theme_util.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_images.dart';
import 'package:finovelapp/data/controller/localization/localization_controller.dart';
import 'package:finovelapp/data/controller/splash/splash_controller.dart';
import 'package:finovelapp/data/repo/auth/general_setting_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    ThemeUtil.makeSplashTheme();

    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(OnBoardingRepo());
    Get.put(LocalizationController(sharedPreferences: Get.find()));
    Get.put(OnBoardingController(onboardingRepo: Get.find()));

    final controller = Get.put(
        SplashController(repo: Get.find(), localizationController: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.gotoNextPage();
    });
  }

  @override
  void dispose() {
    ThemeUtil.allScreenTheme();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        builder: (controller) => Scaffold(
              backgroundColor:  MyColor.colorWhite,

              body: Center(
                child: Image.asset(
                  MyImages.appLogoWhite,
                  height: 312,
                  // width: Dimensions.appLogoWidth
                ),
              ),
            ));
  }
}
