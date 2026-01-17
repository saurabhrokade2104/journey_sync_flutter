// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/string_format_helper.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/data/model/loan/loan_plan_response_model.dart';
import 'package:finovelapp/data/model/loan/loan_preview_response_model.dart';
import 'package:finovelapp/data/repo/loan/loan_repo.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';

class LoanPlanController extends GetxController {
  LoanRepo loanRepo;
  LoanPlanController({required this.loanRepo});

  bool isLoading = false;
  int index = 0;

  List<LoanPlan> planList = [];
// catagory plans
  String? selectedCatId;
  List<CategoryPlans> catPlanList = [];
  List<LoanPlan> seletedCatagoryProducts = [];
  CategoryPlans? selectcatagori;

  //
  List<String> authorizationList = [];
  String? selectedAuthorizationMode;

  String currency = "";
  String currencySymbol = "";

  void changeAuthorizationMode(String? value) {
    if (value != null) {
      selectedAuthorizationMode = value;
      update();
    }
  }

  void selectCatagoryId(String? value) {
    selectedCatId = value;
    update();
  }

  void selectCatagori(CategoryPlans cat) {
    selectcatagori = null;
    selectedIndex = -1;
    update();

    selectCatagoryId(cat.id.toString());
    selectcatagori = cat;
    update();
    log(' ${selectcatagori?.name.toString()} ${selectcatagori!.plans?.length.toString()}');
  }

  Future<void> loadLoanPlan() async {
    authorizationList = loanRepo.apiClient.getAuthorizationList();
    changeAuthorizationMode(authorizationList[0]);
    planList.clear();
    catPlanList.clear();
    selectcatagori = null;
    isLoading = true;
    submitLoading = false;
    update();
    currency = loanRepo.apiClient.getCurrencyOrUsername();
    currencySymbol = loanRepo.apiClient.getCurrencyOrUsername(isSymbol: true);

    ResponseModel responseModel = await loanRepo.getLoanPlan();
    if (responseModel.statusCode == 200) {
      LoanPlanResponseModel model = LoanPlanResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));
      if (model.status.toString().toLowerCase() == "success") {
        List<LoanPlan>? tempPlanList = model.data?.loanPlans?.data;
        List<CategoryPlans>? tempCatPlanList = model.data?.categories;
        if (tempCatPlanList != null && tempCatPlanList.isNotEmpty) {
          catPlanList.addAll(tempCatPlanList);
          seletedCatagoryProducts = tempCatPlanList[0].plans ?? [];
          selectcatagori = tempCatPlanList[0];
          selectedCatId = catPlanList[0].id.toString();
          log(selectedCatId.toString());
        }
        if (tempPlanList != null && tempPlanList.isNotEmpty) {
          planList.addAll(tempPlanList);
        }
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ?? [MyStrings.somethingWentWrong],
        );
      }
    } else {
      CustomSnackBar.error(
        errorList: [responseModel.message],
      );
    }

    isLoading = false;
    update();
  }

  int selectedIndex = -1;
  void changeIndex(int index) {
    selectedIndex = index;
    update();
  }

  bool submitLoading = false;
  TextEditingController amountController = TextEditingController();
  void submitLoanPlan(String planId, int index) async {
    double amount = double.tryParse(amountController.text) ?? 0;
    if (amount <= 0) {
      CustomSnackBar.error(errorList: [MyStrings.invalidAmount]);
      return;
    }

    double minLimit =
        double.tryParse(selectcatagori?.plans![index].minimumAmount ?? '0') ??
            0;
    double maxLimit =
        double.tryParse(selectcatagori?.plans![index].maximumAmount ?? '0') ??
            0;

    if (amount > maxLimit || amount < minLimit) {
      CustomSnackBar.error(errorList: [MyStrings.loanLimitMsg]);
      return;
    }

    submitLoading = true;
    update();
    log(planId);
    ResponseModel response = await loanRepo.submitLoanPlan(
      planId,
      amount.toString(),
      selectedAuthorizationMode,
    );
    if (response.statusCode == 200) {
      LoanPreviewResponseModel model =
          LoanPreviewResponseModel.fromJson(jsonDecode(response.responseJson));
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        Get.offAndToNamed(RouteHelper.loanConfirmScreen, arguments: model);
      } else {
        CustomSnackBar.error(
            errorList: model.message?.error ?? [MyStrings.requestFail]);
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    submitLoading = false;
    update();
  }

  // all loan plas submit
  void submitAllLoanPlan(String planId, int index) async {
    double amount = double.tryParse(amountController.text) ?? 0;
    if (amount <= 0) {
      CustomSnackBar.error(errorList: [MyStrings.invalidAmount]);
      return;
    }

    double minLimit =
        double.tryParse(planList[index].minimumAmount ?? '0') ?? 0;
    double maxLimit =
        double.tryParse(planList[index].maximumAmount ?? '0') ?? 0;

    if (amount > maxLimit || amount < minLimit) {
      CustomSnackBar.error(errorList: [MyStrings.loanLimitMsg]);
      return;
    }

    submitLoading = true;
    update();
    log(planId);
    ResponseModel response = await loanRepo.submitLoanPlan(
      planId,
      amount.toString(),
      selectedAuthorizationMode,
    );
    if (response.statusCode == 200) {
      LoanPreviewResponseModel model =
          LoanPreviewResponseModel.fromJson(jsonDecode(response.responseJson));
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        Get.offAndToNamed(RouteHelper.loanConfirmScreen, arguments: model);
      } else {
        CustomSnackBar.error(
            errorList: model.message?.error ?? [MyStrings.requestFail]);
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    submitLoading = false;
    update();
  }

  String getDepositAmount(int index) {
    double totalInstallment =
        double.tryParse(planList[index].totalInstallment ?? '0') ?? 0;
    double perInstallment =
        double.tryParse(planList[index].perInstallment ?? '0') ?? 0;
    double depositAmount = totalInstallment * perInstallment;
    return Converter.formatNumber(depositAmount.toString(), precision: 2);
  }

  String getPreviousRoute() {
    String previousRoute = Get.previousRoute;
    if (previousRoute == RouteHelper.notificationScreen) {
      return RouteHelper.notificationScreen;
    } else {
      return RouteHelper.bottomNavScreen;
    }
  }
}
