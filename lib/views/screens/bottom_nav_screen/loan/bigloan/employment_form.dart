import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/data/controller/loan/big_loan_controller.dart';
import 'package:finovelapp/views/components/buttons/custom_button.dart';
import 'package:finovelapp/views/components/custom_drop_down.dart';
import 'package:finovelapp/views/components/text-field/form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class EmploymentFormScreen extends StatelessWidget {
final BigLoanApplyController controller;
 const EmploymentFormScreen({super.key, required this.controller});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset('assets/images/header_bg.png',
            fit: BoxFit.fill, width: double.infinity, height: 130),
        GestureDetector(
           onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.only(left: 10.0, top: 55),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  size: 15,
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
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 90),
          child: Text(
            '(3) Employment Details',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor),
          ),
        ),
        Padding(
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
              Obx(() => CustomDropdown(
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
              ),),
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
    ),
      ]),
    );
  }
}
