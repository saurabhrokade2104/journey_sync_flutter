import 'dart:convert';

import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/data/model/authorization/authorization_response_model.dart';
import 'package:finovelapp/data/model/bank/bank_detail.dart';
import 'package:get/get.dart';

import '../../../core/utils/my_strings.dart';
import '../../../views/components/snackbar/show_custom_snackbar.dart';

import '../../repo/bank/bank_detail_repo.dart';

class BankDetailsController extends GetxController {
  final BankDetailsRepo bankDetailsRepo;
  BankDetailsController({required this.bankDetailsRepo});

  bool isLoading = false;

  Future<bool> submitBankDetails(BankDetails bankDetails,{bool navigate =true}) async {
  isLoading = true;
  update();

  try {
    final response = await bankDetailsRepo.submitBankData(bankDetails);

    if (response.statusCode == 200) {
      AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson(jsonDecode(response.responseJson));

      if (model.status.toString().toLowerCase() == MyStrings.success.toLowerCase()) {
       navigate ?   CustomSnackBar.success(successList: model.message?.success ?? [MyStrings.success]) : null;
        // Navigate away or perform success actions

        navigate ? Get.offAndToNamed(RouteHelper.bottomNavScreen) : null; // Assuming immediate navigation is desired upon success
        return true; // Indicate success
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
        return false; // Indicate failure due to API-reported error
      }
    } else {
      // Handle non-200 status code as an error
      CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
      return false; // Indicate failure due to non-200 status code
    }
  } catch (e) {
    // Handle any exceptions that occurred during the API call
    CustomSnackBar.error(errorList: [e.toString()]);
    return false; // Indicate failure due to exception
  } finally {
    isLoading = false; // Ensure isLoading is set to false upon completion or failure
    update(); // Notify listeners of state change
  }
}



  Future<bool> submitUpiDetails(String upiId, {bool navigate =true}) async {
    isLoading = true;
    update();

    try {
        final response = await bankDetailsRepo.submitUpiData(upiId);

        if (response.statusCode == 200) {
            AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(response.responseJson));
            if (model.status.toString().toLowerCase() == MyStrings.success.toLowerCase()) {
                navigate ?  CustomSnackBar.success(successList: model.message?.success ?? [MyStrings.success]) : null;
                navigate ?  Get.offAndToNamed(RouteHelper.bottomNavScreen) : null; // Assuming immediate navigation is desired upon success
                return true; // Indicate success
            } else {
                CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
                return false; // Indicate failure due to API-reported error
            }
        } else {
            // Handle non-200 status code as an error
            CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
            return false; // Indicate failure due to non-200 status code
        }
    } catch (e) {
        // Handle any exceptions that occurred during the API call
        CustomSnackBar.error(errorList: [e.toString()]);
        return false; // Indicate failure due to exception
    } finally {
        isLoading = false; // Ensure isLoading is set to false upon completion or failure
        update(); // Notify listeners of state change
    }
}

}
