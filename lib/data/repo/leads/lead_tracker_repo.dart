import 'package:finovelapp/core/utils/method.dart';
import 'package:finovelapp/core/utils/url.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/data/services/api_service.dart';

class LeadApplicationTrackerRepo {
  ApiClient apiClient;

  LeadApplicationTrackerRepo({required this.apiClient});

  Future<ResponseModel> fetchLeadApplicationTracker(int leadId) async {

    String url = '${UrlContainer.baseUrl}${UrlContainer.leadApplicationTrackerEndpoint}/$leadId/tracker';
    ResponseModel model =
        await apiClient.request(url, Method.getMethod, {}, passHeader: true);
    return model;
  }
}
