import 'dart:convert';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/data/model/transaction/transfer_response_model.dart';
import 'package:finovelapp/data/repo/withdraw/transfer_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../views/components/snackbar/show_custom_snackbar.dart';


class TransferController extends GetxController {
  final TransferRepo transferRepo;
  TransferController({required this.transferRepo});

  bool isLoading = false;

  Future<bool> initiateTransfer(BuildContext context, Map<String, dynamic> transferData) async {
    isLoading = true;
    update();

    try {
      final response = await transferRepo.initiateTransfer(transferData);

      if (response.statusCode == 200) {
        TransferResponseModel model = TransferResponseModel.fromJson(jsonDecode(response.responseJson));

        if (model.status?.toLowerCase() == 'success') {
           CustomSnackBar.success(successList: model.message?.success ?? ['Transfer successful']) ;
             // ignore: use_build_context_synchronously
             showTransferSuccessDialog(context,transferData['amount']);
          return true; // Indicate success
        } else {
          CustomSnackBar.error(errorList: model.message?.error ?? ['Transfer failed']);
          return false; // Indicate failure due to API-reported error
        }
      } else {
        CustomSnackBar.error(errorList: ['Transfer failed due to server error']);
        return false; // Indicate failure due to non-200 status code
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [e.toString()]);
      return false; // Indicate failure due to exception
    } finally {
      isLoading = false;
      update(); // Notify listeners of state change
    }
  }


Future<void> showTransferConfirmationDialog(BuildContext context, Map<String, dynamic> transferData) async {
    // Use a context that is valid for the entire dialog lifecycle
    final currentContext = context;

    showDialog(
      context: currentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Confirm Transfer',
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to transfer ₹ ${transferData['amount']}?',
            style: TextStyle(fontSize: 18.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red, fontSize: 16.sp),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                initiateTransfer(currentContext, transferData); // Call transfer function with the valid context
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1769E9),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text('Confirm', style: TextStyle(fontSize: 16.sp)),
            ),
          ],
        );
      },
    );
  }

  void showTransferSuccessDialog(BuildContext context, String amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Lottie.asset(
                    "assets/animation/thanks.json",
                    height: 150.h,
                    width: 150.w,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Transfer Successful!",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Text(
                  "You have transferred",
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 5.h),
                Text(
                  "₹ $amount",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    Get.offAndToNamed(RouteHelper.bottomNavScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1769E9),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
