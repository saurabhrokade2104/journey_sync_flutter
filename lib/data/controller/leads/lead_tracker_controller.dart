import 'dart:convert';
import 'package:finovelapp/data/model/leads/lead_tracker_response_model.dart';
import 'package:finovelapp/data/repo/leads/lead_tracker_repo.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';
import 'package:get/get.dart';

class LeadApplicationTrackerController extends GetxController {
  LeadApplicationTrackerRepo leadRepo;

  LeadApplicationTrackerController({required this.leadRepo});

  Rx<LeadApplicationTrackerResponse?> trackerResponse = Rx<LeadApplicationTrackerResponse?>(null);
  RxBool isLoading = false.obs;

  Future<void> fetchApplicationTracker(int leadId) async {
    isLoading.value = true;
    update();

    try {
      final response = await leadRepo.fetchLeadApplicationTracker(leadId);

      if (response.statusCode == 200) {
        final responseModel = LeadApplicationTrackerResponse.fromJson(
          jsonDecode(response.responseJson),
        );

        if (responseModel.status?.toLowerCase() == 'success') {
          trackerResponse.value = responseModel;
        } else {
          CustomSnackBar.error(
            errorList: responseModel.message?.error ?? ['Something went wrong'],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [response.message]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: ['Something went wrong']);
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
