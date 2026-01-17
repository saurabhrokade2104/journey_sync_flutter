import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/string_format_helper.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/data/model/authorization/authorization_response_model.dart';
import 'package:finovelapp/data/model/dynamic_form/form.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/data/model/loan/loan_preview_response_model.dart';
import 'package:finovelapp/data/repo/loan/loan_repo.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';

class LoanConfirmController extends GetxController {
  LoanRepo repo;
  LoanConfirmController({required this.repo});

  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(); // Global form key
  final GlobalKey<FormState> personalFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> contactFormKey =
      GlobalKey<FormState>(); // Assuming contact details step needs validation
  final GlobalKey<FormState> bankFormKey = GlobalKey<FormState>();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController spouseNameController = TextEditingController();
  final TextEditingController noOfKidsController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController qualificationController =
      TextEditingController();
  final TextEditingController purposeOfLoanController =
      TextEditingController();
  TextEditingController aadharNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  DateTime? dob; // Date of Birth
  bool isBank = true;
  bool isSavingAccount = true;
  String? accountHolderName; // New state variable to hold account holder's name
  Timer? debounce; // Timer for debounce

  // final TextEditingController bankNameController = TextEditingController(text: 'HDFC BANK');
  final TextEditingController bankNameController = TextEditingController();
  // final TextEditingController ifscCodeController = TextEditingController(text: 'HDFC0005819');
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController confirmAccountNumberController =
      TextEditingController();
  final TextEditingController upiIdController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

   final TextEditingController currentAddressController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController tehsilController = TextEditingController();
  final TextEditingController cityDistrictController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController permanentAddressController = TextEditingController();
  final TextEditingController permanentLocalityController = TextEditingController();
  final TextEditingController permanentLandmarkController = TextEditingController();
  final TextEditingController permanentTehsilController = TextEditingController();
  final TextEditingController permanentCityDistrictController = TextEditingController();
  final TextEditingController permanentStateController = TextEditingController();
  final TextEditingController permanentPincodeController = TextEditingController();
  int currentStep = 1; // Moved inside the class

  bool isMale = false;
  bool isMarried = true;
  String gender = 'Male';

  bool agreeToTerms = false;
  bool otpRequested = false;
  DateTime? lastOtpRequestTime;
  String? selfieImagePath;
  String? panCardImagePath;
  String? aadharCardFrontImagePath;
  String? aadharCardBackImagePath;

  String formattedAadharData = '';
  String formattedPanData = '';
  File? aadharPhoto;
  String? aadharPhotoLink;

  String? refId;
  String enteredOtp = '';



  bool isLoading = false;
  List<FormModel> formList = [];
  String selectOne = MyStrings.selectOne;
  String otpId = '';

  String planId = '';
  String amount = '';

  String planName = '';
  String totalInstallment = '';
  String perInstallment = '';
  String youNeedToPay = '';
  String chargeText = '';
  String applicationFee = '';

  String currencySymbol = '';



  loadData(LoanPreviewResponseModel model) async {
    currencySymbol = repo.apiClient.getCurrencyOrUsername(isSymbol: true);
    setStatusTrue();
    planId = model.data?.plan?.id.toString() ?? '';
    amount = Converter.formatNumber(model.data?.amount ?? '');
    planName = model.data?.plan?.name ?? '';
    totalInstallment = model.data?.plan?.totalInstallment ?? '';
    perInstallment = model.data?.plan?.perInstallment ?? '';
    perInstallment = (((double.tryParse(amount) ?? 0) *
                (double.tryParse(perInstallment) ?? 0)) /
            100)
        .toString();
    youNeedToPay = Converter.mul(totalInstallment, perInstallment);
    String delayCharge = model.data?.delayCharge.toString() ?? '0';
    applicationFee = Converter.formatNumber(model.data?.applicationFee ?? '');
    chargeText =
        '${MyStrings.ifAnInstallmentIsDelayedFor} ${model.data?.plan?.delayValue} ${MyStrings.orMoreDaysThen} $currencySymbol$delayCharge ${MyStrings.willBeAppliedForEachDay}'
            .tr;

    List<FormModel>? tList = model.data?.plan?.form?.formData?.list;
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
      }
    }
    setStatusFalse();
  }

  clearData() {
    formList.clear();
  }

  String twoFactorCode = '';
  bool submitLoading = false;





  Future<void> submitConfirmWithdrawRequest() async {
    isLoading = true;
    List<String> list = hasError();
    if (list.isNotEmpty) {
      CustomSnackBar.error(errorList: list);
      return;
    }

    submitLoading = true;
    update();

    ResponseModel response =
        await repo.confirmLoanRequest(planId, amount, formList, twoFactorCode);
    if (response.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(response.responseJson));
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        Get.offAndToNamed(RouteHelper.bottomNavScreen, arguments: 'loan-list');
        CustomSnackBar.success(
            successList: model.message?.success ?? [MyStrings.requestSuccess]);
      } else {
        CustomSnackBar.error(
            errorList: model.message?.error ?? [MyStrings.requestFail]);
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    submitLoading = false;
    isLoading = false;
    update();
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

  setStatusTrue() {
    isLoading = true;
    update();
  }

  setStatusFalse() {
    isLoading = false;
    update();
  }

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
