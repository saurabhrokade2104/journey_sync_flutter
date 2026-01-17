import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/data/controller/loan/big_loan_controller.dart';
import 'package:finovelapp/views/components/buttons/custom_button.dart';
import 'package:finovelapp/views/components/text-field/form_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactFormScreen extends StatelessWidget {
  final BigLoanApplyController bigLoanApplyController;
  const ContactFormScreen({super.key, required this.bigLoanApplyController});

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
            '(2) Contact Details',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor),
          ),
        ),
        GetBuilder<BigLoanApplyController>(
          init: bigLoanApplyController,
          builder: (loanApplyController) {
            return Padding(
              padding: const EdgeInsets.only(
                  top: 150.0, left: 10, right: 10, bottom: 5),
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
                          controller:
                              loanApplyController.currentAddressController),
                      FormTextField(
                          labelText: 'Locality/Village',
                          controller: loanApplyController.localityController),
                      FormTextField(
                          labelText: 'Near Landmark',
                          controller: loanApplyController.landmarkController),
                      FormTextField(
                          labelText: 'City/District',
                          controller:
                              loanApplyController.cityDistrictController),
                      FormTextField(
                          labelText: 'State',
                          controller: loanApplyController.stateController),
                      FormTextField(
                        labelText: 'Pincode',
                        controller: loanApplyController.pincodeController,
                        onChanged: (value) {
                          if (value.length == 6) {
                            loanApplyController
                                .fetchCityAndStateFromPincode(value);
                          }
                        },
                      ),
                      Obx(
                        () => CupertinoFormRow(
                          prefix: const Text("Same as Current Address"),
                          child: CupertinoSwitch(
                            value:
                                loanApplyController.isSameAsCurrentAddress.value,
                            onChanged: (bool value) {
                              loanApplyController.isSameAsCurrentAddress.value =
                                  value;
                              if (loanApplyController
                                  .isSameAsCurrentAddress.value) {
                                loanApplyController.autoFillPermanentAddress();
                              } else {
                                // Clear permanent address fields when unchecked
                                loanApplyController
                                    .permanentAddressController
                                    .clear();
                                loanApplyController.permanentLocalityController
                                    .clear();
                                loanApplyController.permanentLandmarkController
                                    .clear();
                                loanApplyController
                                    .permanentCityDistrictController
                                    .clear();
                                loanApplyController.permanentStateController
                                    .clear();
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
                          enabled:
                              !loanApplyController.isSameAsCurrentAddress.value,
                          controller: loanApplyController
                              .permanentAddressController),
                      FormTextField(
                          labelText: 'Locality/Village',
                          enabled:
                              !loanApplyController.isSameAsCurrentAddress.value,
                          controller:
                              loanApplyController.permanentLocalityController),
                      FormTextField(
                          labelText: 'Near Landmark',
                          enabled:
                              !loanApplyController.isSameAsCurrentAddress.value,
                          controller:
                              loanApplyController.permanentLandmarkController),
                      FormTextField(
                          labelText: 'City/District',
                          enabled:
                              !loanApplyController.isSameAsCurrentAddress.value,
                          controller: loanApplyController
                              .permanentCityDistrictController),
                      FormTextField(
                          labelText: 'State',
                          enabled:
                              !loanApplyController.isSameAsCurrentAddress.value,
                          controller:
                              loanApplyController.permanentStateController),
                      FormTextField(
                          labelText: 'Pincode',
                          enabled:
                              !loanApplyController.isSameAsCurrentAddress.value,
                          controller:
                              loanApplyController.permanentPincodeController),
                      const SizedBox(height: 10),
                      CustomButton(
                        buttonText: 'Submit & Next',
                        onPressed: () =>
                            loanApplyController.handleStepProgression(),
                        isLoading: loanApplyController.isLoading.value,
                        textColor: AppColors.whiteColor,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
