import 'dart:convert';
import 'package:finovelapp/core/helper/verhoeff_algorithm.dart';
import 'package:finovelapp/data/model/kyc_govt/aadhar_response_model.dart';
import 'package:finovelapp/data/model/authorization/authorization_response_model.dart';
import 'package:finovelapp/data/model/eligibility/eligibility_insert_model.dart';
import 'package:finovelapp/data/model/eligibility/eligibilityform_model.dart';
import 'package:finovelapp/data/model/kyc_govt/pan_response_model.dart';
import 'package:finovelapp/data/repo/eligibility/eligibility_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/shared_preference_helper.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/data/model/auth/registration_response_model.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';

import '../../../core/utils/url.dart';

class EligibilityCheckerController extends GetxController {
  EligibilityCheckerRepo eligibilityCheckerRepo;

  EligibilityCheckerController({required this.eligibilityCheckerRepo}) {
    // // Debug/demo values initialization
    // assert(() {
    //   isMale.value = true; // Assuming default gender as Male
    //   isMarried.value = false; // Assuming default marital status as Single
    //   dob.value = DateTime(1990, 1, 1); // Default Date of Birth
    //   dobController.text =
    //       DateFormat('yyyy-MM-dd').format(dob.value!); // Set formatted date
    //   spouseNameController.text = 'Jane Doe'; // Default Spouse Name
    //   noOfKidsController.text = '2'; // Default Number of Kids
    //   motherNameController.text = 'Mary Doe'; // Default Mother's Name
    //   currentQualificationSelection.value =
    //       "Bachelor's Degree"; // Default Qualification
    //   purposeOfLoanController.text =
    //       'Home Renovation'; // Default Purpose of Loan
    //   aadharNumberController.text = '123412341234'; // Default Aadhar Number
    //   panNumberController.text = 'ABCDE1234F'; // Default PAN Number
    //   fullNameController.text = 'John Doe'; // Default Full Name
    //   emailController.text = 'john.doe@example.com'; // Default Email
    //   phoneNumberController.text = '9876543210'; // Default Phone Number

    //   return true; // Return true to satisfy the assert condition
    // }());
  }

  var isMale = true.obs;
  var isMarried = false.obs;

  final RxBool isPrivacyAccepted = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController spouseNameController = TextEditingController();
  final TextEditingController noOfKidsController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();

  final TextEditingController purposeOfLoanController = TextEditingController();
  final TextEditingController aadharNumberController = TextEditingController();
  final TextEditingController aadharOtPController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final RxString currentPurposeSelection = "".obs;
  final RxString currentQualificationSelection = "".obs;
  var dob = Rxn<DateTime>(); // Date of Birth
  bool submitLoading = false;

  var refId = Rxn<String>(); // Reference ID for Aadhar OTP

  final TextEditingController otpController = TextEditingController();
  final TextEditingController emailOtpController = TextEditingController();

  // Make variables reactive by using GetX's .obs
  final RxBool isOtpFieldVisible = false.obs;
  final RxBool otpVerified = false.obs;
  RxString lastValidPhoneNumber = ''.obs;
  final RxBool isPhoneNumberValid = false.obs;
  bool isSendingOtp = false;
  bool isOtpVerifying = false;
  final RxString verificationStatus = "Not Verified".obs;

  // Using RxSet to keep track of verified phone numbers
  RxSet<String> verifiedPhoneNumbers = <String>{}.obs;

  // Add new properties for email verification
  RxBool isEmailValid = false.obs;
  RxBool isOtpSent = false.obs;
  RxSet<String> verifiedEmails = <String>{}.obs;
  bool isSendingEmailOtp = false;
  bool isEmailOtpVerifying = false;
  final RxBool emailOtpVerified = false.obs;
  final RxBool isEmailOtpFieldVisible = false.obs;
  RxString lastValidEmail = ''.obs;

  // Aaadhar field loading and verification

  final RxBool isAadharOtpFieldVisible = false.obs;
  final RxBool isAadharOtpSending = false.obs;
  final RxBool isAadharOtpVerifying = false.obs;
  final RxBool aadharOtpVerified = false.obs;
  final RxBool isAadharValid = false.obs;
  final Rxn<AadharData> aadharData = Rxn<AadharData>();

  // Pan field loading and verification

  final RxBool isPanVerifying = false.obs;
  final RxBool panVerified = false.obs;
  final RxBool isPanValid = false.obs;
  final Rxn<PanData> panData = Rxn<PanData>();

// authentication

  RxString accessToken = ''.obs;

  // dropdown onchange method

  void onChange(String? newValue, RxString currentSelection) {
    if (newValue != null) {
      currentSelection.value = newValue;
      // Update the UI or perform any additional logic here
      print("Selected value purpose: ${currentPurposeSelection.value}");
    }
  }

  // Utility method to normalize and format the full name
  String formatFullName(String fullName) {
    // Normalize and format the full name
    String normalizedFullName = fullName
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(' +'), ' '); // Replace multiple spaces with one

    // Capitalize the first letter of each word
    return normalizedFullName.split(' ').map((word) {
      return word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '';
    }).join(' ');
  }

  void checkAadharNumber(String value) {
    bool isValid = value.length == 12 &&
        RegExp(r'^\d{12}$').hasMatch(value) &&
        !RegExp(r'^0{12}$').hasMatch(value);
    isValid = isValid && Verhoeff.validate(value);
    isAadharValid.value = isValid;

    debugPrint('Checking Aadhar number: $value, isValid: $isValid');
  }

  void checkPanNumber(String value) {
    bool isValid = value.length == 10 &&
        RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value);
    isPanValid.value = isValid;
    update();
    // if (isValid) {
    //   verifyPanNumber();
    // }

    debugPrint('Checking PAN number: $value, isValid: $isValid');
  }

  void checkPhoneNumber(String value) {
    bool isValid = value.length == 10 && RegExp(r'^\d{10}$').hasMatch(value);
    isPhoneNumberValid.value = isValid;

    debugPrint('Checking phone number: $value, isValid: $isValid');

    if (isValid) {
      // If the number has been verified before
      if (verifiedPhoneNumbers.contains(value)) {
        otpVerified.value = true;
        isOtpFieldVisible.value = false;
        debugPrint('Phone number already verified.');
      } else {
        // New number or changed number
        if (lastValidPhoneNumber.value != value) {
          otpVerified.value = false;
          isOtpFieldVisible.value = false;
          lastValidPhoneNumber.value = value;
          debugPrint('New or changed phone number, reset verification state.');
        }
      }
    }
  }

  void checkEmail(String value) {
    bool isValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
    isEmailValid.value = isValid;
    debugPrint('Checking email: $value, isValid: $isValid');

    if (isValid) {
      // If the email has been verified before
      if (verifiedEmails.contains(value)) {
        emailOtpVerified.value = true;
        isEmailOtpFieldVisible.value = false;
        debugPrint('Email already verified.');
      } else {
        // New email or changed email
        if (lastValidEmail.value != value) {
          emailOtpVerified.value = false;
          isEmailOtpFieldVisible.value = false;
          lastValidEmail.value = value;
          debugPrint('New or changed email, reset verification state.');
        }
      }
    } else {
      emailOtpVerified.value = false;
      isEmailOtpFieldVisible.value = false;
    }
  }

  void sendOtp() async {
    isSendingOtp = true;
    update();

    // Simulate sending OTP
    await Future.delayed(Duration(seconds: 2));

    isSendingOtp = false;
    isOtpFieldVisible.value = true;
    update();
  }

  void resetValidation() {
    formKey.currentState?.reset();
  }

  void toggleSingleMarried(bool isMarriedSelected) {
    // Update the isMarried observable value with the new state
    isMarried.value = isMarriedSelected;
    update();

    // Call resetValidation() to reset any form validation
    // This is assuming resetValidation is a method that clears validation states
    resetValidation();
  }

  void updateDOB(DateTime newDOB) {
    dob.value = newDOB;
  }

  Future<void> authenticate() async {
    try {
      String token =
          await eligibilityCheckerRepo.authenticate(apiKey, apiSecret);
      debugPrint('Sandbox Token: $token');
      if (token.isNotEmpty) {
        accessToken.value = token;
      }
    } catch (e) {
      debugPrint('Error authenticating: $e');
      // CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong.tr]);
    }
  }

  Future<void> requestAadharOtp() async {
    try {
      isAadharOtpSending.value = true;
      update();

      var result = await eligibilityCheckerRepo.requestAadharOtp(
          aadharNumberController.text.trim(), accessToken.value);
      if (result != null && result is String) {
        // Assuming result is the refId when successful
        refId.value = result;
        isAadharOtpSending.value = false;
        isAadharOtpFieldVisible.value = true;
        update();
      } else {
        // Handle error response
        isAadharOtpSending.value = false;
        isAadharOtpFieldVisible.value = false;
        update();

        String errorMessage =
            result["message"] ?? MyStrings.somethingWentWrong.tr;
        debugPrint('Error in getting refId: $errorMessage');
        CustomSnackBar.error(
          errorList: [errorMessage],
        );
      }
    } catch (e) {
      isAadharOtpSending.value = false;
      isAadharOtpFieldVisible.value = false;
      update();

      CustomSnackBar.error(
        errorList: [MyStrings.somethingWentWrong.tr],
      );
      debugPrint('Exception in requesting Aadhar OTP: $e');
    }
  }

  Future<void> submitAadharOtp() async {
    try {
      isAadharOtpVerifying.value = true;
      update();

      final response = await eligibilityCheckerRepo.verifyAadharOtp(
          aadharOtPController.text.trim(), refId.value!, accessToken.value);
      final AadharResponse aadharResponse = AadharResponse.fromJson(response);

      if (aadharResponse.code == 200 && aadharResponse.data.status == "VALID") {
        // OTP verification successful
        // Update the UI or state accordingly
        aadharData.value = aadharResponse.data;

        aadharOtpVerified.value = true;
        isAadharOtpFieldVisible.value = false;
        isAadharOtpVerifying.value = false;
        update();

        CustomSnackBar.success(
            successList: ["Aadhaar verification successful."]);
      } else {
        // OTP verification failed or status invalid

        aadharOtpVerified.value = false;
        isAadharOtpFieldVisible.value = true;
        isAadharOtpVerifying.value = false;
        update();

        CustomSnackBar.error(errorList: ["Aadhaar verification failed."]);
      }
    } catch (e) {
      // Handle exceptions
      aadharOtpVerified.value = false;
      isAadharOtpFieldVisible.value = true;
      isAadharOtpVerifying.value = false;
      update();
      CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong.tr]);
      debugPrint('Exception in submitting Aadhar OTP: $e');
    }
  }

  // Function to format the date in the required "dd/MM/yyyy" format
String formatDOB(String dob) {
  try {
    // Assuming the input format is "dd-MM-yyyy" (e.g., 06-02-2002)
    final DateFormat inputFormat = DateFormat('dd-MM-yyyy');
    final DateFormat outputFormat = DateFormat('dd/MM/yyyy');

    // Parse the input date
    final DateTime parsedDate = inputFormat.parse(dob);

    // Format the date in the desired "dd/MM/yyyy" format
    return outputFormat.format(parsedDate);
  } catch (e) {
    debugPrint('Error formatting DOB: $e');
    // Return the original string in case of error (fallback)
    return dob;
  }
}

  Future<void> verifyPanNumber() async {
 // Check if full name is empty
  if (fullNameController.text.trim().isEmpty) {
    CustomSnackBar.error(
      errorList: [
        "Please enter your full name as per your PAN card before verification."
      ],
    );
    return;
  }

  // Check if date of birth is empty
  if (dobController.text.trim().isEmpty) {
    CustomSnackBar.error(
      errorList: ["Please select your date of birth before verification."],
    );
    return;
  }

  try {
    isPanVerifying.value = true;
    update();

    print('dob: ${ formatDOB(dobController.text)}');

    // Send PAN verification request
    final response = await eligibilityCheckerRepo.verifyPanNumber(
      panNumberController.text.trim(),
      accessToken.value,
      fullNameController.text.trim(),
      formatDOB(dobController.text), // Format the DOB before sending it
    );

    // Parse the API response using the new PanResponse model
    final PanResponse panResponse = PanResponse.fromJson(response);

    if (panResponse.code == 200 && panResponse.data.status.toLowerCase() == "valid") {
      // Normalize the full name for comparison
      String userFullNameNormalized = fullNameController.text
          .trim()
        .toLowerCase()
          .replaceAll(RegExp(' +'), ' ');

      debugPrint('Full Name from User: $userFullNameNormalized');

      bool isNameMatch = panResponse.data.nameAsPerPanMatch ?? false;
      bool isDobMatch = panResponse.data.dobMatch ?? false;

      // Check if both name and date of birth match, and if Aadhaar is linked
      if (isNameMatch && isDobMatch && panResponse.data.aadhaarSeedingStatus.toLowerCase() == "y") {
        // PAN verification successful
        panData.value = panResponse.data;
        panVerified.value = true;
        isPanVerifying.value = false;
        update();

        CustomSnackBar.success(successList: ["PAN verification successful."]);
      } else {
        // Handle mismatch
        panVerified.value = false;
        isPanVerifying.value = false;
        update();

        CustomSnackBar.error(errorList: [
          "PAN verification failed. Name or date of birth mismatch, or Aadhaar not linked."
        ]);
      }
    } else {
      // PAN verification failed or status invalid
      panVerified.value = false;
      isPanVerifying.value = false;
      update();

      String errorMessage = response["message"] ?? 'PAN verification failed.';
      debugPrint('Error in getting refId: $errorMessage');
      CustomSnackBar.error(errorList: [errorMessage]);
    }
  } catch (e) {
    // Handle exceptions
    panVerified.value = false;
    isPanVerifying.value = false;
    update();

    CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong.tr]);
    debugPrint('Exception in verifying PAN: $e');
  }
}


  bool verifyPreSubmissionCriteria() {
    return panVerified.value &&
        aadharOtpVerified.value &&
        otpVerified.value &&
        emailOtpVerified.value;
  }

  void submitEligibilityForm() async {
    if (formKey.currentState!.validate()) {
      if (isPrivacyAccepted.value) {
        formKey.currentState!.save();
        // Check all verification statuses
        if (!verifyPreSubmissionCriteria()) {
          // Show error message indicating which verifications are pending
          CustomSnackBar.error(
            errorList: [
              "Please verify all details before submitting the form.",
            ],
          );
          return;
        }
        submitLoading = true;
        update();

        EligibilityFormModel model = EligibilityFormModel(
          dob: dobController.text,
          spouseName: spouseNameController.text,
          noOfKids: noOfKidsController.text,
          motherName: motherNameController.text,
          qualification: currentQualificationSelection.value,
          purposeOfLoan: currentPurposeSelection.value,
          aadharNumber: aadharNumberController.text,
          panNumber: panNumberController.text,
          fullName: fullNameController.text,
          email: emailController.text,
          phoneNumber: phoneNumberController.text,
          isMale: isMale.value,
          isMarried: isMarried.value,
        );

        final response =
            await eligibilityCheckerRepo.submitEligibilityFormData(model);
        if (response.statusCode == 200) {
          EligibilityInsertModel responseModel =
              EligibilityInsertModel.fromJson(
                  jsonDecode(response.responseJson));
          if (responseModel.status?.toLowerCase() ==
              MyStrings.success.toLowerCase()) {
            final eligibilityAmount = responseModel.data?.eligibility;
            final cibilScore = responseModel.data?.cibilscore;
            print('data : $cibilScore');
            // Navigate to the next screen
            Get.offAndToNamed(RouteHelper.creditScoreScreen,
                arguments: [eligibilityAmount, cibilScore,true]);
          } else {
            CustomSnackBar.error(
                errorList: responseModel.message?.error ??
                    [MyStrings.somethingWentWrong.tr]);
          }
        } else {
          CustomSnackBar.error(errorList: [response.message]);
        }
        submitLoading = false;
        update();
      } else {
        // Show custom snackbar if privacy policy not accepted
        Get.snackbar(
          "Privacy Policy Required", // Title
          "Please accept the privacy policy to proceed.", // Message
          snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
          backgroundColor: Colors.red, // Background color
          colorText: Colors.white, // Text color
          duration: const Duration(seconds: 3), // Duration of the snackbar
        );
      }
    }
  }

  Future<void> sendOtpPhone() async {
    isSendingOtp = true;
    update();

    final response = await eligibilityCheckerRepo
        .sendOtpPhone('+91${phoneNumberController.text.trim()}');

    if (response.statusCode == 200) {
      print('response check : ${response.responseJson}');
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(response.responseJson));
      if (model.status.toString().toLowerCase() ==
          MyStrings.success.toLowerCase()) {
        verificationStatus.value = "OTP Sent";

        isOtpFieldVisible.value = true;
        isSendingOtp = false;

        update();
      } else {
        isSendingOtp = false;
        update();
        CustomSnackBar.error(
          errorList: model.message?.error ?? [MyStrings.somethingWentWrong],
        );
      }
    } else {
      isSendingOtp = false;
      update();

      CustomSnackBar.error(
        errorList: [MyStrings.somethingWentWrong],
      );
    }
  }

  Future<void> verifyOtpPhone() async {
    isOtpVerifying = true;
    update();

    final response = await eligibilityCheckerRepo.verifyOtpPhone(
        '+91${phoneNumberController.text.trim()}', otpController.text.trim());

    if (response.statusCode == 200) {
      print('response check : ${response.responseJson}');
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(response.responseJson));
      if (model.status.toString().toLowerCase() ==
          MyStrings.success.toLowerCase()) {
        verificationStatus.value = "Verified";
        isOtpFieldVisible.value = false;
        isOtpVerifying = false;
        otpVerified.value = true;
        verifiedPhoneNumbers.add(phoneNumberController.text.trim());
        update();
      } else {
        isOtpVerifying = false;
        otpVerified.value = false;
        update();

        CustomSnackBar.error(
          errorList: model.message?.error ?? [MyStrings.somethingWentWrong],
        );
      }
    } else {
      isSendingOtp = false;
      isOtpVerifying = false;
      otpVerified.value = false;
      update();

      CustomSnackBar.error(
        errorList: [MyStrings.somethingWentWrong],
      );
    }
  }

  Future<void> sendOtpEmail() async {
    isSendingEmailOtp = true;
    update();

    final response =
        await eligibilityCheckerRepo.sendOtpEmail(emailController.text.trim());

    if (response.statusCode == 200) {
      print('response check : ${response.responseJson}');
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(response.responseJson));
      if (model.status.toString().toLowerCase() ==
          MyStrings.success.toLowerCase()) {
        isSendingEmailOtp = false;
        isOtpSent.value = true;
        isEmailOtpFieldVisible.value = true;

        update();
      } else {
        isSendingEmailOtp = false;
        isOtpSent.value = false;
        isEmailOtpFieldVisible.value = false;
        update();
        CustomSnackBar.error(
          errorList: model.message?.error ?? [MyStrings.somethingWentWrong],
        );
      }
    } else {
      isOtpSent.value = false;
      isSendingEmailOtp = false;
      isEmailOtpFieldVisible.value = true;
      update();

      CustomSnackBar.error(
        errorList: [MyStrings.somethingWentWrong],
      );
    }
  }

  Future<void> verifyOtpEmail() async {
    isOtpVerifying = true;
    update();

    final response = await eligibilityCheckerRepo.verifyOtpEmail(
        emailController.text.trim(), emailOtpController.text.trim());

    if (response.statusCode == 200) {
      print('response check : ${response.responseJson}');
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(response.responseJson));
      if (model.status.toString().toLowerCase() ==
          MyStrings.success.toLowerCase()) {
        isEmailOtpFieldVisible.value = false;
        isEmailOtpVerifying = false;
        emailOtpVerified.value = true;
        verifiedEmails.add(emailController.text.trim());
        update();
      } else {
        isEmailOtpVerifying = false;
        emailOtpVerified.value = false;
        update();
        CustomSnackBar.error(
          errorList: model.message?.error ?? [MyStrings.somethingWentWrong],
        );
      }
    } else {
      isEmailOtpVerifying = false;
      emailOtpVerified.value = false;
      update();
      CustomSnackBar.error(
        errorList: [MyStrings.somethingWentWrong],
      );
    }
  }

  void checkAndGotoNextStep(RegistrationResponseModel responseModel) async {
    bool needEmailVerification =
        responseModel.data?.user?.ev == "1" ? false : true;
    bool needSmsVerification =
        responseModel.data?.user?.sv == "1" ? false : true;

    SharedPreferences preferences =
        eligibilityCheckerRepo.apiClient.sharedPreferences;

    // await preferences
    //     .setBool(SharedPreferenceHelper.rememberMeKey, true);

    await preferences.setString(SharedPreferenceHelper.userIdKey,
        responseModel.data?.user?.id.toString() ?? '-1');
    await preferences.setString(SharedPreferenceHelper.accessTokenKey,
        responseModel.data?.accessToken ?? '');
    await preferences.setString(SharedPreferenceHelper.accessTokenType,
        responseModel.data?.tokenType ?? '');
    await preferences.setString(SharedPreferenceHelper.userEmailKey,
        responseModel.data?.user?.email ?? '');
    await preferences.setString(SharedPreferenceHelper.userNameKey,
        responseModel.data?.user?.username ?? '');
    await preferences.setString(SharedPreferenceHelper.userPhoneNumberKey,
        responseModel.data?.user?.mobile ?? '');

    bool isProfileCompleteEnable = true;
    bool isTwoFactorEnable = false;

    if (needEmailVerification == false && needSmsVerification == false) {
      Get.offAndToNamed(RouteHelper.profileCompleteScreen);
    } else if (needEmailVerification == true && needSmsVerification == true) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen,
          arguments: [true, isProfileCompleteEnable, isTwoFactorEnable,responseModel.data?.user?.email, responseModel.data?.user?.mobile]);
    } else if (needEmailVerification) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen,
          arguments: [false, isProfileCompleteEnable, isTwoFactorEnable,responseModel.data?.user?.email, responseModel.data?.user?.mobile]);
    } else if (needSmsVerification) {
      Get.offAndToNamed(RouteHelper.smsVerificationScreen,
          arguments: [isProfileCompleteEnable, isTwoFactorEnable,responseModel.data?.user?.mobile]);
    } else {
      Get.offAndToNamed(RouteHelper.permissonScreen);
    }
  }

  void closeAllController() {
    submitLoading = false;
    emailController.text = '';
    phoneNumberController.text = '';
    fullNameController.text = '';
    aadharNumberController.text = '';
    panNumberController.text = '';

    dobController.text = '';
    spouseNameController.text = '';
    noOfKidsController.text = '';
    motherNameController.text = '';
    purposeOfLoanController.text = '';

    update();
  }

  clearAllData() {
    closeAllController();
  }

  bool noInternet = false;
}
