// ignore_for_file: unrelated_type_equality_checks

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
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/loan-plan/all_loan_plan_list.dart';

import '../../../../../core/utils/my_color.dart';

class AllLoanPlanScreen extends StatefulWidget {
  const AllLoanPlanScreen({super.key});

  @override
  State<AllLoanPlanScreen> createState() => _AllLoanPlanScreenState();
}

class _AllLoanPlanScreenState extends State<AllLoanPlanScreen> {
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
    final planListController =
        Get.put(LoanPlanController(loanRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      planController.loadLoanPlan();
      // planListController.initialSelectedValue();
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
                  title: MyStrings.loanPlan,
                  isForceBackHome: controller.getPreviousRoute() !=
                      RouteHelper.notificationScreen,
                  isShowBackBtn: false,
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: controller.isLoading
                      ? const CustomLoader(
                          isFullScreen: true,
                        ) //BUG:
                      : const Padding(
                          padding: Dimensions.screenPaddingHV,
                          child: AllLoanPlanList(),
                        ),
                ),
              ),
            ));
  }
}
