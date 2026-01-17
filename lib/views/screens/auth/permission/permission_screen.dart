
import 'package:finovelapp/data/repo/auth/permission_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/colors.dart';
import '../../../../data/controller/auth/permission_controller.dart';
import '../../../../data/services/api_service.dart';



class PermissonScreen extends StatefulWidget {
  const PermissonScreen({super.key});

  @override
  State<PermissonScreen> createState() => _PermissonScreenState();
}

class _PermissonScreenState extends State<PermissonScreen> {
  @override
  void initState() {
     Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(PermissionDetailsRepo(
      apiClient: Get.find(),
    ));
    Get.put(PermissionController(permissionDetailsRepo: Get.find()));
    super.initState();
  }



  // Future<List<SmsMessage>> _collectSMSData() async {
  //   return telephony.getInboxSms(columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE]);
  // }



 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          _buildHeader(),
          _buildPermissionDetails(),
          _buildActionButtons(),
        ]),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(children: [
      Container(
                  height: 140,
                  decoration: const BoxDecoration(
                      color: AppColors.accentColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12))),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'FINOVEL',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TitilliumWeb',
                              fontWeight: FontWeight.w700,
                              color: AppColors.whiteColor),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Hi, there',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor),
                      ),
                    ],
                  ),
                ),
    ]);
  }



  Widget _buildActionButtons() {
    return Column(
      children: [
        const SizedBox(height: 30,),
        // Use GetBuilder to listen to changes in the controller
        GetBuilder<PermissionController>(
          builder: (controller) {
            return controller.isLoading
                ? const CircularProgressIndicator()
                : _buildButton(
                    'GRANT PERMISSION',
                    AppColors.primaryColor,
                    AppColors.whiteColor,
                    controller.requestAndSendPermissions,
                  );
          },
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor, [VoidCallback? onPressed]) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: bgColor),
      onPressed: onPressed ?? () => Navigator.pop(context),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionDetails() {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          children:[
            Text(
                        'Permission Required',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.blackColor),
                      ),
                       SizedBox(height: 20,),
                      Text(
                        'To assess your eligibility and facilitate quick approval of your loan, we need permissions to access your SMS, Camera, Location, Contacts, Storage & Phones',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.blackColor),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.sms,
                      //       color: AppColors.accentColor,
                      //        size: 18,
                      //     ),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Text(
                      //       'SMS',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w700,
                      //           fontSize: 18,
                      //           color: AppColors.accentColor),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Text(
                      //   'This app collects transactional SMS data like sender names, SMS body, received time and transmits the data to third parties. This data is used to understand your income, spending patterns which help us in the credit evaluation and help us in facilitating higher limits, faster approval rates. We do not read any personal or OTP messages.',
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w400,
                      //       fontSize: 12,
                      //       color: AppColors.blackColor),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Row(
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.accentColor,
                             size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Camera',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: AppColors.accentColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Allows you to capture images of KYC documents for your loan application',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.blackColor),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.accentColor,
                             size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Location',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: AppColors.accentColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'This app collects location details one time to verify your location and current address, to ensure serviceability and to identify unusual activity to prevent against any fraud, we do not collect location when app is in background.',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.blackColor),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.contacts,
                            color: AppColors.accentColor,
                             size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Contacts',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: AppColors.accentColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'We collect, upload your contact & monitor your contact information which includes name, phone number, number of contacts, count of contacts with phone number, contacts created monthly to detect the fraudulent behavior and assess your credit worthiness. This data is required for the purpose of risk analysis, to enable us to detect credible references, assessment of your risk profile and further determine your loan eligibility.',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.blackColor),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.storage_outlined,
                            color: AppColors.accentColor,
                             size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Storage',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: AppColors.accentColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Allows you to upload documents and pictures for your loan application',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.blackColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.phone,
                      //       color: AppColors.accentColor,
                      //        size: 20,
                      //     ),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Text(
                      //       'Phone',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w700,
                      //           fontSize: 18,
                      //           color: AppColors.accentColor),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Text(
                      //   'This app collects and monitor specific information about your device including your hardware model, operating system and version, unique device identifiers like IMEI and serial number, user profile information to uniquely identify the devices and ensure that unauthorized devices are not able to act on your behalf to prevent frauds.',
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w400,
                      //       fontSize: 12,
                      //       color: AppColors.blackColor),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.account_box,
                      //       color: AppColors.accentColor,
                      //        size: 20,
                      //     ),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Text(
                      //       'Accounts',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w700,
                      //           fontSize: 18,
                      //           color: AppColors.accentColor),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Text(
                      //   'This app collects and monitor list of account information like account names, account types in your device for credit profile enrichment.',
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w400,
                      //       fontSize: 12,
                      //       color: AppColors.blackColor),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.apps,
                      //       color: AppColors.accentColor,
                      //        size: 20,
                      //     ),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Text(
                      //       'Apps',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w700,
                      //           fontSize: 18,
                      //           color: AppColors.accentColor),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Text(
                      //   'This app collects details of your installed applications to understand your profile. This helps us give quicker approvals and higher credit limits.',
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w400,
                      //       fontSize: 12,
                      //       color: AppColors.blackColor),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.call_end,
                      //       color: AppColors.accentColor,
                      //       size: 20,
                      //     ),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Text(
                      //       'Call log',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w700,
                      //           fontSize: 18,
                      //           color: AppColors.accentColor),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Text(
                      //   'This app uses call logs permission to validate your phone number using missed call. In addition to it, details of your aggregated call information is collected to understand your profile. This helps us give quicker approvals and higher credit limits. We do not read the.',
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w400,
                      //       fontSize: 12,
                      //       color: AppColors.blackColor),
                      // ),
          ],
        ),
      ),
    );
  }
}
