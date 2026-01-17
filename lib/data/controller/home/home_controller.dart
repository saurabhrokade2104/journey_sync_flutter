import 'dart:convert';
import 'dart:developer';

import 'package:finovelapp/core/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/date_converter.dart';
import 'package:finovelapp/core/helper/string_format_helper.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/data/model/dashboard/dashboard_response_model.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/data/model/loan/running_loan_response.dart';
import 'package:finovelapp/data/repo/home/home_repo.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';

import '../../model/eligibility/eligibility_insert_model.dart';

class HomeController extends GetxController {
  HomeRepo repo;
  // MyLoanController myLoanController;
  HomeController({
    required this.repo,
  });

  bool isLoading = false;
  RxBool loading = false.obs;
  String username = "";
  String firstName = "";
  String email = "";
  String balance = "";
  String accountNumber = "";
  String accountName = "";
  String currency = "";
  String currencySymbol = "";
  String imagePath = "";
  //attention:  insights data only for Visor Loan
  String remainingLoanAmount = "";
  String runningLoan = "";
  String pendingLoan = "";
  String nextInstallmentAmount = "";
  String nextInstallmentDate = "";
  RxBool isKycVerified = false.obs;
  RxBool isBankVerified = false.obs;
  RxBool isUpiVerified = false.obs;
  RxBool runningLoanStatus = false.obs;


  List<LatestDebitsData> debitsLists = [];
  List<Widget> moduleList = [];
  List<RunningLoanModel> runningLoanList = [];

  Future<void> loadData() async {
    isLoading=true;
    update();

    moduleList = repo.apiClient.getModuleList();
    currency = repo.apiClient.getCurrencyOrUsername();
    currencySymbol = repo.apiClient.getCurrencyOrUsername(isSymbol: true);

    debitsLists.clear();

    ResponseModel responseModel = await repo.getData();
    if (responseModel.statusCode == 200) {
      DashboardResponseModel model = DashboardResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));
      if (model.status.toString().toLowerCase() == 'success') {
        username = model.data?.user?.username ?? "";
      //  fullName = "${model.data?.user?.firstname ?? ""} ${model.data?.user?.lastname ?? ""}";
        firstName = model.data?.user?.firstname ?? "";
        email = model.data?.user?.email ?? "";
        accountNumber = model.data?.user?.accountNumber ?? "";
        imagePath = model.data?.user?.image ?? '';
        print('kyc status: ${model.data?.user?.kv}');
        isKycVerified.value = model.data?.user?.kv == '0' ? false : true;
        debugPrint('isBankVerified: ${ model.data?.user?.isBankVerified}');
        isBankVerified.value = model.data?.user?.isBankVerified ?? false ;
        isUpiVerified.value = model.data?.user?.isUpiVerified ?? false;

        balance = Converter.formatNumber(model.data?.user?.balance ?? "");
//note: this is insigments
        remainingLoanAmount =
            model.data?.insights?.nextInstallmentAmount.toString() ?? "0";
        runningLoan = model.data?.insights?.runningLoan ?? "_ _";

        pendingLoan = model.data?.insights?.pendingLoan ?? "_ _";
        nextInstallmentAmount = Converter.formatNumber(
            model.data?.insights?.nextInstallmentAmount ?? "_ _");
        nextInstallmentDate = DateConverter.isoStringToLocalDateOnly(
            model.data?.insights?.nextInstallmentDate ?? "_ _");

        // attention: runningLoan list
        List<RunningLoanModel>? temrunningLoan = model.data?.runningLoanList;

        runningLoanList.clear();
        if (temrunningLoan != null && temrunningLoan.isNotEmpty) {
          runningLoanList.addAll(temrunningLoan);
          log(runningLoanList.length.toString());
        } else {
          log("clearing runningLoan list");
        }
         checkRunningLoansStatus();
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ?? [MyStrings.somethingWentWrong],
        );
      }
    } else {
      if (responseModel.statusCode == 503) {
        changeNoInternetStatus(true);
      }
      CustomSnackBar.error(
        errorList: [responseModel.message],
      );
    }

    isLoading = false;
    update();
    await repo.refreshGeneralSetting();
    update();
  }

  void canCheckEligibility() async {
    isLoading = true;
    update();
    final response = await repo.canCheckEligibility();

    EligibilityInsertModel responseModel =
        EligibilityInsertModel.fromJson(jsonDecode(response.responseJson));

        // debugPrint('response log eligibility : ${responseModel.status}');

    if (responseModel.status?.toLowerCase() ==
        MyStrings.success.toLowerCase()) {
      isLoading = false;
      update();

      Get.toNamed(
        RouteHelper.eligibilityCheckForm,
        arguments: [false]

      );
    } else {
      isLoading = false;
      update();
      final eligibilityAmount = responseModel.data?.eligibility;
      final cibilScore = responseModel.data?.cibilscore;
      print('data : $cibilScore');

      if (eligibilityAmount == '0') {
        Get.toNamed(RouteHelper.creditScoreScreen,
            arguments: ['Rejected', cibilScore,true]);
      } else {
        Get.toNamed(RouteHelper.creditScoreScreen,
            arguments: [eligibilityAmount, cibilScore,true]);
      }
    }
  }

 RunningLoanModel? getLastApprovedLoan() {
    // Filter out only approved loans
    List<RunningLoanModel> approvedLoans = runningLoanList.where((loan) => loan.status == '1').toList();

    // Check if there are any approved loans
    if (approvedLoans.isNotEmpty) {
      // Return the last approved loan
      return approvedLoans.last;
    }
    // Return null if there are no approved loans
    return null;
  }


  Future<void> handleTransfer() async {
    // Set loading to true and immediately update UI
    loading.value = true;
    update(); // Ensure UI is notified of the change right away


    // Fetch the latest data
    await loadData();

    // Example business logic for loan approval
    final RunningLoanModel? lastApprovedLoan = getLastApprovedLoan();

    if (lastApprovedLoan != null) {
      final double creditLineAmount = double.tryParse(lastApprovedLoan.amount ?? "0") ?? 0.0;
      final double transferredAmount = double.tryParse(lastApprovedLoan.transferredAmount ?? "0") ?? 0.0;
      final double availableLimit = (creditLineAmount - transferredAmount).clamp(0.0, creditLineAmount);
      loading.value=false;

      // Navigate to the transfer screen with updated available limit
      Get.toNamed(RouteHelper.loanTransferScreen, arguments: [availableLimit.toInt()]);
    } else {
      // Handle no approved loan case
      CustomSnackBar.error(errorList: ["No approved loan available."]);
    }

    // After all operations, set loading to false and update UI
    loading.value = false;
    update(); // Ensure UI stops showing the loader
  }

  dynamic getStatusAndColor(int index, {isStatus = true}) {
    String status = runningLoanList[index].status ?? '';
    if (isStatus) {
      return status == '0'
          ? MyStrings.pending
          : status == '1'
              ? MyStrings.running
              : status == '2'
                  ? MyStrings.paid
                  : MyStrings.rejected;
    } else {
      return status == '0'
          ? MyColor.pendingColor
          : status == '1'
              ? MyColor.greenSuccessColor
              : status == '2'
                  ? MyColor.greenSuccessColor
                  : MyColor.redCancelTextColor;
    }
  }

  void checkRunningLoansStatus() {
    // Initially set to false to ensure we start with a clean state
    runningLoanStatus.value = false;

    // Loop through all running loans
    for (var loan in runningLoanList) {

        if (loan.status == '1') { // Assuming '1' means a running loan

            runningLoanStatus.value = true;
            break; // Exit the loop as we found at least one running loan
        }
    }

    print('runningLoanStatus: ${runningLoanStatus.value} ');

    // The value of runningLoanStatus will be updated accordingly
    // No need to explicitly call update() for reactive variables
}




  String getNeedToPayAmount(int index) {
    double totalInstallment = double.tryParse(
            runningLoanList[index].nextInstallment?.loan?.totalInstallment ??
                '0') ??
        0;
    double perInstallment =
        double.tryParse(runningLoanList[index].perInstallment ?? '0') ?? 0;
    double needToPay = totalInstallment * perInstallment;
    return Converter.formatNumber(needToPay.toString());
  }

  bool noInternet = false;
  void changeNoInternetStatus(bool status) {
    noInternet = status;
    update();
  }
}
