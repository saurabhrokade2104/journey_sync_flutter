import 'package:finovelapp/core/helper/upper_formatter_text.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/data/controller/bnpl/eligibility_checker_controller.dart';
import 'package:finovelapp/data/repo/eligibility/eligibility_repo.dart';
import 'package:finovelapp/views/components/buttons/custom_button.dart';
import 'package:finovelapp/views/components/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../core/route/route.dart';
import '../../../../../core/utils/colors.dart';
import 'package:finovelapp/views/components/text-field/form_text_field.dart';

import '../../../../../core/utils/my_strings.dart';
import '../../../../../data/services/api_service.dart';
import '../../../../components/snackbar/show_custom_snackbar.dart';

class EligibilityCheckForm extends StatefulWidget {
  final bool isBigLoan;
  const EligibilityCheckForm({super.key, this.isBigLoan = false});

  @override
  State<EligibilityCheckForm> createState() => _EligibilityCheckFormState();
}

class _EligibilityCheckFormState extends State<EligibilityCheckForm> {
  // _EligibilityCheckFormState() {
  //   assert(() {
  //     // Set default values for the form fields
  //     isMale = true; // Assuming default gender as Male
  //     isMarried = false; // Assuming default marital status as Single
  //     dob = DateTime(1990, 1, 1); // Default Date of Birth
  //     _dobController.text =
  //         DateFormat('yyyy-MM-dd').format(dob!); // Set formatted date
  //     _spouseNameController.text = 'Jane Doe'; // Default Spouse Name
  //     _noOfKidsController.text = '2'; // Default Number of Kids
  //     _motherNameController.text = 'Mary Doe'; // Default Mother's Name
  //     _qualificationController.text = 'Bachelor'; // Default Qualification
  //     _purposeOfLoanController.text =
  //         'Home Renovation'; // Default Purpose of Loan
  //     aadharNumberController.text = '123412341234'; // Default Aadhar Number
  //     panNumberController.text = 'ABCDE1234F'; // Default PAN Number
  //     fullNameController.text = 'John Doe'; // Default Full Name
  //     emailController.text = 'john.doe@example.com'; // Default Email
  //     phoneNumberController.text = '9876543210'; // Default Phone Number
  //     return true; // Return true to satisfy the assert condition
  //   }());
  // }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));

    Get.put(EligibilityCheckerRepo(apiClient: Get.find()));
    Get.put(EligibilityCheckerController(
      eligibilityCheckerRepo: Get.find(),
    ));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<EligibilityCheckerController>();
      controller.authenticate();
    });
  }

  Widget _buildSuffixIconMobile(EligibilityCheckerController controller) {
    if (!controller.isPhoneNumberValid.value) {
      return const SizedBox
          .shrink(); // Early return if phone number is not valid
    }

    if (controller.verifiedPhoneNumbers
        .contains(controller.phoneNumberController.text)) {
      // Phone number is verified
      return const Icon(Icons.check_circle, color: Colors.green, size: 20);
    }

    if (controller.isSendingOtp) {
      // OTP is being sent, use a simpler widget to avoid layout issues
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Keep the row size to a minimum
          children: [
            SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.accentColor),
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 5), // Smaller space between loader and text
            Text(
              'loading', // Assuming 'loading'.tr is handled elsewhere for translation
              style: TextStyle(color: AppColors.blackColor, fontSize: 12),
            ),
          ],
        ),
      );
    }

    if (controller.isOtpFieldVisible.value) {
      // OTP has been sent
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Text(
          'Code Sent!',
          style: TextStyle(
              color: AppColors.accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      );
    }

    // Default case, showing "Get Code" button
    return GestureDetector(
      onTap: () {
        if (controller.phoneNumberController.text.length == 10) {
          controller.sendOtpPhone();
        } else {
          CustomSnackBar.error(
            errorList: ['Please enter 10-digit phone number'],
          );
        }
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Text(
          'Get Code',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSuffixIconEmail(EligibilityCheckerController controller) {
    // Early return if email is not valid or empty
    if (!controller.isEmailValid.value ||
        controller.emailController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    // Display verified icon only if the current email is verified
    if (controller.verifiedEmails.contains(controller.emailController.text) &&
        controller.emailOtpVerified.value) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 20);
    }

    // Handling the sending OTP state
    if (controller.isSendingEmailOtp) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.accentColor),
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 5),
            Text(
              'Loading...',
              style: TextStyle(color: AppColors.blackColor, fontSize: 12),
            ),
          ],
        ),
      );
    }

    // OTP has been sent
    if (controller.isEmailOtpFieldVisible.value &&
        !controller.emailOtpVerified.value &&
        controller.isOtpSent.value) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Text(
          'Code Sent!',
          style: TextStyle(
              color: AppColors.accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      );
    }

    // Default case, showing "Get Code" button
    return GestureDetector(
      onTap: () {
        if (controller.emailController.text.isNotEmpty &&
            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                .hasMatch(controller.emailController.text)) {
          controller.sendOtpEmail();
        } else {
          CustomSnackBar.error(
            errorList: ['Please enter a valid email'],
          );
        }
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Text(
          'Get Code',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSuffixIconAadhar(EligibilityCheckerController controller) {
    // Early return if email is not valid or empty
    if (!controller.isAadharValid.value ||
        controller.aadharNumberController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    // Display verified icon only if the current email is verified
    if (controller.aadharOtpVerified.value) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 20);
    }

    // Handling the sending OTP state
    if (controller.isAadharOtpSending.value) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.accentColor),
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 5),
            Text(
              'Loading...',
              style: TextStyle(color: AppColors.blackColor, fontSize: 12),
            ),
          ],
        ),
      );
    }

    // OTP has been sent
    if (controller.isAadharOtpFieldVisible.value &&
        !controller.aadharOtpVerified.value &&
        !controller.isAadharOtpSending.value) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Text(
          'Code Sent!',
          style: TextStyle(
              color: AppColors.accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      );
    }

    // Default case, showing "Get Code" button
    return GestureDetector(
      onTap: () {
        if (controller.aadharNumberController.text.length == 12 &&
            RegExp(r'^\d{12}$')
                .hasMatch(controller.aadharNumberController.text)) {
          controller.requestAadharOtp();
        } else {
          CustomSnackBar.error(
            errorList: ['Please enter a valid 12-digit Aadhar number'],
          );
        }
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Text(
          'Get Code',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSuffixIconPanCard(EligibilityCheckerController controller) {
    // Early return if email is not valid or empty
    if (!controller.isPanValid.value ||
        controller.panNumberController.text.isEmpty) {
      debugPrint('pan card is not valid');
      return const SizedBox.shrink();
    }

    // Display verified icon only if the current email is verified
    if (controller.panVerified.value) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 20);
    }

    // Handling the sending OTP state
    if (controller.isPanVerifying.value) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.accentColor),
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 5),
            Text(
              'Loading...',
              style: TextStyle(color: AppColors.blackColor, fontSize: 12),
            ),
          ],
        ),
      );
    }

    // Default case, showing "Get Code" button
    return GestureDetector(
      onTap: () {
        if (controller.panNumberController.text.length == 10 &&
            RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')
                .hasMatch(controller.panNumberController.text)) {
          controller.verifyPanNumber();
        } else {
          CustomSnackBar.error(
            errorList: ['Please enter a valid Pan number'],
          );
        }
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Text(
          'Verify',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          Image.asset('assets/images/header_bg.png',
              fit: BoxFit.fill, width: double.infinity, height: 150),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 70),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    size: 15,
                    color: AppColors.whiteColor,
                  ),
                  Text(
                    'BACK',
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, top: 105),
            child: Text(
              'Personal Details',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 160.0, left: 10, right: 10, bottom: 5),
            child:
                GetBuilder<EligibilityCheckerController>(builder: (controller) {
              return Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('Fill Person Details'),
                        )),
                    FormTextField(
                      controller: controller.fullNameController,
                      labelText: 'Full Name as per PAN',
                      readOnly: controller.panVerified.value,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter full name' : null,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () => TextFormField(
                            controller: controller.dobController,
                            validator: (value) {
                              final dob = controller.dob.value;
                              if (controller.dob.value == null) {
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
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2100));

                              if (pickedDate != null) {
                                controller.updateDOB(pickedDate);
                                //pickedDate output format => 2021-03-10 00:00:00.000

                                // Format the date and update the controller text
                                String formattedDate =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);

                                controller.dobController.text = formattedDate;
                              } else {}
                            },
                            maxLines: 1,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.calendar_month),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              labelText: 'Date of Birth',
                              hintText: controller.dob.value != null
                                  ? DateFormat('dd-MM-yyyy')
                                      .format(controller.dob.value!)
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
                              onTap: () {
                                controller.isMale.value = true;
                                setState(() {});
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: controller.isMale.value
                                        ? AppColors.cardFillColor
                                        : AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: controller.isMale.value
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
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                color: AppColors.blackColor)),
                                        child: Center(
                                          child: controller.isMale.value
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
                                onTap: () {
                                  controller.isMale.value = false;
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: controller.isMale.value
                                          ? AppColors.whiteColor
                                          : AppColors.cardFillColor,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: controller.isMale.value
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
                                            child: !controller.isMale.value
                                                ? const Icon(
                                                    Icons.circle,
                                                    color:
                                                        AppColors.accentColor,
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

                    Obx(() => FormTextField(
                          keyboardType: TextInputType.phone,
                          enableInputFormatting: true,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10)
                          ],
                          labelText: 'Mobile Number',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            } else if (value.length != 10) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.checkPhoneNumber(value);
                          },
                          suffixIcon: _buildSuffixIconMobile(controller),
                          controller: controller.phoneNumberController,
                        )),

                    Obx(() => Visibility(
                          visible: controller.isOtpFieldVisible.value &&
                              !controller.otpVerified.value,
                          child: Row(
                            children: [
                              Expanded(
                                child: FormTextField(
                                  labelText: 'Enter OTP',
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter 6-digit OTP';
                                    } else if (value.length != 6) {
                                      // Assuming a 4-digit OTP
                                      return 'Please enter a valid 6-digit OTP';
                                    }
                                    return null;
                                  },
                                  controller: controller.otpController,
                                ),
                              ),
                              CustomButton(
                                  buttonText: 'Submit',
                                  width: 80,
                                  textColor: AppColors.whiteColor,
                                  isLoading: controller.isOtpVerifying,
                                  height: 43,
                                  onPressed: () {
                                    if (controller.otpController.text.length ==
                                        6) {
                                      controller.verifyOtpPhone();
                                    } else {
                                      CustomSnackBar.error(
                                        errorList: ['Please enter 6-digit OTP'],
                                      );
                                    }
                                  }),
                            ],
                          ),
                        )),

                    Obx(() => FormTextField(
                          labelText: 'Email ID',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.checkEmail(value);
                          },
                          suffixIcon: _buildSuffixIconEmail(controller),
                          controller: controller.emailController,
                        )),

                    Obx(() => Visibility(
                          visible: controller.isEmailOtpFieldVisible.value &&
                              !controller.emailOtpVerified.value,
                          child: Row(
                            children: [
                              Expanded(
                                child: FormTextField(
                                  labelText: 'Enter OTP',
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter 6-digit OTP';
                                    } else if (value.length != 6) {
                                      // Assuming a 4-digit OTP
                                      return 'Please enter a valid 6-digit OTP';
                                    }
                                    return null;
                                  },
                                  controller: controller.emailOtpController,
                                ),
                              ),
                              CustomButton(
                                  buttonText: 'Submit',
                                  width: 80,
                                  textColor: AppColors.whiteColor,
                                  isLoading: controller.isEmailOtpVerifying,
                                  height: 43,
                                  onPressed: () {
                                    if (controller
                                            .emailOtpController.text.length ==
                                        6) {
                                      controller.verifyOtpEmail();
                                    } else {
                                      CustomSnackBar.error(
                                        errorList: ['Please enter 6-digit OTP'],
                                      );
                                    }
                                  }),
                            ],
                          ),
                        )),

                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('Marital Status'),
                        )),
                    Obx(
                      () => Row(
                        children: [
                          // Single option
                          Expanded(
                              flex: 3,
                              child: InkWell(
                                onTap: () => controller.toggleSingleMarried(
                                    false), // Set to false to indicate 'Single'
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: !controller.isMarried
                                              .value // Highlight if not married
                                          ? AppColors.cardFillColor
                                          : AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: !controller.isMarried
                                                  .value // Adjust border color
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
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                  color: AppColors.blackColor)),
                                          child: Center(
                                            child: !controller.isMarried
                                                    .value // Show icon if single
                                                ? const Icon(
                                                    Icons.circle,
                                                    color:
                                                        AppColors.accentColor,
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
                              )),
                          // Married option
                          Expanded(
                            flex: 3,
                            child: InkWell(
                              onTap: () => controller.toggleSingleMarried(
                                  true), // Set to true to indicate 'Married'
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: controller.isMarried
                                            .value // Highlight if married
                                        ? AppColors.cardFillColor
                                        : AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: controller.isMarried
                                                .value // Adjust border color
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
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                color: AppColors.blackColor)),
                                        child: Center(
                                          child: controller.isMarried
                                                  .value // Show icon if married
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
                                        child: Text('Married'))
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    controller.isMarried.value
                        ? marridWidget(
                            controller) // Display when isMarried is true
                        : singleWidget(
                            controller), // Display when isMarried is false

                    const Divider(),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0, bottom: 10),
                          child: Text('Additional Details'),
                        )),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormTextField(
                            inputFormatter: [
                              // FilteringTextInputFormatter.allow(RegExp(r'^\d{12}$')),
                              LengthLimitingTextInputFormatter(12),
                              UpperCaseTextFormatter()
                            ],
                            enableInputFormatting: true,
                            labelText: 'PAN Number',
                            controller: controller.panNumberController,
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
                            onChanged: (value) {
                              controller.checkPanNumber(value);
                            },
                            suffixIcon: _buildSuffixIconPanCard(controller)),
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 0, bottom: 5, right: 8, left: 8),
                          child: Text(
                            'Policy will be issued under your PAN registered name',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        controller.panVerified.value
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 8, top: 5),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.green, size: 20),

                                    // Use the controller's method to format the full name
                                    Text(
                                      controller.formatFullName(
                                          controller.fullNameController.text),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    Obx(
                      () => FormTextField(
                          labelText: 'Aadhaar Number',
                          keyboardType: TextInputType.number,
                          readOnly: controller.aadharOtpVerified.value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Aadhar number';
                            } else if (!RegExp(r'^\d{12}$').hasMatch(value)) {
                              // Regular expression for a 12-digit number
                              return 'Please enter a valid 12-digit Aadhar number';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.checkAadharNumber(value);
                          },
                          suffixIcon: _buildSuffixIconAadhar(controller),
                          controller: controller.aadharNumberController),
                    ),

                    Obx(() => Visibility(
                          visible: controller.isAadharOtpFieldVisible.value &&
                              !controller.aadharOtpVerified.value,
                          child: Row(
                            children: [
                              Expanded(
                                child: FormTextField(
                                  labelText: 'Enter OTP',
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter  OTP';
                                    } else if (value.length != 6) {
                                      // Assuming a 4-digit OTP
                                      return 'Please enter a valid  OTP';
                                    }
                                    return null;
                                  },
                                  controller: controller.aadharOtPController,
                                ),
                              ),
                              CustomButton(
                                  buttonText: 'Submit',
                                  width: 80,
                                  textColor: AppColors.whiteColor,
                                  isLoading:
                                      controller.isAadharOtpVerifying.value,
                                  height: 43,
                                  onPressed: () {
                                    if (controller
                                            .aadharOtPController.text.length ==
                                        6) {
                                      controller.submitAadharOtp();
                                    } else {
                                      CustomSnackBar.error(
                                        errorList: ['Please enter valid OTP'],
                                      );
                                    }
                                  }),
                            ],
                          ),
                        )),

                    Obx(
                      () => CustomDropdown(
                        labelText: 'Education Qualification',
                        options: const [
                          "High School",
                          "Associate Degree",
                          "Bachelor's Degree",
                          "Master's Degree",
                          "PhD",
                        ],
                        currentValue: controller.currentQualificationSelection
                            .value, // This needs to be managed in your controller
                        onChanged: (newValue) {
                          controller.onChange(newValue,
                              controller.currentQualificationSelection);
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please select your education qualification'
                            : null,
                      ),
                    ),

                    Obx(
                      () => CustomDropdown(
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
                        currentValue: controller.currentPurposeSelection.value,
                        labelText: 'Purpose of Loan',
                        onChanged: (newValue) {
                          controller.onChange(
                              newValue, controller.currentPurposeSelection);
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please select a purpose for the loan'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: Colors
                                      .grey, // Color for the unchecked checkbox
                                ),
                                child: Obx(
                                  () => Checkbox(
                                      value: controller.isPrivacyAccepted.value,
                                      onChanged: (value) {
                                        controller.isPrivacyAccepted.value =
                                            value!;
                                      }),
                                )),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Row(
                            children: [
                              Text(MyStrings.iAgreeWith.tr,
                                  style: interRegularDefault.copyWith(
                                      color: MyColor.colorBlack)),
                              const SizedBox(width: 3),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(RouteHelper.privacyScreen);
                                },
                                child: Text(
                                    MyStrings.privacyPolicies.tr.toLowerCase(),
                                    style: interBoldDefault.copyWith(
                                        color: MyColor.primaryColor,
                                        decoration: TextDecoration.underline,
                                        fontSize: Dimensions.fontSmall,
                                        decorationColor: MyColor.primaryColor)),
                              ),
                              const SizedBox(width: 3),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      buttonText: 'Check Eligibility',
                      onPressed: () => controller.submitEligibilityForm(),
                      isLoading: controller.submitLoading,
                      textColor: AppColors.whiteColor,
                    ),
                    const SizedBox(
                      height: 12,
                    )
                  ],
                ),
              );
            }),
          ),
        ]),
      ),
    );
  }

  Widget marridWidget(EligibilityCheckerController controller) {
    return Column(
      children: [
        FormTextField(
          labelText: 'Spouse Name',
          controller: controller.spouseNameController,
          validator: (value) =>
              value!.isEmpty ? 'Please enter spouse name' : null,
        ),
        FormTextField(
          labelText: 'No. of Kids',
          controller: controller.noOfKidsController,
          validator: (value) =>
              value!.isEmpty ? 'Please enter  no. of kinds' : null,
        ),
      ],
    );
  }

  Widget singleWidget(EligibilityCheckerController controller) {
    return Column(
      children: [
        FormTextField(
          labelText: 'Mother Name',
          controller: controller.motherNameController,
          validator: (value) =>
              value!.isEmpty ? 'Please enter mother name' : null,
        ),
      ],
    );
  }
}

class CustomRadio extends StatelessWidget {
  final Gender _gender;

  const CustomRadio(this._gender, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: _gender.isSelected ? const Color(0xFF3B4257) : Colors.white,
        child: Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              Text(
                _gender.name,
                style: TextStyle(
                    color: _gender.isSelected ? Colors.black : Colors.grey),
              )
            ],
          ),
        ));
  }
}

class Gender {
  String name;
  bool isSelected;

  Gender(this.name, this.isSelected);
}
