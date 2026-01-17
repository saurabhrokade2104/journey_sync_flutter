// import 'dart:async';
import 'dart:io';

import 'package:finovelapp/data/controller/bank/bank_detail_controller.dart';
import 'package:finovelapp/data/controller/kyc_controller/kyc_controller.dart';
import 'package:finovelapp/data/controller/loan/loan_apply_controller.dart';
import 'package:finovelapp/data/repo/bank/bank_detail_repo.dart';
import 'package:finovelapp/data/repo/kyc/kyc_repo.dart';
import 'package:finovelapp/data/repo/loan/loan_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/custom_drop_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/util.dart';
import '../../../../components/buttons/custom_button.dart';
import '../../../../components/text-field/form_text_field.dart';

// Enum declaration for document types
enum DocumentType { selfie, pan, aadharFront, aadharBack }

class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({super.key});

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));

    Get.put(LoanRepo(apiClient: Get.find()));
    Get.put(KycRepo(apiClient: Get.find()));
    Get.put(BankDetailsRepo(
      apiClient: Get.find(),
    ));
    Get.put(KycController(repo: Get.find()));

    Get.put(BankDetailsController(bankDetailsRepo: Get.find()));

    final controller = Get.put(LoanApplyController(
      loanRepo: Get.find(),
    ));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.retriveEligibilityFormUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GetBuilder<LoanApplyController>(builder: (controller) {
          return Form(
            key: controller.formKey,
            child: Stack(children: [
              Image.asset('assets/images/header_bg.png',
                  fit: BoxFit.fill, width: double.infinity, height: 210),
              _buildHeader(context),
              // Align(
              //     alignment: FractionalOffset.bottomCenter,
              //     child: ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //             backgroundColor: AppColors.primaryColor),
              //         onPressed: ()=>  handleStepProgression(),
              //         child: SizedBox(
              //           width: double.infinity,
              //           height: 54,
              //           child: _buttonChild(),
              //         ))),
              Obx(
                () => Padding(
                  padding:
                      const EdgeInsets.only(top: 80.0, right: 10, left: 15),
                  child: Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Loan Application',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor),
                        ),
                      ),
                      buildStepIndicator(),
                      if (controller.currentStep.value == 1)
                        _buildStepPersonalDetails(context, controller),
                      if (controller.currentStep.value == 2)
                        _buildStepContactAddress(),
                      if (controller.currentStep.value == 3)
                        _buildStepEmploymentDetails(controller),
                      if (controller.currentStep.value == 4)
                        _buildStepUploadDocuments(controller),
                      if (controller.currentStep.value == 5)
                        _buildStepBankDetails(controller),
                    ],
                  ),
                ),
              ),
            ]),
          );
        }),
      ),
    );
  }

  // Widget _buttonChild() {
  //   switch (loanApplyController.currentStep.value) {
  //     case 1:
  //       return _textCenter("Save & Next");
  //     case 2:
  //       return _textCenter("Save & Next");
  //     case 3:
  //       return _textCenter("Save & Next");

  //     default:
  //       return _textCenter("Submit");
  //   }
  // }

  Widget _textCenter(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(color: AppColors.whiteColor),
      ),
    );
  }

  Widget buildStepIndicator() {
    return GetBuilder<LoanApplyController>(builder: (loanApplyController) {
      return Column(
        children: [
          Obx(
            () => Padding(
                padding: const EdgeInsets.only(
                    top: 38, bottom: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Step 1: Personal Details
                    stepIndicatorItem('1', loanApplyController, 1),
                    connectingLine(loanApplyController.currentStep.value > 1),

                    // Step 2: Contact Details
                    stepIndicatorItem('2', loanApplyController, 2),
                    connectingLine(loanApplyController.currentStep.value > 2),

                    // New Step 3: Employment Details
                    stepIndicatorItem('3', loanApplyController, 3),
                    connectingLine(loanApplyController.currentStep.value > 3),

                    // Adjusted Step 4: Upload Documents (previously 3)
                    stepIndicatorItem('4', loanApplyController, 4),
                    connectingLine(loanApplyController.currentStep.value > 4),

                    // Adjusted Step 5: Bank Details (previously 4)
                    stepIndicatorItem('5', loanApplyController, 5),
                  ],
                )),
          ),
          // Titles below the indicators
          const Padding(
            padding: EdgeInsets.only(top: 0.0, right: 5, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 2,
                    child: Text('Personal Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.whiteColor, fontSize: 11))),
                Spacer(),
                Flexible(
                  flex: 2,
                  child: Text(
                    'Contact Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.whiteColor, fontSize: 11),
                  ),
                ),
                Spacer(),
                Flexible(
                    flex: 2,
                    child: Text('Employment Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.whiteColor, fontSize: 11))),
                Spacer(),
                Flexible(
                  flex: 2,
                  child: Text(
                    'Upload Kyc',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.whiteColor, fontSize: 11),
                  ),
                ),
                Spacer(),
                Flexible(
                  flex: 2,
                  child: Text(
                    'Bank Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.whiteColor, fontSize: 11),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    });
  }

  Widget _buildStepContactAddress() {
    return GetBuilder<LoanApplyController>(builder: (loanApplyController) {
      return Padding(
        padding:
            const EdgeInsets.only(top: 150.0, left: 10, right: 10, bottom: 5),
        child: SingleChildScrollView(
          child: Form(
            key: loanApplyController.contactFormKey,
            child: Column(
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 16),
                      child: Text('Fill Current Address'),
                    )),
                FormTextField(
                    labelText: 'Current Address',
                    controller: loanApplyController.currentAddressController),
                FormTextField(
                    labelText: 'Locality/Village',
                    controller: loanApplyController.localityController),
                FormTextField(
                    labelText: 'Near Landmark',
                    controller: loanApplyController.landmarkController),

                FormTextField(
                    labelText: 'City/District',
                    controller: loanApplyController.cityDistrictController),
                FormTextField(
                    labelText: 'State',
                    controller: loanApplyController.stateController),
                // DropdownButtonFormField<String>(
                //           value: selectedState,
                //           onChanged: (newValue) {
                //             selectedState = newValue!;
                //           },
                //           items: states
                //               .map<DropdownMenuItem<String>>((String value) {
                //             return DropdownMenuItem<String>(
                //               value: value,
                //               child: Text(value),
                //             );
                //           }).toList(),
                //           decoration: const InputDecoration(
                //             labelText: MyStrings.state,
                //             hintText: MyStrings.enterYourState,
                //           ),
                //           validator: (value) => validateNonEmpty(value, 'state'),
                //         ),
                FormTextField(
                  labelText: 'Pincode',
                  controller: loanApplyController.pincodeController,
                  onChanged: (value) {
                    if (value.length == 6) {
                      loanApplyController.fetchCityAndStateFromPincode(value);
                    }
                  },
                ),
                // const SizedBox(height: 20),

                Obx(
                  () => CupertinoFormRow(
                    prefix: const Text("Same as Current Address"),
                    child: CupertinoSwitch(
                      value: loanApplyController.isSameAsCurrentAddress.value,
                      onChanged: (bool value) {
                        loanApplyController.isSameAsCurrentAddress.value =
                            value;
                        if (loanApplyController.isSameAsCurrentAddress.value) {
                          loanApplyController.autoFillPermanentAddress();
                        } else {
                          // Clear permanent address fields when unchecked
                          loanApplyController.permanentAddressController
                              .clear();
                          loanApplyController.permanentLocalityController
                              .clear();
                          loanApplyController.permanentLandmarkController
                              .clear();
                          loanApplyController.permanentCityDistrictController
                              .clear();
                          loanApplyController.permanentStateController.clear();
                          loanApplyController.permanentPincodeController
                              .clear();
                        }
                      },
                    ),
                  ),
                ),

                const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 10),
                      child: Text('Fill Permanent Address'),
                    )),
                FormTextField(
                    labelText: 'Permanent Address',
                    enabled: !loanApplyController.isSameAsCurrentAddress.value,
                    controller: loanApplyController.permanentAddressController),
                FormTextField(
                    labelText: 'Locality/Village',
                    enabled: !loanApplyController.isSameAsCurrentAddress.value,
                    controller:
                        loanApplyController.permanentLocalityController),
                FormTextField(
                    labelText: 'Near Landmark',
                    enabled: !loanApplyController.isSameAsCurrentAddress.value,
                    controller:
                        loanApplyController.permanentLandmarkController),

                FormTextField(
                    labelText: 'City/District',
                    enabled: !loanApplyController.isSameAsCurrentAddress.value,
                    controller:
                        loanApplyController.permanentCityDistrictController),
                FormTextField(
                    labelText: 'State',
                    enabled: !loanApplyController.isSameAsCurrentAddress.value,
                    controller: loanApplyController.permanentStateController),
                FormTextField(
                    labelText: 'Pincode',
                    enabled: !loanApplyController.isSameAsCurrentAddress.value,
                    controller: loanApplyController.permanentPincodeController),
                const SizedBox(height: 10),
                CustomButton(
                  buttonText: 'Submit & Next',
                  onPressed: () => loanApplyController.handleStepProgression(),
                  isLoading: loanApplyController.isLoading.value,
                  textColor: AppColors.whiteColor,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildStepUploadDocuments(LoanApplyController loanApplyController) {
    return Padding(
      padding: const EdgeInsets.only(top: 150.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildSelfieSection(loanApplyController),
            _buildPanCardUploadSection(loanApplyController),
            _buildAadharCardUploadSections(loanApplyController),
            const SizedBox(height: 20),
            CustomButton(
              buttonText: 'Submit & Next',
              onPressed: () => loanApplyController.handleStepProgression(),
              isLoading: loanApplyController.isLoading.value,
              textColor: AppColors.whiteColor,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStepEmploymentDetails(LoanApplyController controller) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 150.0, left: 10, right: 10, bottom: 5),
      child: SingleChildScrollView(
        child: Form(
          key: controller
              .employmentFormKey, // Define this key in your controller
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 16),
                  child: Text(
                    'Fill Employment Details',
                    // style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              // FormTextField(
              //   labelText: 'Employment Type',
              //   controller: controller.employmentTypeController,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Please enter employment type' : null,
              // ),

              Obx(
                () => CustomDropdown(
                  // isEditable: false,
                  labelText: 'Employment Type',
                  options: const [
                    'Salaried',
                    'Self Employed',
                    'Business Owner',
                    'Student',
                    'Retired',
                    'Unemployed',
                  ],
                  currentValue: controller.employmentTypeSelection
                      .value, // This needs to be managed in your controller
                  onChanged: (newValue) {
                    controller.onChange(
                        newValue, controller.employmentTypeSelection);
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select your employment type'
                      : null,
                ),
              ),
              FormTextField(
                labelText: 'Employer Name',
                controller: controller.employerNameController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter employer name' : null,
              ),
              FormTextField(
                labelText: 'Official Email',
                controller: controller.officialEmailController,
                validator: (value) =>
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value!)
                        ? 'Please enter a valid email'
                        : null,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.workingSinceController,
                  readOnly: true,
                  validator: (value) {
                    if (controller.workingSinceController.text.isEmpty) {
                      return 'Please select a date';
                    } else {
                      // final currentDate = DateTime.now();
                      // var age = currentDate.year - dob!.year;
                      // if (dob.month > currentDate.month ||
                      //     (dob.month == currentDate.month &&
                      //         dob.day > currentDate.day)) {
                      //   // Adjust the age if the birthday has not occurred this year
                      //   age--;
                      // }

                      // if (age < 21) {
                      //   return 'You must be at least 21 years old';
                      // }
                    }
                    return null;
                  },
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      controller.updateWorkingSince(pickedDate);
                      //pickedDate output format => 2021-03-10 00:00:00.000

                      // Format the date and update the controller text
                      // String formattedDate =
                      //     DateFormat('yyyy-MM-dd').format(pickedDate);

                      // controller.workingSinceController.text = formattedDate;
                    } else {}
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.calendar_month),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    labelText: 'Working Since',
                    hintText: controller.workingSinceController.text.isNotEmpty
                        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(
                            controller.workingSinceController.text))
                        : 'Select Wroking Since',
                  ),
                ),
              ),
              FormTextField(
                labelText: 'Net Monthly Salary',
                controller: controller.netMonthlySalaryController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter net monthly salary';
                  } else if (!RegExp(r'^\d+\.?\d{0,2}$').hasMatch(value)) {
                    // Validates decimal numbers
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              // FormTextField(
              //   labelText: 'Salary Received Type',
              //   controller: controller.salaryReceivedTypeController,
              //   validator: (value) => value!.isEmpty
              //       ? 'Please enter how you receive your salary'
              //       : null,
              // ),
              Obx(
                () => CustomDropdown(
                  // isEditable: false,
                  labelText: 'Salary Received Type',
                  options: const [
                    'Bank Transfer',
                    'Cash',
                    'Cheque',
                    'Other',
                  ],
                  currentValue: controller.salaryReceivedTypeSelection
                      .value, // This needs to be managed in your controller
                  onChanged: (newValue) {
                    controller.onChange(
                        newValue, controller.salaryReceivedTypeSelection);
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select how you receive your salary'
                      : null,
                ),
              ),
              // FormTextField(
              //   labelText: 'Job Function',
              //   controller: controller.jobFunctionController,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Please enter your job function' : null,
              // ),
              Obx(
                () => CustomDropdown(
                  labelText: 'Job Function',
                  options: const [
                    'Accountant',
                    'Human Resources',
                    'Law',
                    'Bank/Finance',
                    'Marketing',
                    'Operations',
                    'Management',
                    'Account Manager',
                    'Sales',
                    'Information Technology',
                    'Management Consulting',
                    'Customer Service',
                    'Design',
                    'Entrepreneur',
                    'Technology',
                    'Analyst',
                    'Engineering',
                    'Education',
                    'Healthcare',
                    'Administrative',
                    'Other',
                  ],
                  currentValue: controller.jobFunctionSelection.value,
                  onChanged: (newValue) {
                    controller.onChange(
                        newValue, controller.jobFunctionSelection);
                  },
                  validator: (value) => value == 'Select Job Function'
                      ? 'Please select your job function'
                      : null,
                ),
              ),
              // FormTextField(
              //   labelText: 'Designation',
              //   controller: controller.designationController,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Please enter your designation' : null,
              // ),
              Obx(
                () => CustomDropdown(
                  labelText: 'Designation',
                  options: const [
                    'Manager',
                    'Assistant Manager',
                    'Team Leader',
                    'Supervisor',
                    'Analyst',
                    'Consultant',
                    'Specialist',
                    'Engineer',
                    'Architect',
                    'Developer',
                    'Designer',
                    'Coordinator',
                    'Executive Assistant',
                    'Administrator',
                    'Accountant',
                    'Auditor',
                    'Financial Analyst',
                    'HR Manager',
                    'Recruiter',
                    'Trainer',
                    'Teacher/Professor',
                    'Doctor/Surgeon',
                    'Nurse',
                    'Therapist/Counselor',
                    'Social Worker',
                    'Artist',
                    'Writer/Editor',
                    'Journalist',
                    'Public Relations Officer',
                    'Event Planner',
                    'Project Manager',
                    'Product Manager',
                    'Sales Representative',
                    'Customer Service Representative',
                    'Technician',
                    'Mechanic',
                    'Driver',
                    'Chef/Cook',
                    'Waiter/Waitress',
                    'Cashier',
                    'Receptionist',
                    'Security Guard',
                    'Other',
                  ],
                  currentValue: controller.designationSelection.value,
                  onChanged: (newValue) {
                    controller.onChange(
                        newValue, controller.designationSelection);
                  },
                  validator: (value) => value == 'Select Designation'
                      ? 'Please select your designation'
                      : null,
                ),
              ),
              // FormTextField(
              //   labelText: 'Work Sector',
              //   controller: controller.workSectorController,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Please enter your work sector' : null,
              // ),
              FormTextField(
                labelText: 'Employee ID (Optional)',
                controller: controller.employeeIDController,
                // validator: (value) =>
                //     value!.isEmpty ? 'Please enter your employee ID' : null,
              ),
              FormTextField(
                labelText: 'UAN Number (Optional)',
                controller: controller.uanNumberController,
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return 'Please enter your UAN number';
                //   } else if (value.length != 12 ||
                //       !RegExp(r'^\d+$').hasMatch(value)) {
                //     // UAN numbers are typically 12 digits long
                //     return 'Please enter a valid 12-digit UAN number';
                //   }
                //   return null;
                // },
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),
              CustomButton(
                buttonText: 'Submit & Next',
                onPressed: () => controller.handleStepProgression(),
                isLoading: controller.isLoading.value,
                textColor: AppColors.whiteColor,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelfieSection(LoanApplyController loanApplyController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Capture Selfie',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Container(
            width: 300, // Fixed width for the selfie image
            height: 180, // Fixed height for the selfie image
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.cardFillColor,
            ),
            child: loanApplyController.selfieImagePath.value != ''
                ? Image.file(
                    File(loanApplyController.selfieImagePath.value),
                    fit: BoxFit
                        .cover, // Ensures the image covers the box without changing aspect ratio
                  )
                : Image.asset(
                    'assets/imgs/selfi.png',
                    fit: BoxFit
                        .cover, // This will also cover the box consistently
                  ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSelfieTips(),
              _buildTakeSelfieButton(loanApplyController),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPanCardUploadSection(LoanApplyController loanApplyController) {
    return _buildDocumentUploadSection(
      title: 'Upload PAN Card',
      buttonTitle: 'Scan Pan Card',
      imagePath: loanApplyController.panCardImagePath.value,
      placeholderImage: 'assets/images/pan-card.png',
      onPressed: () =>
          loanApplyController.captureDocumentImage(DocumentType.pan),
    );
  }

  Widget _buildAadharCardUploadSections(
      LoanApplyController loanApplyController) {
    return Row(
      children: [
        Expanded(
          child: _buildDocumentUploadSection(
            title: 'Upload Aadhar Front',
            buttonTitle: 'Scan Frontside',
            imagePath: loanApplyController.aadharCardFrontImagePath.value,
            placeholderImage: 'assets/images/aadhar_front.png',
            onPressed: () => loanApplyController
                .captureDocumentImage(DocumentType.aadharFront),
          ),
        ),
        Expanded(
          child: _buildDocumentUploadSection(
            title: 'Upload Aadhar Back',
            buttonTitle: 'Scan Backside',
            imagePath: loanApplyController.aadharCardBackImagePath.value,
            placeholderImage: 'assets/images/aadhar_back.png',
            onPressed: () => loanApplyController
                .captureDocumentImage(DocumentType.aadharBack),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentUploadSection({
    required String title,
    String? imagePath,
    required String buttonTitle,
    required String placeholderImage,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 300, // Fixed width for all images
            height: 180, // Fixed height for all images
            child: imagePath != '' && imagePath != null
                ? Image.file(
                    File(imagePath),
                    fit: BoxFit
                        .cover, // This ensures the image covers the box without changing aspect ratio
                  )
                : DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black12.withOpacity(0.11),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(placeholderImage),
                        fit: BoxFit
                            .cover, // This ensures the image covers the box without changing aspect ratio
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          _buildUploadButton(title: buttonTitle, onPressed: onPressed),
        ],
      ),
    );
  }

  Widget _buildSelfieTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTip(
            iconColor: AppColors.accentColor,
            text: 'Good lighting on your face'),
        const SizedBox(width: 10),
        _buildTip(iconColor: AppColors.accentColor, text: 'No glasses or hat'),
      ],
    );
  }

  Widget _buildTip({required Color iconColor, required String text}) {
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
              color: iconColor, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: AppColors.textGray)),
      ],
    );
  }

  Widget _buildTakeSelfieButton(LoanApplyController loanApplyController) {
    return OutlinedButton(
      style: ButtonStyle(
        side: WidgetStateProperty.all(
            const BorderSide(color: AppColors.accentColor)),
      ),
      onPressed: () =>
          loanApplyController.captureDocumentImage(DocumentType.selfie),
      child: const Text(
        'Take a Selfie',
        style: TextStyle(
            color: AppColors.accentColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildUploadButton(
      {required String title, required VoidCallback onPressed}) {
    return OutlinedButton(
      style: ButtonStyle(
        side: WidgetStateProperty.all(
            const BorderSide(color: AppColors.accentColor)),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(
            color: AppColors.accentColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 50),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: AppColors.whiteColor,
              ),
              Text(
                'BACK',
                style: TextStyle(
                    color: AppColors.whiteColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget marridWidget(LoanApplyController loanApplyController) {
    return Column(
      children: [
        FormTextField(
          labelText: 'Spouse Name',
          readOnly: true,
          controller: loanApplyController.spouseNameController,
          validator: (value) =>
              value!.isEmpty ? 'Please enter spouse name' : null,
        ),
        FormTextField(
          labelText: 'No. of Kids',
          readOnly: true,
          controller: loanApplyController.noOfKidsController,
          validator: (value) =>
              value!.isEmpty ? 'Please enter  no. of kinds' : null,
        ),
      ],
    );
  }

  Widget singleWidget(LoanApplyController loanApplyController) {
    return Column(
      children: [
        FormTextField(
          labelText: 'Mother Name',
          controller: loanApplyController.motherNameController,
          readOnly: true,
          validator: (value) =>
              value!.isEmpty ? 'Please enter mother name' : null,
        ),
      ],
    );
  }

  Widget _buildStepPersonalDetails(
      BuildContext context, LoanApplyController loanApplyController) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 150.0, left: 10, right: 10, bottom: 3),
      child: Form(
        key: loanApplyController.personalFormKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 16),
                    child: Text('Fill Personal Details'),
                  )),
              FormTextField(
                controller: loanApplyController.fullNameController,
                labelText: 'Full Name as per PAN',
                readOnly: true,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter full name' : null,
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(
                    () => TextFormField(
                      controller: loanApplyController.dobController,
                      readOnly: true,
                      validator: (value) {
                        final dob = loanApplyController.dob.value;
                        if (loanApplyController.dob.value == null) {
                          return 'Please select your date of birth';
                        } else {
                          final currentDate = DateTime.now();
                          var age = currentDate.year - dob!.year;
                          if (dob.month > currentDate.month ||
                              (dob.month == currentDate.month &&
                                  dob.day > currentDate.day)) {
                            // Adjust the age if the birthday has not occurred this year
                            age--;
                          }

                          if (age < 21) {
                            return 'You must be at least 21 years old';
                          }
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          loanApplyController.updateDOB(pickedDate);
                          //pickedDate output format => 2021-03-10 00:00:00.000

                          // Format the date and update the controller text
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);

                          loanApplyController.dobController.text =
                              formattedDate;
                        } else {}
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.calendar_month),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        labelText: 'Date of Birth',
                        hintText: loanApplyController.dob.value != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(loanApplyController.dob.value!)
                            : 'Select Date of Birth',
                      ),
                    ),
                  )),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Gender'),
                  )),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        // onTap: () {
                        //   loanApplyController.isMale.value = true;

                        // },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: loanApplyController.isMale.value
                                  ? AppColors.cardFillColor
                                  : AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: loanApplyController.isMale.value
                                      ? AppColors.accentColor
                                      : const Color.fromARGB(
                                          255, 169, 166, 166))),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: AppColors.blackColor)),
                                  child: Center(
                                    child: loanApplyController.isMale.value
                                        ? const Icon(
                                            Icons.circle,
                                            color: AppColors.accentColor,
                                            size: 16,
                                          )
                                        : Container(),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 12.0, bottom: 12, left: 0),
                                child: Text('Male'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: InkWell(
                          // onTap: () {
                          //   loanApplyController.isMale.value = false;

                          // },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: loanApplyController.isMale.value
                                    ? AppColors.whiteColor
                                    : AppColors.cardFillColor,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: loanApplyController.isMale.value
                                        ? const Color.fromARGB(
                                            255, 169, 166, 166)
                                        : AppColors.accentColor)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: AppColors.blackColor)),
                                    child: Center(
                                      child: !loanApplyController.isMale.value
                                          ? const Icon(
                                              Icons.circle,
                                              color: AppColors.accentColor,
                                              size: 16,
                                            )
                                          : Container(),
                                    ),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(
                                        top: 12.0, bottom: 12, left: 0),
                                    child: Text('Female'))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              FormTextField(
                  labelText: 'Mobile Number',
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    } else if (value.length != 10) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                  controller: loanApplyController.mobileNumberController),
              FormTextField(
                labelText: 'Email ID',
                readOnly: true,
                controller: loanApplyController.emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Marital Status'),
                  )),
              Obx(() {
                print('maritial  ${loanApplyController.isMarried.value}');
                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () => loanApplyController
                            .toggleSingleMarried(false), // Toggle to single
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: !loanApplyController.isMarried.value
                                ? AppColors.cardFillColor
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: !loanApplyController.isMarried.value
                                  ? AppColors.accentColor
                                  : const Color.fromARGB(255, 169, 166, 166),
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border:
                                        Border.all(color: AppColors.blackColor),
                                  ),
                                  child: Center(
                                    child: !loanApplyController.isMarried.value
                                        ? const Icon(
                                            Icons.circle,
                                            color: AppColors.accentColor,
                                            size: 16,
                                          )
                                        : Container(),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 12.0, bottom: 12, left: 0),
                                child: Text('Single'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () => loanApplyController
                            .toggleSingleMarried(true), // Toggle to married
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: loanApplyController.isMarried.value
                                ? AppColors.cardFillColor
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: loanApplyController.isMarried.value
                                  ? AppColors.accentColor
                                  : const Color.fromARGB(255, 169, 166, 166),
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border:
                                        Border.all(color: AppColors.blackColor),
                                  ),
                                  child: Center(
                                    child: loanApplyController.isMarried.value
                                        ? const Icon(
                                            Icons.circle,
                                            color: AppColors.accentColor,
                                            size: 16,
                                          )
                                        : Container(),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 12.0, bottom: 12, left: 0),
                                child: Text('Married'),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }),
              loanApplyController.isMarried.value
                  ? marridWidget(
                      loanApplyController) // Show married fields when isMarried is true
                  : singleWidget(
                      loanApplyController), // Show single fields when isMarried is false

              const Divider(),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 10),
                    child: Text('Additional Details'),
                  )),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: loanApplyController.panNumberController,
                  maxLines: 1,
                  readOnly: true,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^[A-Za-z0-9]+$')), // Allow alphanumeric characters
                    LengthLimitingTextInputFormatter(
                        10), // Limit to 10 characters
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter PAN number';
                    } else if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')
                        .hasMatch(value)) {
                      // Regular expression for PAN format
                      return 'Please enter a valid PAN number';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    labelText: 'PAN Number',
                    hintText: 'PAN Number',
                  ),
                ),
              ),
              FormTextField(
                  readOnly: true,
                  labelText: 'Aadhaar Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Aadhar number';
                    } else if (!RegExp(r'^\d{12}$').hasMatch(value)) {
                      // Regular expression for a 12-digit number
                      return 'Please enter a valid 12-digit Aadhar number';
                    }
                    return null;
                  },
                  controller: loanApplyController.aadharNumberController),
              Obx(
                () => CustomDropdown(
                  isEditable: false,
                  labelText: 'Education Qualification',
                  options: const [
                    "High School",
                    "Associate Degree",
                    "Bachelor's Degree",
                    "Master's Degree",
                    "PhD",
                  ],
                  currentValue: loanApplyController
                      .currentQualificationSelection
                      .value, // This needs to be managed in your controller
                  onChanged: (newValue) {
                    loanApplyController.onChange(newValue,
                        loanApplyController.currentQualificationSelection);
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select your education qualification'
                      : null,
                ),
              ),
              Obx(
                () => CustomDropdown(
                  isEditable: false,
                  options: const [
                    "Medical Emergency",
                    "Job Loss",
                    "Vacations",
                    "Buying Gadgets",
                    "Unexpected Travel",
                    "For Food",
                    "Another Debt EMI",
                    "Emergency Expenses",
                    "Improving Credit Score",
                    "Domestic Expenses",
                    "Utility Bill",
                  ],
                  currentValue:
                      loanApplyController.currentPurposeSelection.value,
                  labelText: 'Purpose of Loan',
                  onChanged: (newValue) {
                    loanApplyController.onChange(
                        newValue, loanApplyController.currentPurposeSelection);
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select a purpose for the loan'
                      : null,
                ),
              ),
              CustomButton(
                buttonText: 'Submit & Next',
                onPressed: () => loanApplyController.handleStepProgression(),
                isLoading: loanApplyController.isLoading.value,
                textColor: AppColors.whiteColor,
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepBankDetails(LoanApplyController loanApplyController) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 150.0, left: 10, right: 10, bottom: 5),
      child: SingleChildScrollView(
        child: Form(
          key: loanApplyController.bankFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 16),
                  child: Text(
                    'Fill Bank Details',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () {
                            loanApplyController.toggleBankUPI(true);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: loanApplyController.isBank.value
                                    ? AppColors.cardFillColor
                                    : AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: loanApplyController.isBank.value
                                        ? AppColors.accentColor
                                        : const Color.fromARGB(
                                            255, 169, 166, 166))),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: AppColors.blackColor)),
                                    child: Center(
                                      child: loanApplyController.isBank.value
                                          ? const Icon(
                                              Icons.circle,
                                              color: AppColors.accentColor,
                                              size: 16,
                                            )
                                          : Container(),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 12.0, bottom: 12, left: 0),
                                  child: Text('Bank Account'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: InkWell(
                            onTap: () {
                              loanApplyController.toggleBankUPI(false);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: loanApplyController.isBank.value
                                      ? AppColors.whiteColor
                                      : AppColors.cardFillColor,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: loanApplyController.isBank.value
                                          ? const Color.fromARGB(
                                              255, 169, 166, 166)
                                          : AppColors.accentColor)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 18,
                                      width: 18,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                              color: AppColors.blackColor)),
                                      child: Center(
                                        child: !loanApplyController.isBank.value
                                            ? const Icon(
                                                Icons.circle,
                                                color: AppColors.accentColor,
                                                size: 16,
                                              )
                                            : Container(),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(
                                          top: 12.0, bottom: 12, left: 0),
                                      child: Text('UPI ID'))
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                loanApplyController.isBank.value
                    ? bankDetails(loanApplyController)
                    : upiDetails(loanApplyController),
                const Divider(),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     controller: mobileNumberController,
                //     maxLines: 1,
                //     decoration: const InputDecoration(
                //       labelText: 'Enter Mobile Number',
                //       hintText: 'Enter Mobile Number',
                //       border: OutlineInputBorder(),
                //     ),

                //   ),
                // ),

                const SizedBox(height: 40),

                // ElevatedButton(onPressed: (){}, child: const Text('VERIFY BANK ACCOUNT'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bankDetails(LoanApplyController loanApplyController) {
    return Column(
      children: [
        FormTextField(
          controller: loanApplyController.accountNumberController,
          labelText: 'Bank Account Number',
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Account Number';
            }
            // Add more specific UPI validation if required
            return null;
          },
        ),
        FormTextField(
          controller: loanApplyController.confirmAccountNumberController,
          labelText: 'Confirm Account Number',
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Confirm Account Number';
            } else if (value !=
                loanApplyController.confirmAccountNumberController.text) {
              return 'Please enter Correct Confirm Account Number';
            }
            // Add more specific UPI validation if required
            return null;
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormTextField(
                controller: loanApplyController.ifscCodeController,
                labelText: 'IFSC Code',
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  if (value.length == 11 &&
                      RegExp(r'^[A-Za-z]{4}0[A-Z0-9a-z]{6}$').hasMatch(value)) {
                    loanApplyController.fetchAndFillBankDetails(value);
                  }
                },
                validator: (value) => MyUtil().ifscValidator(value)),
            loanApplyController.bankBranch.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 10, right: 8, left: 8),
                    child: Text(
                      '${loanApplyController.bankNameController.text} - ${loanApplyController.bankBranch.value}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        FormTextField(
          controller: loanApplyController.bankNameController,
          labelText: 'Bank Name',
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Bank Name';
            }
            // Add more specific UPI validation if required
            return null;
          },
        ),
        FormTextField(
          controller: loanApplyController.accountHolderNameController,
          labelText: 'Account Holder Name',
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Account Holder Name';
            }
            // Add more specific UPI validation if required
            return null;
          },
        ),
        const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Account Type'),
            )),
        Obx(
          () => Row(
            children: [
              Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () {
                      loanApplyController.isSavingAccount.value = true;
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: loanApplyController.isSavingAccount.value
                              ? AppColors.cardFillColor
                              : AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: loanApplyController.isSavingAccount.value
                                  ? AppColors.accentColor
                                  : const Color.fromARGB(255, 169, 166, 166))),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(color: AppColors.blackColor)),
                              child: Center(
                                child: loanApplyController.isSavingAccount.value
                                    ? const Icon(
                                        Icons.circle,
                                        color: AppColors.accentColor,
                                        size: 16,
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(top: 12.0, bottom: 12, left: 0),
                            child: Text('Saving'),
                          )
                        ],
                      ),
                    ),
                  )),
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () {
                    loanApplyController.isSavingAccount.value = false;
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: loanApplyController.isSavingAccount.value
                            ? AppColors.whiteColor
                            : AppColors.cardFillColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: loanApplyController.isSavingAccount.value
                                ? const Color.fromARGB(255, 169, 166, 166)
                                : AppColors.accentColor)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.center,
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border:
                                    Border.all(color: AppColors.blackColor)),
                            child: Center(
                              child: !loanApplyController.isSavingAccount.value
                                  ? const Icon(
                                      Icons.circle,
                                      color: AppColors.accentColor,
                                      size: 16,
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                        const Padding(
                            padding:
                                EdgeInsets.only(top: 12.0, bottom: 12, left: 0),
                            child: Text('Current'))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        CustomButton(
          buttonText: 'Submit',
          onPressed: () => loanApplyController.handleStepProgression(),
          isLoading: loanApplyController.isLoading.value,
          textColor: AppColors.whiteColor,
        ),
      ],
    );
  }

  // Widget upiDetails() {
  //   return Column(
  //     children: [
  //       FormTextField(
  //           labelText: 'Enter UPI',
  //           controller: upiIdController,
  //           keyboardType: TextInputType.name,
  //           onChanged: onUpiIdChanged,
  //           suffixText: accountHolderName,
  //           validator: (value) => upiValidator(value)),
  //     ],
  //   );
  // }
  Widget stepIndicatorItem(
      String stepNumber, LoanApplyController controller, int stepValue) {
    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: controller.currentStep.value >= stepValue
              ? AppColors.whiteColor
              : AppColors.progressFaintColor),
      child: InkWell(
        onTap: () => controller.currentStep.value = stepValue,
        child: Center(
            child: Text(
          stepNumber,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.accentColor),
        )),
      ),
    );
  }

  Widget connectingLine(bool isActive) {
    return Container(
      height: 5,
      margin: const EdgeInsets.all(5),
      width: 35, // Adjust width according to your UI needs
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color:
              isActive ? AppColors.whiteColor : AppColors.progressFaintColor),
    );
  }

  Widget upiDetails(LoanApplyController loanApplyController) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: loanApplyController.upiIdController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))),
            labelText: 'Enter UPI ID',
            suffixIcon: loanApplyController.upiIdController != null
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
            // Add the holder's name below the text field
            helperText: loanApplyController.accountHolderName,
            helperStyle: const TextStyle(
                color: Color(0xFF128C7E),
                fontSize: 14 // Assuming this is the color you want
                ),
          ),
          keyboardType: TextInputType.name,
          onChanged: null,
          validator: (value) => MyUtil().upiValidator(value),
        ),
        const SizedBox(height: 10),
        CustomButton(
          buttonText: 'Submit',
          onPressed: () => loanApplyController.handleStepProgression(),
          isLoading: loanApplyController.isLoading.value,
          textColor: AppColors.whiteColor,
        ),
      ],
    );
  }
}
