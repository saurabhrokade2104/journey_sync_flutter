import 'dart:convert';
import 'package:finovelapp/data/model/leads/summar_model.dart';
import 'package:finovelapp/data/repo/leads/summar_repo.dart';
import 'package:get/get.dart';

import '../../../core/utils/my_strings.dart';
import '../../../views/components/snackbar/show_custom_snackbar.dart';

class SalesSummaryController extends GetxController {
   final  SalesSummaryRepo salesSummaryRepo;
  SalesSummaryController({required this.salesSummaryRepo});

  RxBool isLoading = false.obs;
  Rx<SalesSummaryModel> userStatus = SalesSummaryModel().obs;




Future<void> fetchUserStatus() async {
    isLoading(true);
    try {
      final response = await salesSummaryRepo.fetchUserStatus();

      print('response check : ${response.responseJson}');

      if (response.statusCode == 200) {
        SalesSummaryModel model =
            SalesSummaryModel.fromJson(jsonDecode(response.responseJson));

        if (model.status.toString().toLowerCase() == MyStrings.success.toLowerCase()) {
          print('data retrived from summary : ${model.data}');
          userStatus(model );
        } else {
         CustomSnackBar.error(
                errorList: model.message?.error ??
                    [MyStrings.somethingWentWrong.tr]);
          isLoading(false); // Indicate failure due to API-reported error
        }
      } else {
        // Handle non-200 status code as an error
        CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
        print('Error: Non-200 status code received: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occurred during the API call
      CustomSnackBar.error(errorList: [e.toString()]);
      print('Exception caught: $e');
    } finally {
      isLoading(false); // Ensure isLoading is set to false upon completion or failure
      update(); // Notify listeners of state change
    }
  }





}
