import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/string_format_helper.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/data/model/loan/myloan_list_response.dart';
import 'package:finovelapp/data/repo/loan/loan_repo.dart';

import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';

class MyLoanController extends GetxController {
  LoanRepo loanRepo;
  MyLoanController({required this.loanRepo});
  //data variables
  bool isLoading = false;
  int page = 0;
  String nextPageUrl = "";
  String currency = "";
  String currencySymbol = "";
  String selectedStatus = "999";
  String trxSearchText = '';
  TextEditingController srcController = TextEditingController();

  //note: this is main my loan list

  List<MyLoan> myLoanList = [];

  List<Map<String, String>> loanStatus = [
    {
      "name": "All",
      "value": "999",
    },
    {
      "name": "Pending",
      "value": "0",
    },
    {
      "name": "Running",
      "value": "1",
    },
    {
      "name": "Paid",
      "value": "2",
    },
    {
      "name": "Rejected",
      "value": "3",
    },
  ];

  void changeSelectedStatus(String value) async {
    isLoading = false;
    String trxSearchText = '';
    myLoanList.clear();

    selectedStatus = value;
    page = 1;
    isLoading = true;
    update();
    await getMyLoanList();
    isLoading = false;
    update();
  }

  void initialSelectedValue() async {
    currency = loanRepo.apiClient.getCurrencyOrUsername();
    currencySymbol = loanRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    page = 1;
    selectedStatus = "999";
    myLoanList.clear();
    srcController.clear();
    isLoading = true;
    update();
    await getMyLoanList();
    isLoading = false;
    update();
  }

  Future<void> loadPaginationData() async {
    page = page + 1;
    await getMyLoanList();
    update();
  }

  bool hasNext() {
    return nextPageUrl.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }

  Future<void> getMyLoanList() async {
    ResponseModel responseModel = await loanRepo.getMyLoanList(page, selectedStatus, trxSearchText);
    if(page==1) myLoanList.clear();
    if (responseModel.statusCode == 200) {
      MyLoanListResponseModel model = MyLoanListResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      nextPageUrl = model.data?.loans?.nextPageUrl ?? "null";

      if (model.status.toString().toLowerCase() == "success") {
        List<MyLoan>? tempMyList = model.data?.loans?.data;
        if (tempMyList != null && tempMyList.isNotEmpty) {
          myLoanList.addAll(tempMyList);
        }
      } else {
        CustomSnackBar.error(
            errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(
        errorList: [responseModel.message],
      );
    }
  }

  dynamic getStatusAndColor(int index, {isStatus = true}) {
    String status = myLoanList[index].status ?? '';
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

  String getNeedToPayAmount(int index) {
    double totalInstallment = double.tryParse(myLoanList[index].totalInstallment ?? '0') ?? 0;
    double perInstallment = double.tryParse(myLoanList[index].perInstallment ?? '0') ?? 0;
    double needToPay = totalInstallment * perInstallment;
    return Converter.formatNumber(needToPay.toString());
  }

  bool isSearch = false;
  void changeSearchIcon() {
    isSearch = !isSearch;
    update();
    if (!isSearch) {
      initialSelectedValue();
    }
  }

  bool filterLoading = false;
  Future<void> filterData() async {
    trxSearchText = srcController.text;
    page = 0;
    filterLoading = true;
    myLoanList.clear();
    if(trxSearchText.isNotEmpty){
      changeSelectedStatus('999');
    }
    update();

    await getMyLoanList();
    srcController.text = '';
    filterLoading = false;
    update();
  }
}
