import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/core/utils/util.dart';
import 'package:finovelapp/data/controller/loan/big_loan_controller.dart';
import 'package:finovelapp/views/components/buttons/custom_button.dart';
import 'package:finovelapp/views/components/text-field/form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class BankDetailsBigLoanScreen extends StatelessWidget {
  final BigLoanApplyController loanApplyController;
  const BankDetailsBigLoanScreen({super.key, required this.loanApplyController});



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
            '(5) Bank Details',
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
    ),
      ]),
    );
  }

  Widget bankDetails(BigLoanApplyController loanApplyController) {
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

 Widget upiDetails(BigLoanApplyController loanApplyController) {
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
