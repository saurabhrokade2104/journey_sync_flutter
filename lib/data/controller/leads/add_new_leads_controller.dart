import 'dart:convert';

import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/data/model/leads/add_lead_response_model.dart';
import 'package:finovelapp/data/model/leads/lead_form_model.dart';
import 'package:finovelapp/data/repo/leads/add_lead_repo.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AddNewLeadsController extends GetxController {
   AddLeadFormRepo addLeadFormRepo;

     AddNewLeadsController({required this.addLeadFormRepo}) {
    // Debug/demo values initialization
    assert(() {
      // Initialize default values for debugging
      fullNameController.text = 'John Doe'; // Default Full Name
      mobileNumberController.text = '9876543210'; // Default Phone Number
      emailController.text = 'john.doe@example.com'; // Default Email
      pancardNumberController.text = 'ABCDE1234F'; // Default PAN Number
      aadharNumberController.text = '123412341234'; // Default Aadhar Number
      areaPincodeController.text = '123456'; // Default Area Pincode
      monthlyIncomeController.text = '50000'; // Default Monthly Income
      requiredLoanAmountController.text = '200000'; // Default Loan Amount
      referralCodeController.text = 'REF123'; // Default Referral Code

      selectedRequirement.value = 'Home Renovation'; // Default Requirement
      selectedIncomeSource.value = 'Employment'; // Default Income Source
      selectedLeadType.value = 'Personal'; // Default Lead Type

      return true; // Return true to satisfy the assert condition
    }());
  }



    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Controllers for TextFields
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pancardNumberController = TextEditingController();
  TextEditingController aadharNumberController = TextEditingController();
  TextEditingController areaPincodeController = TextEditingController();
  TextEditingController monthlyIncomeController = TextEditingController();
  TextEditingController requiredLoanAmountController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();
  TextEditingController companyCodeController = TextEditingController();
  TextEditingController transactionIdController = TextEditingController();

  // Obx Observables for Dropdowns
  RxString selectedRequirement = ''.obs;
  RxString selectedIncomeSource = ''.obs;
  RxString selectedLeadType = ''.obs;
  // Add observable fields for category and subcategory
  RxString selectedCategory = ''.obs;
  RxString selectedSubcategory = ''.obs;

  // Define a map of categories and their corresponding subcategories
final Map<String, List<String>> subcategories = {
  'Personal Loans': [
    'Personal Loan (PL)',
    'Small Loan - Credit Line',
    'Overdraft (OD)',
    'Other Requirements'
  ],
  'Credit Cards': [
    'Credit Card',
    'FD-Based Credit Card',
    'Secured Credit Card',
    'Reward Credit Card',
    'Cashback Credit Card',
    'Travel Credit Card',
    'Fuel Credit Card',
    'Other Requirements'
  ],
  'Home Loans': [
    'New Home Loan',
    'Home Loan Balance Transfer',
    'Home Improvement Loan',
    'Home Extension Loan',
    'Plot Loan',
    'Other Requirements'
  ],
  'Car Loans': [
    'New Car Loan',
    'Used Car Loan',
    'Two-Wheeler Loan',
    'Commercial Vehicle Loan',
    'Other Requirements'
  ],
  'Business Loans': [
    'Working Capital Loan',
    'Term Loan',
    'Business Overdraft',
    'Invoice Discounting',
    'Machinery Loan',
    'Business Expansion Loan',
    'Other Requirements'
  ],
  'Education Loans': [
    'Domestic Education Loan',
    'International Education Loan',
    'Skill Development Loan',
    'Student Credit Card',
    'Other Requirements'
  ],
  'Insurance': [
    'Health Insurance',
    'Life Insurance',
    'Car Insurance',
    'Home Insurance',
    'Travel Insurance',
    'Business Insurance',
    'Other Requirements'
  ],
  'Investments': [
    'Mutual Funds',
    'Fixed Deposits',
    'Stocks & Shares',
    'Bonds',
    'Public Provident Fund (PPF)',
    'National Pension System (NPS)',
    'Other Requirements'
  ],
  'Savings Account': [
    'Regular Savings Account',
    'Salary Account',
    'Senior Citizens Account',
    'Minor Savings Account',
    "Womenn's Savings Account",
    'Other Requirements'
  ],
  'Fixed Deposits': [
    'Regular Fixed Deposit',
    'Tax Saver Fixed Deposit',
    'Senior Citizens Fixed Deposit',
    'Recurring Deposit',
    'Flexi Fixed Deposit',
    'Other Requirements'
  ],
  'Current Accounts': [
    'Standard Current Account',
    'Premium Current Account',
    'Foreign Currency Current Account',
    'Startup Current Account',
    'Other Requirements'
  ],
  'Loans Against Property': [
    'Loan Against Residential Property',
    'Loan Against Commercial Property',
    'Lease Rental Discounting',
    'Other Requirements'
  ],
  'Gold Loans': [
    'Gold Loan',
    'Agricultural Gold Loan',
    'Business Gold Loan',
    'Other Requirements'
  ],
  'Microfinance': [
    'Group Loan',
    'Individual Loan',
    'MSME Loan',
    'Agriculture Loan',
    'Other Requirements'
  ],
  'Health and Wellness': [
    'Personal Health Loan',
    'Fitness Loan',
    'Medical Treatment Loan',
    'Other Requirements'
  ],
  'Others': [
    'Debt Consolidation',
    'Loan Restructuring',
    'Emergency Loan',
    'Other Requirements'
  ],
};



  // Obx Observables for Checkboxes
  RxBool isCheckedPrivacy = false.obs;
  RxBool isCheckedNotify = false.obs;
    bool submitLoading = false;

  // Dispose of controllers
  @override
  void onClose() {
    fullNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    pancardNumberController.dispose();
    aadharNumberController.dispose();
    areaPincodeController.dispose();
    monthlyIncomeController.dispose();
    requiredLoanAmountController.dispose();
    referralCodeController.dispose();
    companyCodeController.dispose();
    transactionIdController.dispose();
    super.onClose();
  }

  // Method to get subcategories based on the selected category
  List<String> getSubcategories(String category) {
    return subcategories[category] ?? [];
  }

  void submitLeadDataForm(BuildContext context ) async {
    if (formKey.currentState!.validate()) {
      if ( isCheckedPrivacy.value) {
        formKey.currentState!.save();

        submitLoading = true;
        update();

        // Collect the data
      final leadFormModel = LeadFormModel(
        fullName: fullNameController.text,
        mobileNumber: mobileNumberController.text.trim(),
        emailId: emailController.text.trim(),
        pancardNumber: pancardNumberController.text.trim(),
        aadharNumber: aadharNumberController.text.trim(),
        areaPincode: areaPincodeController.text.trim(),
        requirementType: selectedSubcategory.value,
        monthlyIncome: monthlyIncomeController.text.trim(),
        sourceOfIncome: selectedIncomeSource.value,
        loanAmount: requiredLoanAmountController.text.trim(),
        leadType: selectedLeadType.value,
        referralCode: referralCodeController.text.trim().toUpperCase(),
        // companyCode: companyCodeController.text.trim(),
        // transactionId: transactionIdController.text.trim()

      );

      print('leadformmodel : ${leadFormModel.aadharNumber}');




        final response =
            await addLeadFormRepo.submitLeadFormData(leadFormModel);
        if (response.statusCode == 200) {

            AddNewLeadResponseModel responseModel =
              AddNewLeadResponseModel.fromJson(
                  jsonDecode(response.responseJson));
          if (responseModel.status?.toLowerCase() ==
              MyStrings.success.toLowerCase()) {

                // ignore: use_build_context_synchronously
                showSubmissionDialog(context);


          } else {
            print('error check : ${responseModel.message?.error}');
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

  void showSubmissionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Your Lead has been\n",
                      style: TextStyle(fontSize: 18.sp, height: 1.5),
                    ),
                    TextSpan(
                      text: "Submitted Successfully\n",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          height: 1.5),
                    ),
                    TextSpan(
                      text: "Sit back and Relax\n",
                      style: TextStyle(fontSize: 18.sp, height: 1.5),
                    ),
                    TextSpan(
                      text: "Our associate will get in touch",
                      style: TextStyle(
                          fontSize: 18.sp, color: Colors.grey, height: 1.5),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Center(
                child: Lottie.asset("assets/animation/thanks.json",
                    height: 200, width: 200),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/mysalesdashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1769E9),
                  foregroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 60.w, vertical: 10.h),
                ),
                child: Text("Done", style: TextStyle(fontSize: 18.sp)),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}