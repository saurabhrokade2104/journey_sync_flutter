import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/data/controller/leads/add_new_leads_controller.dart';
import 'package:finovelapp/data/model/leads/lead_form_model.dart';
import 'package:finovelapp/data/repo/leads/add_lead_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/buttons/custom_button.dart';
import 'package:finovelapp/views/components/text-field/form_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../data/controller/account/profile_controller.dart';
import '../../../data/repo/account/profile_repo.dart';

class AddNewLeadsScreen extends StatefulWidget {
  const AddNewLeadsScreen({super.key});

  @override
  State<AddNewLeadsScreen> createState() => _AddNewLeadsScreenState();
}

class _AddNewLeadsScreenState extends State<AddNewLeadsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(AddLeadFormRepo(apiClient: Get.find()));
    Get.put(ProfileRepo(
      apiClient: Get.find(),
    ));

    final controller =
        Get.put(AddNewLeadsController(addLeadFormRepo: Get.find()));

    final profileController =
        Get.put(ProfileController(profileRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.referralCodeController.text =
          profileController.model.data?.user?.referralCode ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                  child: Image.asset(
                    'assets/imgs/header_bg1.png',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: 190.h,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 42.h,
                    left: 20.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0.w, vertical: 8.0.h),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.popAndPushNamed(
                                  context, '/referralscreen'),
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.0.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios,
                                      size: 15.sp,
                                      color: AppColors.whiteColor,
                                    ),
                                    const Text(
                                      'BACK',
                                      style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0.w),
                        child: Row(
                          children: [
                            Text(
                              'Add New Lead Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // const Spacer(),
                            // GestureDetector(
                            //   onTap: () {},
                            //   child: Padding(
                            //     padding: EdgeInsets.all(8.r),
                            //     child: Icon(
                            //       Icons.share,
                            //       size: 25.sp,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.0.h),
              child: GetBuilder<AddNewLeadsController>(builder: (controller) {
                return Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "FILL-UP THE LEAD DETAILS",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 20.h),
                      // textField("Full Name", "Full Name"),
                      FormTextField(
                        labelText: 'Full Name',
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter full name' : null,
                        controller: controller.fullNameController,
                      ),
                      SizedBox(height: 20.h),
                      FormTextField(
                        labelText: 'Mobile Number',
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          } else if (value.length != 10) {
                            return 'Please enter a valid 10-digit phone number';
                          }
                          return null;
                        },
                        controller: controller.mobileNumberController,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 20.h),
                      FormTextField(
                        labelText: 'Email (Optional)',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // No validation if the field is empty
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 20.h),
                      FormTextField(
                        labelText: 'PAN (Optional)',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // No validation if the field is empty
                          } else if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')
                              .hasMatch(value)) {
                            // Regular expression for PAN format
                            return 'Please enter a valid PAN number';
                          }
                          return null;
                        },
                        controller: controller.pancardNumberController,
                      ),
                      SizedBox(height: 20.h),
                      // textField("Aadhar Number", "Aadhar Number"),
                      FormTextField(
                        labelText: 'Aadhaar (Optional)',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // No validation if the field is empty
                          } else if (!RegExp(r'^\d{12}$').hasMatch(value)) {
                            // Regular expression for a 12-digit Aadhaar number
                            return 'Please enter a valid 12-digit Aadhaar number';
                          }
                          return null;
                        },
                        controller: controller.aadharNumberController,
                      ),
                      SizedBox(height: 20.h),
                      FormTextField(
                        labelText: 'Area Pincode',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid pincode number';
                          } else if (value.length != 6) {
                            return 'Please enter a valid 6-digit pincode number';
                          }
                          return null;
                        },
                        controller: controller.areaPincodeController,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20.h),
                     // Category Dropdown
                    Obx(() => dropdownField(
                      labelText: "Select Product Type",
                      hintText: "Choose a product type",
                      items: controller.subcategories.keys.toList(),
                      onChanged: (String? newValue) {
                        controller.selectedCategory.value = newValue ?? '';
                        controller.selectedSubcategory.value = ''; // Reset subcategory when category changes
                      },
                      value: controller.selectedCategory.value.isNotEmpty
                          ? controller.selectedCategory.value
                          : null,
                    )),
                      SizedBox(height: 20.h),

                      // Subcategory Dropdown - only show if a category is selected
                    Obx(() {
                      if (controller.selectedCategory.value.isEmpty) {
                        return const  SizedBox(); // Return an empty widget if no category is selected
                      }
                      return dropdownField(
                        labelText: "Select Specific Product",
                        hintText: "Choose a specific product",
                        items: controller.getSubcategories(controller.selectedCategory.value),
                        onChanged: (String? newValue) {
                          controller.selectedSubcategory.value = newValue ?? '';
                        },
                        value: controller.selectedSubcategory.value.isNotEmpty
                            ? controller.selectedSubcategory.value
                            : null,
                      );
                    }),
                    SizedBox(height: 20.h),
                      FormTextField(
                        labelText: 'Monthly in Hand Income',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid income ';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: controller.monthlyIncomeController,
                      ),
                      SizedBox(height: 20.h),
                      // Dropdown for Source of Income
                      Obx(() => dropdownField(
                            labelText: "Source of Income",
                            hintText: "Source of Income",
                            items: ['Salaries', 'Self-Employed', 'Unemployed'],
                            onChanged: (String? newValue) {
                              controller.selectedIncomeSource.value =
                                  newValue ?? '';
                            },
                            value: controller.selectedIncomeSource.value
                                        .isNotEmpty &&
                                    [
                                      'Salaries',
                                      'Self-Employed',
                                      'Unemployed'
                                    ].contains(
                                        controller.selectedIncomeSource.value)
                                ? controller.selectedIncomeSource.value
                                : null,
                          )),
                      SizedBox(height: 20.h),
                      FormTextField(
                        labelText: 'Required Loan Amount',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid loan amount';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: controller.requiredLoanAmountController,
                      ),
                      SizedBox(height: 20.h),
                      // Dropdown for Type of Lead
                      Obx(() => dropdownField(
                            labelText: "Type of Lead",
                            hintText: "Type of Lead",
                            items: ['Hot Lead', 'Warm Lead', 'Cold Lead'],
                            onChanged: (String? newValue) {
                              controller.selectedLeadType.value =
                                  newValue ?? '';
                            },
                            value:
                                controller.selectedLeadType.value.isNotEmpty &&
                                        [
                                          'Hot Lead',
                                          'Warm Lead',
                                          'Cold Lead'
                                        ].contains(
                                            controller.selectedLeadType.value)
                                    ? controller.selectedLeadType.value
                                    : null,
                          )),
                      SizedBox(height: 20.h),
                      // // New fields for Company Code, Transaction ID, and Billing ID
                      // FormTextField(
                      //   labelText: 'Company Code',
                      //   validator: (value) =>
                      //       value!.isEmpty ? 'Please enter company code' : null,
                      //   controller: controller.companyCodeController,
                      // ),
                      // SizedBox(height: 20.h),
                      // FormTextField(
                      //   labelText: 'Transaction ID',
                      //   validator: (value) => value!.isEmpty
                      //       ? 'Please enter transaction ID'
                      //       : null,
                      //   controller: controller.transactionIdController,
                      // ),
                      // SizedBox(height: 20.h),
                      SizedBox(height: 70.h),
                      FormTextField(
                        labelText: 'Add Referral Code',
                        controller: controller.referralCodeController,
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Obx(() => Checkbox(
                                      value: controller.isCheckedPrivacy.value,
                                      onChanged: (bool? value) {
                                        controller.isCheckedPrivacy.value =
                                            value ?? false;
                                      },
                                      fillColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                              (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.selected)) {
                                          return Colors.blue;
                                        }
                                        return Colors.white;
                                      }),
                                      checkColor: Colors.white,
                                    )),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'I have read the ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                        TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => Get.toNamed(
                                                RouteHelper
                                                    .termsServicesScreen),
                                          text:
                                              'Privacy Policy, Terms & Condition.',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Obx(() => Checkbox(
                                      value: controller.isCheckedNotify.value,
                                      onChanged: (bool? value) {
                                        controller.isCheckedNotify.value =
                                            value ?? false;
                                      },
                                      fillColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                              (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.selected)) {
                                          return Colors.blue;
                                        }
                                        return Colors.white;
                                      }),
                                      checkColor: Colors.white,
                                    )),
                                const Expanded(
                                  child: Text(
                                    'I Agree to get Call & Notification on SMS, Email for next Application Process.',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            CustomButton(
                                buttonText: 'SUBMIT',
                                fontSize: 20.sp,
                                width: double.infinity,
                                textColor: AppColors.whiteColor,
                                isLoading: controller.submitLoading,
                                height: 55.h,
                                onPressed: () {
                                  controller.submitLeadDataForm(context);
                                }),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

Widget dropdownField({
  required String? value,
  required String hintText,
  required List<String> items,
  required void Function(String?) onChanged,
  required String labelText,
}) {
  return DropdownButtonHideUnderline(
    child: DropdownButton2<String>(
      isExpanded: true,
      hint: Row(
        children: [
          Expanded(
            child: Text(
              hintText,
            ),
          ),
        ],
      ),
      items: items
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                ),
              ))
          .toList(),
      value: value,
      onChanged: onChanged,
      buttonStyleData: ButtonStyleData(
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: Colors.grey.shade400,
          ),
        ),
      ),
      iconStyleData: IconStyleData(
        icon: const Icon(
          Icons.keyboard_arrow_down_outlined,
        ),
        iconSize: 28.sp,
      ),
      dropdownStyleData: DropdownStyleData(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        maxHeight: 500.h,
        width: 385.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        height: 40.h,
        padding: EdgeInsets.only(left: 10.w, right: 25.w),
      ),
    ),
  );
}
