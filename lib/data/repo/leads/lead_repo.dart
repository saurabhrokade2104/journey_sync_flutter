
import 'package:finovelapp/core/utils/method.dart';
import 'package:finovelapp/core/utils/url.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';

import 'package:finovelapp/data/services/api_service.dart';

class LeadRepo {
  ApiClient apiClient;
  LeadRepo({required this.apiClient});


  Future<ResponseModel> fetchLeads() async {




    String url = '${UrlContainer.baseUrl}${UrlContainer.addLeadFormUrl}';
    ResponseModel model =
        await apiClient.request(url, Method.getMethod, {}, passHeader: true);
    return model;
  }

}