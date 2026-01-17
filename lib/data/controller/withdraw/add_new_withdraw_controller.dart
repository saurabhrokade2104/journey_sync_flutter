import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/string_format_helper.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/data/model/authorization/authorization_response_model.dart';
import 'package:finovelapp/data/model/dynamic_form/form.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/data/model/profile/profile_response_model.dart';
import 'package:finovelapp/data/model/withdraw/withdraw_method_response_model.dart';
import 'package:finovelapp/data/model/withdraw/withdraw_request_response_model.dart';
import 'package:finovelapp/data/repo/account/profile_repo.dart';
import 'package:finovelapp/data/repo/withdraw/withdraw_repo.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';

class AddNewWithdrawController extends GetxController {
  WithdrawRepo repo;
  ProfileRepo profileRepo;
  AddNewWithdrawController({required this.repo, required this.profileRepo});
  //
  bool isLoading = true;
  List<WithdrawMethod> withdrawMethodList = [];
  String currency = '';

  TextEditingController amountController = TextEditingController();

  WithdrawMethod? withdrawMethod = WithdrawMethod();
  String withdrawLimit = '';
  String charge = '';
  String payableText = '';
  String conversionRate = '';
  String inLocal = '';

  List<FormModel> formList = [];
  List<String> authorizationList = [];
  String? selectedAuthorizationMode;
  String selectOne = MyStrings.selectOne;
  String trxId = '';

  //
  void changeAuthorizationMode(String? value) {
    if (value != null) {
      selectedAuthorizationMode = value;
      update();
    }
  }

  double rate = 1;
  double mainAmount = 0;
  setWithdrawMethod(WithdrawMethod? method) {
    withdrawMethod = method;
    withdrawLimit =
        '${MyStrings.depositLimit.tr}: ${Converter.formatNumber(method?.minLimit ?? '-1')} - ${Converter.formatNumber(method?.maxLimit?.toString() ?? '-1')} ${method?.currency}';
    charge =
        '${MyStrings.charge.tr}: ${Converter.formatNumber(method?.fixedCharge?.toString() ?? '0')} + ${Converter.formatNumber(method?.percentCharge?.toString() ?? '0')} %';
    update();

    String amt = amountController.text.toString();
    mainAmount = amt.isEmpty ? 0 : double.tryParse(amt) ?? 0;
    withdrawMethod = method;
    withdrawLimit =
        '${Converter.formatNumber(method?.minLimit?.toString() ?? '-1')} - ${Converter.formatNumber(method?.maxLimit?.toString() ?? '-1')} $currency';
    changeInfoWidgetValue(mainAmount);
    update();
  }

  void changeInfoWidgetValue(double amount) {
    mainAmount = amount;
    double percent = double.tryParse(withdrawMethod?.percentCharge ?? '0') ?? 0;
    double percentCharge = (amount * percent) / 100;
    double temCharge = double.tryParse(withdrawMethod?.fixedCharge ?? '0') ?? 0;
    double totalCharge = percentCharge + temCharge;
    charge = '${Converter.formatNumber('$totalCharge')} $currency';
    double payable = amount - totalCharge;
    payableText = '$payable $currency';

    rate = double.tryParse(withdrawMethod?.rate ?? '0') ?? 0;
    conversionRate = '1 $currency = $rate ${withdrawMethod?.currency ?? ''}';
    inLocal = Converter.formatNumber('${payable * rate}');
    update();
    return;
  }

  Future<void> loadDepositMethod() async {
    authorizationList = repo.apiClient.getAuthorizationList();
    changeAuthorizationMode(authorizationList[0]);

    currency = repo.apiClient.getCurrencyOrUsername();
    clearPreviousValue();
    WithdrawMethod method1 = WithdrawMethod(
        id: -1,
        name: MyStrings.selectOne,
        currency: "",
        minLimit: "0",
        maxLimit: "0",
        percentCharge: "",
        fixedCharge: "",
        rate: "");
    withdrawMethodList.insert(0, method1);
    setWithdrawMethod(withdrawMethodList[0]);

    isLoading = true;
    update();

    ResponseModel responseModel = await repo.getAllWithdrawMethod();

    if (responseModel.statusCode == 200) {
      WithdrawMethodResponseModel model = WithdrawMethodResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));

      if (model.status == 'success') {
        List<WithdrawMethod>? tempMethodList = model.data?.withdrawMethod;
        if (tempMethodList != null && tempMethodList.isNotEmpty) {
          withdrawMethodList.addAll(tempMethodList);
          log(tempMethodList.toString());
        } else {
          log('Empty withdraw method');
        }
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ?? [MyStrings.somethingWentWrong],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
  }

  bool submitLoading = false;
  Future<void> submitWithdrawRequest() async {
    String amount = amountController.text;
    String id = withdrawMethod?.id.toString() ?? '-1';

    if (amount.isEmpty) {
      CustomSnackBar.error(errorList: [
        '${MyStrings.please} ${MyStrings.enterAmount.toLowerCase()}'
      ]);
      return;
    }

    if (id == '-1') {
      CustomSnackBar.error(errorList: [
        '${MyStrings.please} ${MyStrings.selectAWallet.toLowerCase()}'
      ]);
      return;
    }

    if (authorizationList.length > 1 &&
        selectedAuthorizationMode?.toLowerCase() == MyStrings.selectOne) {
      CustomSnackBar.error(errorList: [MyStrings.selectAuthModeMsg]);
      return;
    }

    double amount1 = 0;
    double maxAmount = 0;
    try {
      amount1 = double.parse(amount);
      maxAmount = double.parse(withdrawMethod?.maxLimit ?? '0');
    } catch (e) {
      return;
    }
    if (maxAmount == 0 || amount1 == 0) {
      List<String> errorList = [MyStrings.invalidAmount];
      CustomSnackBar.error(errorList: errorList);
      return;
    }
    submitLoading = true;
    update();
    ResponseModel response = await repo.addWithdrawRequest(
        withdrawMethod?.id ?? -1, amount1, selectedAuthorizationMode);

    if (response.statusCode == 200) {
      WithdrawRequestResponseModel model =
          WithdrawRequestResponseModel.fromJson(
              jsonDecode(response.responseJson));

      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        String trxId = model.data?.trx ?? '';
        loadData(model);
        Get.toNamed(RouteHelper.withdrawConfirmScreenScreen, arguments: trxId);
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

  void loadData(WithdrawRequestResponseModel model) async {
    trxId = model.data?.trx ?? '';
    List<FormModel>? tList = model.data?.form?.list;
    log(model.data?.form?.list?.length.toString() ?? "empty");
    if (tList != null && tList.isNotEmpty) {
      formList.clear();
      for (var element in tList) {
        if (element.type == 'select') {
          bool? isEmpty = element.options?.isEmpty;
          bool empty = isEmpty ?? true;
          if (element.options != null && empty != true) {
            element.options?.insert(0, selectOne);
            element.selectedValue = element.options?.first;
            formList.add(element);
          }
        } else {
          formList.add(element);
        }
        log(formList.length.toString());
        print(formList);
      }
    }
    isLoading = false;
    update();
  }

  clearData() {
    formList.clear();
  }

  bool isShowRate() {
    if (rate > 1 &&
        currency.toLowerCase() != withdrawMethod?.currency?.toLowerCase()) {
      return true;
    } else {
      return false;
    }
  }

  void clearPreviousValue() {
    withdrawMethodList.clear();
    amountController.text = '';
    rate = 1;
    submitLoading = false;
    withdrawMethod = WithdrawMethod();
  }

  List<String> hasError() {
    List<String> errorList = [];
    for (var element in formList) {
      if (element.isRequired == 'required') {
        if (element.selectedValue == '' || element.selectedValue == selectOne) {
          errorList.add('${element.name} ${MyStrings.isRequired}');
        }
      }
    }
    return errorList;
  }

  String twoFactorCode = '';
  Future<void> submitConfirmWithdrawRequest() async {
    List<String> list = hasError();
    if (list.isNotEmpty) {
      CustomSnackBar.error(errorList: list);
      return;
    }

    submitLoading = true;
    update();
    log(trxId.toString());
    AuthorizationResponseModel model =
        await repo.confirmWithdrawRequest(trxId, formList, twoFactorCode);
    if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
      CustomSnackBar.success(
          successList: model.message?.success ?? [MyStrings.requestSuccess]);
      Get.close(1);
      Get.offAndToNamed(RouteHelper.withdrawScreen);
    } else {
      CustomSnackBar.error(
          errorList: model.message?.error ?? [MyStrings.requestFail]);
    }

    submitLoading = false;
    update();
  }

//todo: form functionality
  void changeSelectedValue(value, int index) {
    formList[index].selectedValue = value;
    update();
  }

  void changeSelectedRadioBtnValue(int listIndex, int selectedIndex) {
    formList[listIndex].selectedValue =
        formList[listIndex].options?[selectedIndex];
    update();
  }

  void changeSelectedCheckBoxValue(int listIndex, String value) {
    List<String> list = value.split('_');
    int index = int.parse(list[0]);
    bool status = list[1] == 'true' ? true : false;

    List<String>? selectedValue = formList[listIndex].cbSelected;

    if (selectedValue != null) {
      String? value = formList[listIndex].options?[index];
      if (status) {
        if (!selectedValue.contains(value)) {
          selectedValue.add(value!);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      } else {
        if (selectedValue.contains(value)) {
          selectedValue.removeWhere((element) => element == value);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      }
    } else {
      selectedValue = [];
      String? value = formList[listIndex].options?[index];
      if (status) {
        if (!selectedValue.contains(value)) {
          selectedValue.add(value!);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      } else {
        if (selectedValue.contains(value)) {
          selectedValue.removeWhere((element) => element == value);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      }
    }
  }

  void changeSelectedFile(File file, int index) {
    formList[index].file = file;
    update();
  }

  bool isTFAEnable = false;
  Future<void> checkTwoFactorStatus() async {
    ProfileResponseModel model = await profileRepo.loadProfileInfo();
    if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
      isTFAEnable = model.data?.user?.ts == '1' ? true : false;
    }
  }

  void pickFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx']);

    if (result == null) return;

    formList[index].file = File(result.files.single.path!);
    String fileName = result.files.single.name;
    formList[index].selectedValue = fileName;
    update();
    return;
  }
}
