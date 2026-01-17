import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/data/controller/bank/bank_detail_controller.dart';
import 'package:finovelapp/data/controller/kyc_controller/kyc_controller.dart';
import 'package:finovelapp/data/model/authorization/authorization_response_model.dart';
import 'package:finovelapp/data/model/bank/bank_detail.dart';
import 'package:finovelapp/data/model/eligibility/eligibility_data_model.dart';
import 'package:finovelapp/data/repo/loan/loan_repo.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/bnpl/loan_apply_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/shared_preference_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/data/model/auth/registration_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';

class LoanApplyController extends GetxController {
  LoanRepo loanRepo;
  final KycController kycController = Get.find();
  final BankDetailsController bankDetailsController = Get.find();

  LoanApplyController({required this.loanRepo}) {
    // Debug/demo values initialization
    assert(() {
      // Initialize controllers with debug values
      dobController.text = '1985-08-15'; // Example DOB
      dob = Rxn<DateTime>(DateTime(2000, 2, 7));
      spouseNameController.text = 'Jane Doe'; // Example spouse name
      noOfKidsController.text = '2'; // Example number of kids
      motherNameController.text = 'Ella Smith'; // Example mother's name

      purposeOfLoanController.text =
          'Home Renovation'; // Example purpose of loan
      aadharNumberController.text = '123456789101'; // Example Aadhar number
      panNumberController.text = 'ABCDE1234F'; // Example PAN number
      fullNameController.text = 'John Doe'; // Example full name
      emailController.text = 'john.doe@example.com'; // Example email
      phoneNumberController.text = '9876543210'; // Example phone number
      bankNameController.text = 'KOTAK MAHINDRA BANK'; // Example bank name
      ifscCodeController.text = 'KKBK0004622'; // Example IFSC code
      accountHolderNameController.text =
          'Ankit Kumar'; // Example account holder name
      accountNumberController.text = '3945215782'; // Example account number
      confirmAccountNumberController.text =
          '3945215782'; // Example confirm account number
      upiIdController.text = 'johndoe@upi'; // Example UPI ID
      mobileNumberController.text = '9876543210'; // Example mobile number

      currentAddressController.text = "123, Main Street";
      localityController.text = "Greenwood Locality";
      landmarkController.text = "Near City Mall";

      cityDistrictController.text = "Springfield";
      stateController.text = "Stateville";
      pincodeController.text = "123456";
      permanentAddressController.text = "123, Main Street";
      permanentLocalityController.text = "Greenwood Locality";
      permanentLandmarkController.text = "Near City Mall";

      permanentCityDistrictController.text = "Springfield";
      permanentStateController.text = "Stateville";
      permanentPincodeController.text = "123456";
      // Adding debug values for employment-related fields
      employmentTypeSelection.value = 'Salaried'; // Example employment type
      employerNameController.text = 'Tech Solutions'; // Example employer name
      officialEmailController.text =
          'john.doe@techsolutions.com'; // Example official email
      workingSinceController.text = '2015-06-01'; // Example working since date
      netMonthlySalaryController.text = '50000'; // Example net monthly salary
      salaryReceivedTypeSelection.value =
          'Bank Transfer'; // Example salary received type
      // jobFunctionController.text =
      //     'Software Development'; // Example job function
      // designationController.text = 'Senior Developer'; // Example designation

      employeeIDController.text = 'EMP123456'; // Example employee ID
      uanNumberController.text = '100234567890'; // Example UAN number
      // Set other debug variables as needed
      return true; // Return true to satisfy the assert condition
    }());
  }

  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(); // Global form key
  final GlobalKey<FormState> personalFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> employmentFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> contactFormKey =
      GlobalKey<FormState>(); // Assuming contact details step needs validation
  final GlobalKey<FormState> bankFormKey = GlobalKey<FormState>();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController spouseNameController = TextEditingController();
  final TextEditingController noOfKidsController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController purposeOfLoanController = TextEditingController();
  TextEditingController aadharNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  var dob = Rxn<DateTime>(); // Date of Birth reactive variable
  RxBool isBank = true.obs;
  RxBool isSavingAccount = true.obs;
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

  final TextEditingController currentAddressController =
      TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityDistrictController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController permanentAddressController =
      TextEditingController();
  final TextEditingController permanentLocalityController =
      TextEditingController();
  final TextEditingController permanentLandmarkController =
      TextEditingController();
  final TextEditingController permanentCityDistrictController =
      TextEditingController();
  final TextEditingController permanentStateController =
      TextEditingController();
  final TextEditingController permanentPincodeController =
      TextEditingController();

  final TextEditingController employerNameController = TextEditingController();
  final TextEditingController officialEmailController = TextEditingController();
  final TextEditingController workingSinceController = TextEditingController();
  TextEditingController netMonthlySalaryController = TextEditingController();
  // TextEditingController jobFunctionController = TextEditingController();
  // TextEditingController designationController = TextEditingController();
RxString jobFunctionSelection = 'Management'.obs;
  RxString designationSelection = 'Consultant'.obs;


  TextEditingController employeeIDController = TextEditingController();
  TextEditingController uanNumberController = TextEditingController();

  RxInt currentStep = 1.obs; // Moved inside the class

  RxBool isMale = true.obs;
  RxBool isMarried = false.obs;

  String gender = 'Male';

  bool agreeToTerms = false;

  bool otpRequested = false;
  DateTime? lastOtpRequestTime;
  RxString selfieImagePath = ''.obs;
  RxString panCardImagePath = ''.obs;
  RxString aadharCardFrontImagePath = ''.obs;
  RxString aadharCardBackImagePath = ''.obs;

  RxString formattedAadharData = ''.obs;
  RxString formattedPanData = ''.obs;
  File? aadharPhoto;
  RxString aadharPhotoLink = ''.obs;

  RxInt eligibilityAmount = 0.obs;
  RxString creditScore = ''.obs;
  RxString bankBranch = ''.obs;

  String? refId;
  String enteredOtp = '';

  RxBool isLoading = false.obs;
  RxBool isSameAsCurrentAddress = false.obs;

  RxString currentPurposeSelection = "".obs;
  RxString currentQualificationSelection = "".obs;
  RxString employmentTypeSelection = "".obs;
  RxString salaryReceivedTypeSelection = "".obs;

  String selectedState = 'Select State';
  final List<String> states = [
    'Select State',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  bool submitLoading = false;

  void onChange(String? newValue, RxString currentSelection) {
    if (newValue != null) {
      currentSelection.value = newValue;
      // Update the UI or perform any additional logic here
      print("Selected value purpose: ${currentPurposeSelection.value}");
    }
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

  // Method to handle step validations and progression
  void handleStepProgression() async {
    print('[Loan Application] Current step: ${currentStep.value}');
    bool isCurrentStepValid = false;

    try {
      switch (currentStep.value) {
        case 1:
          print('[Loan Application] Validating personal details.');
          isCurrentStepValid =
              personalFormKey.currentState?.validate() ?? false;
          break;
        case 2:
          print('[Loan Application] Validating contact details.');
          isCurrentStepValid = contactFormKey.currentState?.validate() ?? false;
          break;

        case 3:
          print('[Loan Application] Validating employment details.');
          isCurrentStepValid =
              employmentFormKey.currentState?.validate() ?? false;
          break;

        case 4:
          print('[Loan Application] Validating document uploads.');
          isCurrentStepValid = validateDocumentUploads();
          break;

        case 5:
          print('[Loan Application] Validating bank details.');
          isCurrentStepValid = bankFormKey.currentState?.validate() ?? false;
          break;

        default:
          print('[Loan Application] Invalid step encountered.');
          break;
      }

      if (isCurrentStepValid) {
        print('[Loan Application] Step $currentStep is valid. Proceeding.');
        if (currentStep.value < 5) {
          currentStep.value++;
          print('[Loan Application] Moving to step ${currentStep.value}.');
        } else {
          print('[Loan Application] Final step completed. Applying for loan.');
          await applyShortLoan();
        }
      } else {
        print(
            '[Loan Application] Validation failed for step ${currentStep.value}.');
        // Consider displaying an error message or handling the error state
      }
    } catch (e) {
      print('[Loan Application] Exception during step progression: $e');
      // Handle exceptions, e.g., show a user-friendly error message
    }
  }

  Future<bool> submitKycData() async {
    // Prepare your KYC data map
    Map<String, dynamic> kycData = {
      "full_name": fullNameController.text,
      "aadhar_number": aadharNumberController.text,
      "pan_number": panNumberController.text,
      "date_of_birth": dob,
      "gender": gender,
      "email": emailController.text,
      "phone_number": phoneNumberController.text,
      "pan_data": {
        "pan_number": panNumberController.text,
        // "pan_data": formattedPanData,
      },
      "aadhar_data": {
        "aadhar_number": aadharNumberController.text,
        // "aadhar_data": formattedAadharData,
      },
    };
    // add aadhar photo if available
    if (aadharCardFrontImagePath.value.isNotEmpty) {
      kycData['aadhar_photo'] = File(aadharCardFrontImagePath.value);
    }
    // add selfie photo if available
    if (selfieImagePath.value.isNotEmpty) {
      kycData['user_selfie'] = File(selfieImagePath.value);
    }

    // Submit through the KYC controller
    final kycSuccess = await kycController.submitKycData(kycData);
    return kycSuccess;
  }

  Future<bool> submitBankDetailData() async {
    // Create an instance of BankDetail
    BankDetails bankDetail = BankDetails(
      bankName: bankNameController.text,
      ifscCode: ifscCodeController.text,
      accountHolderName: accountHolderNameController.text,
      accountNumber: accountNumberController.text,
      confirmAccountNumber: confirmAccountNumberController.text,
      bankAccountType: isSavingAccount.value ? "saving" : "current",
    );

    // Submit through the Bank Details controller
    final bankDetailSuccess = await bankDetailsController
        .submitBankDetails(bankDetail, navigate: false);
    return bankDetailSuccess;
  }

  Future<bool> submitUpiDetails() async {
    // Submit through the Upi Details controller
    final upiDetailSuccess = await bankDetailsController
        .submitUpiDetails(upiIdController.text.trim(), navigate: false);
    return upiDetailSuccess;
  }

  void handleSubmissionError(String message) {
    isLoading.value = false;
    CustomSnackBar.error(errorList: [message]);
    update();
  }

  Future<void> applyShortLoan() async {
    print('[Loan Application] Initiating short loan application.');

    try {
      isLoading.value = true;
      update();

      // Step 1: Submit KYC Data
      bool kycSuccess = await submitKycData();
      if (!kycSuccess) {
        handleSubmissionError("Failed to submit KYC data.");
        return;
      }

      // Step 2: Submit Bank Detail Data
      bool bankDetailSuccess = await submitBankDetailData();
      if (!bankDetailSuccess) {
        handleSubmissionError("Failed to submit bank details.");
        return;
      }
      if (upiIdController.text.isNotEmpty) {
        // Step 3: Submit UPI Details
        bool upiDetailSuccess = await submitUpiDetails();
        if (!upiDetailSuccess) {
          handleSubmissionError("Failed to submit UPI details.");
          return;
        }
      }

      // Gather form data
      Map<String, dynamic> formData = gatherFormData();

      String planId = "2"; // Example plan ID
      String twoFactorCode = "123456"; // Example 2FA code

      print(
          '[Loan Application] Submitting BNPL loan application with plan ID: $planId');

      var response = await loanRepo.submitBnplLoanApplication(
          planId, eligibilityAmount.toString(), formData, twoFactorCode);

      if (response.status?.toLowerCase() == "success") {
        print('[Loan Application] Loan application successful.');
        // CustomSnackBar.success(successList: response.message?.success ?? ["Success"]);
        Get.offAndToNamed(RouteHelper.enachRegisterScreen);
        // Only navigate on successful completion of operations
      } else {
        print('[Loan Application] Loan application failed.');
        CustomSnackBar.error(
            errorList: response.message?.error ?? ["Request failed"]);
      }
    } catch (e) {
      print('[Loan Application] Exception during loan application: $e');
      // Consider displaying an error message or handling the error state
    } finally {
      isLoading.value = false;
      update();
      print('[Loan Application] Loan application process completed.');
    }
  }

  Map<String, dynamic> gatherFormData() {
    Map<String, dynamic> formData = {
      "full_name": fullNameController.text,
      "aadhar_number": aadharNumberController.text,
      "pan_number": panNumberController.text,
      "date_of_birth": dob.value?.toIso8601String() ?? '',
      "gender": gender,
      "email": emailController.text,
      "phone_number": phoneNumberController.text,
      "credit_score": creditScore.value,
      "payment_history": "Good",
      "loan_inquiries": "2",
      "total_obligations": "30000",
      "contact_references": "Kunal Doe; Vivek Doe",
      "age_limit": "30",
      "current_address": currentAddressController.text,
      "locality_village_current": localityController.text,
      "near_landmark_current": landmarkController.text,

      "city_district_current": cityDistrictController.text,
      "state_current": stateController.text,
      "pin_code_current": pincodeController.text,
      "permanent_address": permanentAddressController.text,
      "locality_village_permanent": permanentLocalityController.text,
      "near_landmark_permanent": permanentLandmarkController.text,
      "city_district_permanent": permanentCityDistrictController.text,
      "state_permanent": permanentStateController.text,
      "pin_code_permanent": permanentPincodeController.text,
      "employment_type": employmentTypeSelection.value,
      "employer_name": employerNameController.text,
      "official_email": officialEmailController.text,
      "working_since": workingSinceController.text,
      "net_monthly_salary": netMonthlySalaryController.text,
      "salary_received_type": salaryReceivedTypeSelection.value,
      "job_function": jobFunctionSelection.value,
      "designation": jobFunctionSelection.value,
      // "work_sector": workSectorController.text,
      "employee_id": employeeIDController.text,
      "uan_number": uanNumberController.text,

      // Add files below
    };

    // Handle file fields separately to attach them correctly
    attachFilesToFormData(formData);

    return formData;
  }

  void attachFilesToFormData(Map<String, dynamic> formData) {
    if (selfieImagePath.value.isNotEmpty) {
      formData["selfie_image"] = File(selfieImagePath.value);
      print('[Loan Application] Selfie image attached.');
    }
    if (panCardImagePath.value.isNotEmpty) {
      formData["pan_card"] = File(panCardImagePath.value);
      print('[Loan Application] PAN card image attached.');
    }
    if (aadharCardFrontImagePath.value.isNotEmpty) {
      formData["aadhar_photo_front"] = File(aadharCardFrontImagePath.value);
      formData["residential_proof"] = File(aadharCardFrontImagePath.value);
      print('[Loan Application] Aadhar front image attached.');
    }
    if (aadharCardBackImagePath.value.isNotEmpty) {
      formData["aadhar_photo_back"] = File(aadharCardBackImagePath.value);
      print('[Loan Application] Aadhar back image attached.');
    }
  }

  Future<void> captureDocumentImage(DocumentType documentType) async {
  try {
    final ImageSource source = kReleaseMode
        ? (documentType == DocumentType.selfie ? ImageSource.camera : ImageSource.gallery)
        : ImageSource.gallery;

    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      switch (documentType) {
        case DocumentType.selfie:
          selfieImagePath.value = pickedFile.path;
          break;
        case DocumentType.pan:
          panCardImagePath.value = pickedFile.path;
          break;
        case DocumentType.aadharFront:
          aadharCardFrontImagePath.value = pickedFile.path;
          break;
        case DocumentType.aadharBack:
          aadharCardBackImagePath.value = pickedFile.path;
          break;
      }
    }
  } catch (e) {
    CustomSnackBar.error(errorList: ['Failed to capture image']);
  }
}

  // Method to fetch city and state from pincode
  Future<void> fetchCityAndStateFromPincode(String pincode) async {
    final String url =
        'https://india-pincode-with-latitude-and-longitude.p.rapidapi.com/api/v1/pincode/$pincode';
    final Map<String, String> headers = {
      'X-RapidAPI-Host':
          'india-pincode-with-latitude-and-longitude.p.rapidapi.com',
      'X-RapidAPI-Key': '35a1bdc619mshe0774f99498bfe5p1ff050jsnc9829dfcffcc',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          // Using the first result from the response
          cityDistrictController.text = data[0]['area'];
          stateController.text = data[0]['state'];
        }
      } else {
        // Handle non-200 responses
        print('Failed to fetch location data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors (e.g., network errors, parsing errors)
      print('Error fetching location data: $e');
    }
  }

  Future<void> fetchAndFillBankDetails(String ifscCode) async {
    final String url = 'https://ifsc.razorpay.com/$ifscCode';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['BANK'] != null) {
          bankNameController.text = data['BANK'];
          bankBranch.value = data['BRANCH'];
          // Optionally, you can fill other details if available and needed
        } else {
          // Handle the case where the IFSC code is valid but details are not found
          CustomSnackBar.error(errorList: [
            'Bank details not found for the provided IFSC code.'
          ]);
        }
      } else {
        // Handle incorrect IFSC code or other errors
        CustomSnackBar.error(
            errorList: ['Invalid IFSC code. Please check and try again.']);
      }
    } catch (e) {
      // Handle network errors or unexpected errors

      CustomSnackBar.error(errorList: [
        'Failed to fetch bank details. Please check your internet connection and try again.'
      ]);
    }
  }

  void toggleBankUPI(bool isBankSelected) {
    isBank.value = isBankSelected;
    isLoading.value = false;
    update();
    resetValidation(); // Reset the validation on toggle
  }

  void autoFillPermanentAddress() {
    if (currentAddressController.text.isNotEmpty &&
        localityController.text.isNotEmpty &&
        landmarkController.text.isNotEmpty &&
        cityDistrictController.text.isNotEmpty &&
        stateController.text.isNotEmpty &&
        pincodeController.text.isNotEmpty) {
      permanentAddressController.text = currentAddressController.text;
      permanentLocalityController.text = localityController.text;
      permanentLandmarkController.text = landmarkController.text;
      permanentCityDistrictController.text = cityDistrictController.text;
      permanentStateController.text = stateController.text;
      permanentPincodeController.text = pincodeController.text;
    } else {
      Get.snackbar(
        "Current Address Fields Required", // Title
        "Please fill in all current address fields first.", // Message
        snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
        backgroundColor: Colors.red, // Background color
        colorText: Colors.white, // Text color
        duration: const Duration(seconds: 3), // Duration of the snackbar
      );
      // Reset the checkbox to unchecked if there's an error
      isSameAsCurrentAddress.value = false;
    }
  }

  void retriveEligibilityFormUserData() async {
    isLoading.value = true;
    update();
    final response = await loanRepo.retrieveEligibilityFormData();

    EligibilityUserDataModel responseModel =
        EligibilityUserDataModel.fromJson(jsonDecode(response.responseJson));

    print('data check : ${responseModel.data}');

    if (responseModel.status?.toLowerCase() ==
        MyStrings.success.toLowerCase()) {
      var userData = responseModel.data;



      if (userData != null) {
      bool marriedcheck = (userData.maritalStatus?.toLowerCase() == 'married');
      print('married check : $marriedcheck ${userData.maritalStatus?.toLowerCase()} ');
        // Assigning fetched values to the controllers
        dobController.text = userData.dateOfBirth ?? '';
        dob.value = DateTime.tryParse(userData.dateOfBirth ?? '');
        spouseNameController.text = userData.spouseName ?? '';
        noOfKidsController.text = (userData.numberOfKids ?? '').toString();
        motherNameController.text = userData.motherName ?? '';
        currentQualificationSelection.value = userData.qualification ?? '';
        currentPurposeSelection.value = userData.purposeOfLoan ?? '';
        aadharNumberController.text = userData.aadharNumber ?? '';
        panNumberController.text = userData.panNumber ?? '';
        fullNameController.text = userData.fullName ?? '';
        emailController.text = userData.email ?? '';
        mobileNumberController.text = userData.mobileNumber ?? '';
        // Assuming gender, maritalStatus have corresponding methods or variables to be set
        isMale.value = (userData.gender?.toLowerCase() == 'male');
        isMarried.value = (userData.maritalStatus?.toLowerCase() == 'married');
        eligibilityAmount.value = userData.eligibilityAmount ?? 0;
        creditScore.value = userData.cibilscore.toString() ?? '';
        // Add any other fields you need to prefill here
      }

      isLoading.value = false;
      update();
    } else {
      isLoading.value = false;
      update();

      CustomSnackBar.error(
        errorList:
            responseModel.message?.error ?? [MyStrings.somethingWentWrong],
      );
    }
  }

  bool validateDocumentUploads() {
    if (selfieImagePath.value == '') {
      showSnackbar("Please capture/upload a selfie.");
      return false;
    }
    if (panCardImagePath.value == '') {
      showSnackbar("Please upload a PAN card.");
      return false;
    }
    if (aadharCardFrontImagePath.value == '') {
      showSnackbar("Please upload the front side of Aadhar card.");
      return false;
    }
    if (aadharCardBackImagePath.value == '') {
      showSnackbar("Please upload the back side of Aadhar card.");
      return false;
    }
    return true;
  }

  void showSnackbar(String message) {
    CustomSnackBar.error(errorList: [message]);
  }

  String? validateNonEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter valid $fieldName';
    }
    return null;
  }

  void updateDOB(DateTime newDOB) {
    dob.value = newDOB;
  }

  void updateWorkingSince(DateTime newDate) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(newDate);
    workingSinceController.text = formattedDate;
    update(); // Notify GetX of the update.
  }

  // void submitEligibilityForm() async {
  //   if (formKey.currentState!.validate()) {
  //     if (isPrivacyAccepted.value) {
  //       formKey.currentState!.save();
  //       submitLoading = true;
  //       update();

  //       EligibilityFormModel model = EligibilityFormModel(
  //         dob: dobController.text,
  //         spouseName: spouseNameController.text,
  //         noOfKids: noOfKidsController.text,
  //         motherName: motherNameController.text,
  //         qualification: qualificationController.text,
  //         purposeOfLoan: purposeOfLoanController.text,
  //         aadharNumber: aadharNumberController.text,
  //         panNumber: panNumberController.text,
  //         fullName: fullNameController.text,
  //         email: emailController.text,
  //         phoneNumber: phoneNumberController.text,
  //         isMale: isMale.value,
  //         isMarried: isMarried.value,
  //       );

  //       final response =
  //           await eligibilityCheckerRepo.submitEligibilityFormData(model);
  //       if (response.statusCode == 200) {
  //         EligibilityInsertModel responseModel =
  //             EligibilityInsertModel.fromJson(
  //                 jsonDecode(response.responseJson));
  //         if (responseModel.status?.toLowerCase() ==
  //             MyStrings.success.toLowerCase()) {
  //           final eligibilityAmount = responseModel.data?.eligibility;
  //           final cibilScore = responseModel.data?.cibilscore;
  //           print('data : $cibilScore');
  //           // Navigate to the next screen
  //           Get.offAndToNamed(RouteHelper.creditScoreScreen,
  //               arguments: [eligibilityAmount, cibilScore]);
  //         } else {
  //           CustomSnackBar.error(
  //               errorList: responseModel.message?.error ??
  //                   [MyStrings.somethingWentWrong.tr]);
  //         }
  //       } else {
  //         CustomSnackBar.error(errorList: [response.message]);
  //       }
  //       submitLoading = false;
  //       update();
  //     } else {
  //       // Show custom snackbar if privacy policy not accepted
  //       Get.snackbar(
  //         "Privacy Policy Required", // Title
  //         "Please accept the privacy policy to proceed.", // Message
  //         snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
  //         backgroundColor: Colors.red, // Background color
  //         colorText: Colors.white, // Text color
  //         duration: const Duration(seconds: 3), // Duration of the snackbar
  //       );
  //     }
  //   }
  // }

  void checkAndGotoNextStep(RegistrationResponseModel responseModel) async {
    bool needEmailVerification =
        responseModel.data?.user?.ev == "1" ? false : true;
    bool needSmsVerification =
        responseModel.data?.user?.sv == "1" ? false : true;

    SharedPreferences preferences = loanRepo.apiClient.sharedPreferences;

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
      Get.offAndToNamed(RouteHelper.emailVerificationScreen, arguments: [
        true,
        isProfileCompleteEnable,
        isTwoFactorEnable,
        responseModel.data?.user?.email,
        responseModel.data?.user?.mobile
      ]);
    } else if (needEmailVerification) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen, arguments: [
        false,
        isProfileCompleteEnable,
        isTwoFactorEnable,
        responseModel.data?.user?.email,
        responseModel.data?.user?.mobile
      ]);
    } else if (needSmsVerification) {
      Get.offAndToNamed(RouteHelper.smsVerificationScreen, arguments: [
        isProfileCompleteEnable,
        isTwoFactorEnable,
        responseModel.data?.user?.mobile
      ]);
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
