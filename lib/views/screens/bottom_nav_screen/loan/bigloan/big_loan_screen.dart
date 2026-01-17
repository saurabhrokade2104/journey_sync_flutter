
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/data/repo/loan/loan_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/bigloan/bank_details.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/bigloan/contact_form.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/bigloan/employment_form.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/bigloan/upload_doc_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/data/controller/bank/bank_detail_controller.dart';
import 'package:finovelapp/data/controller/kyc_controller/kyc_controller.dart';
import 'package:finovelapp/data/controller/loan/big_loan_controller.dart';
import 'package:finovelapp/data/repo/bank/bank_detail_repo.dart';
import 'package:finovelapp/data/repo/kyc/kyc_repo.dart';

import '../../../../../core/utils/colors.dart';

class BigLoanSteps extends StatefulWidget {
   const  BigLoanSteps({super.key});

  @override
  State<BigLoanSteps> createState() => _BigLoanStepsState();
}

class _BigLoanStepsState extends State<BigLoanSteps> {
  late BigLoanApplyController bigLoanApplyController;

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

     bigLoanApplyController = Get.put(BigLoanApplyController(
      loanRepo: Get.find(),
    ));

    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   bigLoanApplyController = controller;
    //   // controller.retriveEligibilityFormUserData();
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset('assets/images/header_bg.png',
            fit: BoxFit.fill, width: double.infinity, height: 180),
         Padding(
          padding: const  EdgeInsets.only(left: 10.0, top: 60),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const  Row(
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
          padding: EdgeInsets.only(left: 10.0, top: 95, right: 10),
          child: Row(
            children: [
              Text('Loan Application',
                  style: TextStyle(
                      fontSize: 18,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w700)),
                      Spacer(),
              Text(
                '20%',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.whiteColor),
                textAlign: TextAlign.end,
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 125, right: 10),
          child: LinearProgressIndicator(
            value: 0.2,
            valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.activeLoanIndicatorColor),
            semanticsLabel: 'Linear progress indicator',
          ),
        ),
        const Padding(
            padding: EdgeInsets.only(left: 10.0, top: 140, right: 10),
            child: Text(
              'Application Completed',
              style: TextStyle(color: AppColors.whiteColor),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 200, right: 10),
          child: Column(
            children: [
              InkWell(
                onTap: ()  {
                 Get.toNamed(RouteHelper.eligibilityCheckForm,arguments: [true]);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.greyColor)),
                  child: Row(children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: AppColors.activeLoanIndicatorColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                          child: Text(
                        '1',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Expanded(
                        child: Text(
                      'Personal Details',
                      style: TextStyle(fontSize: 16),
                    )),
                    const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: AppColors.accentColor,
                        )),
                  ]),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  ContactFormScreen(bigLoanApplyController: bigLoanApplyController))),
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.greyColor)),
                  child: Row(children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: AppColors.inActiveLoanIndicatorColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                          child: Text(
                        '2',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Expanded(
                        child: Text('Contact Details',
                            style: TextStyle(fontSize: 16))),
                    const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: AppColors.accentColor,
                        )),
                  ]),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  EmploymentFormScreen(controller: bigLoanApplyController,))),
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.greyColor)),
                  child: Row(children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: AppColors.inActiveLoanIndicatorColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                          child: Text(
                        '3',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Expanded(
                        child: Text('Employment Details',
                            style: TextStyle(fontSize: 16))),
                    const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: AppColors.accentColor,
                        )),
                  ]),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () => {
                     Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  UploadDocFormScreen(loanApplyController: bigLoanApplyController,))),
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.greyColor)),
                  child: Row(children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: AppColors.inActiveLoanIndicatorColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                          child: Text(
                        '4',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Expanded(
                        child: Text('Upload Documents',
                            style: TextStyle(fontSize: 16))),
                    const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: AppColors.accentColor,
                        )),
                  ]),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  BankDetailsBigLoanScreen(loanApplyController: bigLoanApplyController,))),
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.greyColor)),
                  child: Row(children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: AppColors.inActiveLoanIndicatorColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                          child: Text(
                        '5',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Expanded(
                        child:
                            Text('Bank Details', style: TextStyle(fontSize: 16))),
                    const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: AppColors.accentColor,
                        )),
                  ]),
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greyColor),
            onPressed: () => {
              // Navigator.of(context).push(
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             const StatusScreen())),
            },
            child: const SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(
                  child: Text('SUBMIT',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                      ))),
            ),
          ),
        )
      ]),
    );
  }
}
