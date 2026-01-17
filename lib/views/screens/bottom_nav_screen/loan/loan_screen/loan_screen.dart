

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/data/controller/loan/loan_controller.dart';
import 'package:finovelapp/data/controller/loan/loan_plan_controller.dart';
import 'package:finovelapp/data/repo/loan/loan_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/appbar/custom_appbar.dart';
import 'package:finovelapp/views/components/custom_loader.dart';
import 'package:finovelapp/views/components/will_pop_widget.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/loan-plan/catagori_loan_plan_screen.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/loan_screen/widget/loan_catagori_chip_widget.dart';

import '../../../../../core/utils/my_color.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  @override
  void initState() {
    final arg = Get.arguments ?? '';
    Get.put(ApiClient(sharedPreferences: Get.find()));
    final controller = Get.put(LoanController());

    if (arg.toString().isNotEmpty) {
      controller.isPlan = false;
    }

    Get.put(LoanRepo(apiClient: Get.find()));
    final planController = Get.put(LoanPlanController(loanRepo: Get.find()));
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoanRepo(apiClient: Get.find()));
    Get.put(LoanPlanController(loanRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      planController.loadLoanPlan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoanPlanController>(
        builder: (controller) => WillPopWidget(
              nextRoute: controller.getPreviousRoute(),
              child: Scaffold(
                backgroundColor: MyColor.getScreenBgColor(),
                appBar: CustomAppBar(
                  title: MyStrings.loan,
                  isForceBackHome: controller.getPreviousRoute() !=
                      RouteHelper.notificationScreen,
                  isShowBackBtn: false,
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: controller.isLoading
                      ? const CustomLoader(
                      isFullScreen: true,
                    )
                  : Padding(
                      padding: Dimensions.screenPaddingHV,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: GetBuilder<LoanPlanController>(
                                builder: (planController) {
                              return Row(
                                children: List.generate(
                                  planController.catPlanList.length,
                                  (i) => LoanCategoryChip(categoryPlans: planController.catPlanList[i]),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: Dimensions.space20),
                          const LoanPlanScreen(),
                        ],
                      ),
                    ),
                ),
              ),
            ));
  }
}
