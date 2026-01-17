import 'dart:convert';

import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/data/model/leads/lead_fetch_model.dart';

import 'package:finovelapp/data/repo/leads/lead_repo.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';

import 'package:get/get.dart';


class LeadController extends GetxController {
  LeadRepo leadRepo;

  LeadController({required this.leadRepo}) {
    // Debug/demo values initialization
    assert(() {
      return true;
    }());
  }

  bool submitLoading = false;
  RxList<Lead> leads = <Lead>[].obs;
   RxList<Lead> filteredLeads = <Lead>[].obs; // Add a list for filtered leads

  Future<void> fetchLeads(String? status) async {
    submitLoading = true;
    update();

    try {
      final response = await leadRepo.fetchLeads();

      if (response.statusCode == 200) {
        final responseModel = LeadFetchResponseModel.fromJson(
          jsonDecode(response.responseJson),
        );

        if (responseModel.status?.toLowerCase() ==
            MyStrings.success.toLowerCase()) {
          leads.value = responseModel.data?.leads ?? [];
            filteredLeads.value = status == 'all'
              ? leads
              : leads.where((lead) => lead.status?.toLowerCase() == status?.toLowerCase()).toList();
        } else {
          // Log the error details
          print('Error in response: ${responseModel.message?.error}');
          CustomSnackBar.error(
            errorList: responseModel.message?.error ??
                [MyStrings.somethingWentWrong.tr],
          );
        }
      } else {
        CustomSnackBar.error(
          errorList: [response.message],
        );
      }
    } catch (e, stacktrace) {
      // Catch any unexpected errors and log them for debugging
      print('Unexpected error: $e');
      print('Stacktrace: $stacktrace');

      CustomSnackBar.error(
        errorList: [MyStrings.somethingWentWrong.tr],
      );
    } finally {
      // Ensure that loading state is reset
      submitLoading = false;
      update();
    }
  }
void searchLeads(String query) {
  if (query.isEmpty) {
    filteredLeads.value = leads;
  } else {
    final lowerCaseQuery = query.toLowerCase();
    filteredLeads.value = leads.where((lead) {
      final leadId = lead.id?.toString() ?? '';
      final mobileNumber = lead.mobileNumber ?? '';
      final fullName = lead.fullName?.toLowerCase() ?? '';

      return fullName.contains(lowerCaseQuery) ||
             mobileNumber.contains(query) ||  // No need to lowercase as mobile numbers are numeric
             leadId.contains(query);  // No need to lowercase as IDs are numeric
    }).toList();
  }
  update();
}



}
